import 'dart:math' as math;

import 'package:flutter/material.dart';

class AppPalette {
  static const navy = Color(0xFF071A33);
  static const deepNavy = Color(0xFF03101F);
  static const blue = Color(0xFF0E3A68);
  static const yellow = Color(0xFFFFD166);
  static const orange = Color(0xFFFF8A3D);
  static const softBlue = Color(0xFFEAF4FF);
  static const ink = Color(0xFF132238);
}

class AnimatedSecurityBackground extends StatefulWidget {
  final Widget child;

  const AnimatedSecurityBackground({super.key, required this.child});

  @override
  State<AnimatedSecurityBackground> createState() =>
      _AnimatedSecurityBackgroundState();
}

class _AnimatedSecurityBackgroundState extends State<AnimatedSecurityBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _SecurityBackgroundPainter(_controller.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SecurityBackgroundPainter extends CustomPainter {
  final double progress;

  _SecurityBackgroundPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppPalette.deepNavy,
          AppPalette.navy,
          AppPalette.blue,
        ],
      ).createShader(rect);

    canvas.drawRect(rect, paint);

    final beamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppPalette.yellow.withOpacity(.22),
          AppPalette.orange.withOpacity(.04),
        ],
      ).createShader(rect);
    final sweep = math.sin(progress * math.pi * 2) * 24;
    final beamPath = Path()
      ..moveTo(size.width * .06 + sweep, 0)
      ..lineTo(size.width * .34 + sweep, 0)
      ..lineTo(size.width * .72 - sweep, size.height)
      ..lineTo(size.width * .44 - sweep, size.height)
      ..close();
    canvas.drawPath(beamPath, beamPaint);

    final lowerPath = Path()
      ..moveTo(size.width, size.height * .54)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * .58, size.height)
      ..quadraticBezierTo(
        size.width * .82,
        size.height * (.74 + math.cos(progress * math.pi * 2) * .03),
        size.width,
        size.height * .54,
      );
    canvas.drawPath(
      lowerPath,
      Paint()..color = AppPalette.orange.withOpacity(.14),
    );

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(.08)
      ..strokeWidth = 1.1;
    final dotPaint = Paint()..color = AppPalette.yellow.withOpacity(.36);
    const spacing = 64.0;
    final shift = progress * spacing;

    for (double y = -spacing; y < size.height + spacing; y += spacing) {
      for (double x = -spacing; x < size.width + spacing; x += spacing) {
        final point = Offset((x + shift) % (size.width + spacing), y);
        final wave = math.sin((x + y) * .01 + progress * math.pi * 2) * 10;
        final next = point + Offset(spacing * .62, spacing * .26 + wave);
        canvas.drawLine(point, next, linePaint);
        canvas.drawCircle(point, 2.2, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SecurityBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(28),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.92),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.22),
            blurRadius: 34,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: child,
    );
  }
}

class BrandBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const BrandBadge({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppPalette.yellow.withOpacity(.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppPalette.yellow.withOpacity(.38)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppPalette.yellow, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class PrimaryGradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryGradientButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPalette.orange, AppPalette.yellow],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppPalette.orange.withOpacity(.32),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: AppPalette.navy,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: AppPalette.navy.withOpacity(.55),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                height: 19,
                width: 19,
                child: CircularProgressIndicator(strokeWidth: 2.4),
              )
            : Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

InputDecoration modernInputDecoration({
  required String label,
  required IconData icon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: AppPalette.softBlue,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: AppPalette.blue.withOpacity(.08)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: AppPalette.orange, width: 1.8),
    ),
  );
}
