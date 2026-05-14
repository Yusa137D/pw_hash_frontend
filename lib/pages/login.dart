import 'package:flutter/material.dart';

import '../api_services.dart'; // Sesuaikan path jika pakai api_services.dart
import 'register.dart';
import 'admin.dart';
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
  bool _obscurePassword = true; // State untuk toggle mata password

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password harus diisi!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Mengirim email dan password ke API. 
    // Parameter method diisi string kosong karena Flask otomatis mengecek DB.
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
        SnackBar(content: Text('$welcomeMessage ($methodUsed)'), backgroundColor: Colors.green),
      );
      
      if (userRole == 'admin') {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const AdminDashboardScreen())
        );
      } else {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => UserDashboardScreen(
              username: username,
              method: methodUsed,
              strength: strength,
            )
          )
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
      appBar: AppBar(title: const Text('LOGIN USER'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword, // Gunakan state ini
                  decoration: InputDecoration(
                    labelText: 'Password', 
                    border: const OutlineInputBorder(),
                    // Tambahkan ikon mata di sini
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                      : const Text('Login', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (context) => const RegisterScreen())
                    );
                  },
                  child: const Text('Belum punya akun? Register'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}