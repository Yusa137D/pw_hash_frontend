import 'package:flutter/material.dart';

import 'app_visuals.dart';
import 'login.dart';
import 'developer.dart';

class UserDashboardScreen extends StatelessWidget {
  final String username;
  final String method;
  final String strength;

  const UserDashboardScreen({
    super.key,
    required this.username,
    required this.method,
    required this.strength,
  });

  @override
  Widget build(BuildContext context) {
    final strengthColor = _strengthColor(strength);

    return Scaffold(
      body: AnimatedSecurityBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 840;

              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 48 : 20,
                    vertical: 28,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 980),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _TopBar(),
                        const SizedBox(height: 28),

                        isWide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: _WelcomePanel(username: username),
                                  ),

                                  const SizedBox(width: 24),

                                  Expanded(
                                    flex: 5,
                                    child: _SecurityPanel(
                                      method: method,
                                      strength: strength,
                                      strengthColor: strengthColor,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  _WelcomePanel(username: username),

                                  const SizedBox(height: 20),

                                  _SecurityPanel(
                                    method: method,
                                    strength: strength,
                                    strengthColor: strengthColor,
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Color _strengthColor(String value) {
    if (value.contains('Strong')) {
      return Colors.green;
    }

    if (value.contains('Very Weak')) {
      return Colors.red;
    }

    return AppPalette.orange;
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const BrandBadge(icon: Icons.shield_moon_outlined, label: 'User Vault'),

        const Spacer(),

        Tooltip(
          message: 'Developer',
          child: IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: AppPalette.yellow,
              foregroundColor: AppPalette.navy,
            ),
            icon: const Icon(Icons.groups),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DeveloperScreen()),
              );
            },
          ),
        ),

        const SizedBox(width: 12),

        Tooltip(
          message: 'Logout',
          child: IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: AppPalette.orange,
              foregroundColor: AppPalette.navy,
            ),
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            ),
          ),
        ),
      ],
    );
  }
}

class _WelcomePanel extends StatelessWidget {
  final String username;

  const _WelcomePanel({required this.username});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 720),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GlassPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 78,
              width: 78,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppPalette.yellow, AppPalette.orange],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.orange.withOpacity(.28),
                    blurRadius: 22,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_4_rounded,
                color: AppPalette.navy,
                size: 42,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Selamat datang, $username',
              style: const TextStyle(
                color: AppPalette.ink,
                fontSize: 31,
                fontWeight: FontWeight.w900,
                height: 1.15,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Akun kamu sudah masuk ke area dashboard. Informasi keamanan password diringkas agar mudah dibaca tanpa tampilan yang membosankan.',
              style: TextStyle(
                color: AppPalette.ink.withOpacity(.64),
                height: 1.55,
              ),
            ),

            const SizedBox(height: 24),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                _MiniStat(
                  icon: Icons.key,
                  label: 'Credential',
                  value: 'Active',
                ),

                _MiniStat(
                  icon: Icons.verified,
                  label: 'Session',
                  value: 'Ready',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityPanel extends StatelessWidget {
  final String method;
  final String strength;
  final Color strengthColor;

  const _SecurityPanel({
    required this.method,
    required this.strength,
    required this.strengthColor,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: .92, end: 1),
      duration: const Duration(milliseconds: 760),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: AppPalette.navy.withOpacity(.94),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.24),
              blurRadius: 30,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Status Keamanan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Ringkasan metode perlindungan akun.',
              style: TextStyle(color: Colors.white.withOpacity(.62)),
            ),

            const SizedBox(height: 24),

            _InfoTile(
              icon: Icons.lock,
              label: 'Metode Keamanan',
              value: method,
              color: AppPalette.yellow,
            ),

            const SizedBox(height: 14),

            _InfoTile(
              icon: Icons.shield,
              label: 'Kekuatan Password',
              value: strength,
              color: strengthColor,
            ),

            const SizedBox(height: 24),

            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: _progressForStrength(strength),
                minHeight: 11,
                backgroundColor: Colors.white.withOpacity(.12),
                valueColor: AlwaysStoppedAnimation(strengthColor),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Sistem memakai hashing satu arah untuk menjaga integritas data akun.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(.68),
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _progressForStrength(String value) {
    if (value.contains('Strong')) {
      return .94;
    }

    if (value.contains('Very Weak')) {
      return .22;
    }

    return .58;
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.62),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppPalette.softBlue,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppPalette.orange, size: 20),

          const SizedBox(width: 9),

          Text(
            '$label: ',
            style: TextStyle(
              color: AppPalette.ink.withOpacity(.62),
              fontWeight: FontWeight.w700,
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              color: AppPalette.ink,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
