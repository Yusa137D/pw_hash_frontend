import 'package:flutter/material.dart';

import '../api_services.dart';
import 'app_visuals.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _selectedMethod = 'MD5';
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isPasswordValid(String password) {
    String pattern = r'^(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final result = await ApiService.register(
        username: _usernameController.text,
        password: _passwordController.text,
        method: _selectedMethod,
        email: _emailController.text,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi Berhasil! Silakan Login.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSecurityBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 920;
              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 52 : 20,
                    vertical: 28,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: _RegisterIntro(isWide: isWide)),
                              const SizedBox(width: 42),
                              SizedBox(width: 520, child: _RegisterForm()),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _RegisterIntro(isWide: isWide),
                              const SizedBox(height: 24),
                              _RegisterForm(),
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

class _RegisterIntro extends StatelessWidget {
  final bool isWide;

  const _RegisterIntro({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 760),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(-20 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment:
            isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          const BrandBadge(icon: Icons.add_moderator, label: 'Secure Register'),
          const SizedBox(height: 26),
          Text(
            'Buat akun dengan password yang lebih kuat.',
            textAlign: isWide ? TextAlign.left : TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isWide ? 48 : 32,
              height: 1.08,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Pilih metode hash, isi kredensial, dan lihat panduan keamanan tanpa tampilan yang kaku.',
            textAlign: isWide ? TextAlign.left : TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(.78),
              fontSize: isWide ? 17 : 15,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 26),
          const _SecurityMeter(),
        ],
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_RegisterScreenState>()!;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: .94, end: 1),
      duration: const Duration(milliseconds: 660),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: GlassPanel(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: state._formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Register Account',
                style: TextStyle(
                  color: AppPalette.ink,
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Lengkapi data untuk mulai memakai simulasi hashing.',
                style: TextStyle(color: AppPalette.ink.withOpacity(.62)),
              ),
              const SizedBox(height: 22),
              TextFormField(
                controller: state._usernameController,
                decoration: modernInputDecoration(
                  label: 'Username',
                  icon: Icons.person_outline,
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Username tidak boleh kosong' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: state._emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: modernInputDecoration(
                  label: 'Email',
                  icon: Icons.alternate_email,
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Email tidak boleh kosong' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
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
                validator: (value) {
                  if (value!.isEmpty) return 'Password tidak boleh kosong';
                  if (!state._isPasswordValid(value)) {
                    return 'Password belum memenuhi ketentuan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: state._confirmPasswordController,
                obscureText: state._obscureConfirmPassword,
                decoration: modernInputDecoration(
                  label: 'Konfirmasi Password',
                  icon: Icons.verified_user_outlined,
                  suffixIcon: IconButton(
                    icon: Icon(
                      state._obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      state.setState(() {
                        state._obscureConfirmPassword =
                            !state._obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value != state._passwordController.text) {
                    return 'Password tidak cocok';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              const Text(
                'Metode Hashing',
                style: TextStyle(
                  color: AppPalette.ink,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              SegmentedButton<String>(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return AppPalette.navy;
                    }
                    return AppPalette.softBlue;
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return AppPalette.yellow;
                    }
                    return AppPalette.ink;
                  }),
                ),
                segments: const [
                  ButtonSegment<String>(
                    value: 'MD5',
                    label: Text('MD5'),
                    icon: Icon(Icons.memory),
                  ),
                  ButtonSegment<String>(
                    value: 'Argon2',
                    label: Text('Argon2'),
                    icon: Icon(Icons.security),
                  ),
                ],
                selected: <String>{state._selectedMethod},
                onSelectionChanged: (Set<String> newSelection) {
                  state.setState(() {
                    state._selectedMethod = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 18),
              const _PasswordRulesCard(),
              const SizedBox(height: 22),
              PrimaryGradientButton(
                label: 'Register',
                icon: Icons.person_add_alt_1,
                onPressed: state._register,
                isLoading: state._isLoading,
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text('Sudah punya akun? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecurityMeter extends StatelessWidget {
  const _SecurityMeter();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 430),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.10),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.analytics_outlined, color: AppPalette.yellow),
              SizedBox(width: 10),
              Text(
                'Password Readiness',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: .78,
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(.12),
              valueColor: const AlwaysStoppedAnimation(AppPalette.orange),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Kombinasi huruf besar, angka, dan simbol membantu akun lebih aman.',
            style: TextStyle(color: Colors.white.withOpacity(.72), height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _PasswordRulesCard extends StatelessWidget {
  const _PasswordRulesCard();

  @override
  Widget build(BuildContext context) {
    const rules = [
      'Minimal 8 karakter',
      'Menggunakan huruf besar',
      'Menggunakan angka',
      'Menggunakan simbol',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ketentuan Password',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          ...rules.map(
            (rule) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppPalette.yellow,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      rule,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
