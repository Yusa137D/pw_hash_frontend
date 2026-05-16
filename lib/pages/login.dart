import 'package:flutter/material.dart';

import '../api_services.dart';
import 'admin.dart';
import 'app_visuals.dart';
import 'register.dart';
import 'user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password harus diisi!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await ApiService.login(
      email: _emailController.text,
      password: _passwordController.text,
      method: '',
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['success']) {
      String welcomeMessage = result['message'];
      String methodUsed = result['method'];
      String userRole = result['role'];
      String username = result['username'];
      String strength = result['strength'] ?? 'Unknown';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$welcomeMessage ($methodUsed)'),
          backgroundColor: Colors.green,
        ),
      );

      if (userRole == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserDashboardScreen(
              username: username,
              method: methodUsed,
              strength: strength,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSecurityBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 860;
              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 52 : 20,
                    vertical: 28,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1040),
                    child: isWide
                        ? Row(
                            children: [
                              Expanded(child: _HeroCopy(isWide: isWide)),
                              const SizedBox(width: 42),
                              SizedBox(
                                width: 430,
                                child: _LoginPanel(onLogin: _login),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _HeroCopy(isWide: isWide),
                              const SizedBox(height: 26),
                              _LoginPanel(onLogin: _login),
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
}

class _HeroCopy extends StatelessWidget {
  final bool isWide;

  const _HeroCopy({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
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
      child: Column(
        crossAxisAlignment:
            isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          const BrandBadge(
            icon: Icons.enhanced_encryption,
            label: 'PW Hash Lab',
          ),
          const SizedBox(height: 28),
          Text(
            'Login aman dengan gaya modern.',
            textAlign: isWide ? TextAlign.left : TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isWide ? 52 : 34,
              height: 1.04,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Pantau metode hashing dan kekuatan password dalam tampilan yang bersih, dinamis, dan siap dipakai di desktop maupun mobile.',
            textAlign: isWide ? TextAlign.left : TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(.78),
              fontSize: isWide ? 17 : 15,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            alignment: isWide ? WrapAlignment.start : WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: const [
              _FeatureChip(icon: Icons.lock_clock, label: 'Hash aware'),
              _FeatureChip(icon: Icons.shield_outlined, label: 'Password check'),
              _FeatureChip(icon: Icons.devices, label: 'Responsive'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoginPanel extends StatelessWidget {
  final VoidCallback onLogin;

  const _LoginPanel({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_LoginScreenState>()!;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: .92, end: 1),
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: GlassPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.fingerprint, color: AppPalette.orange, size: 46),
            const SizedBox(height: 14),
            const Text(
              'Masuk Akun',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppPalette.ink,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Gunakan email dan password yang sudah terdaftar.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppPalette.ink.withOpacity(.62)),
            ),
            const SizedBox(height: 26),
            TextField(
              controller: state._emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: modernInputDecoration(
                label: 'Email',
                icon: Icons.alternate_email,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: state._passwordController,
              obscureText: state._obscurePassword,
              decoration: modernInputDecoration(
                label: 'Password',
                icon: Icons.password,
                suffixIcon: IconButton(
                  icon: Icon(
                    state._obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    state.setState(() {
                      state._obscurePassword = !state._obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            PrimaryGradientButton(
              label: 'Login',
              icon: Icons.login,
              onPressed: onLogin,
              isLoading: state._isLoading,
            ),
            const SizedBox(height: 14),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text('Belum punya akun? Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.16)),
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
