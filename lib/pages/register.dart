import 'package:flutter/material.dart';

import '../api_services.dart'; // Sesuaikan path jika pakai api_services.dart
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
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  String _selectedMethod = 'MD5';
  bool _isLoading = false;
  
  // State untuk toggle mata password
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
          const SnackBar(content: Text('Registrasi Berhasil! Silakan Login.'), backgroundColor: Colors.green),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('REGISTER ACCOUNT'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
                    validator: (value) => value!.isEmpty ? 'Username tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                    validator: (value) => value!.isEmpty ? 'Email tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword, // Gunakan state toggle
                    decoration: InputDecoration(
                      labelText: 'Password', 
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'Password tidak boleh kosong';
                      if (!_isPasswordValid(value)) return 'Password belum memenuhi ketentuan';
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword, // Gunakan state toggle
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password', 
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) return 'Password tidak cocok';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Pilih Metode Hashing:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment<String>(value: 'MD5', label: Text('MD5')),
                      ButtonSegment<String>(value: 'Argon2', label: Text('Argon2')),
                    ],
                    selected: <String>{_selectedMethod},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _selectedMethod = newSelection.first;
                      });
                    },
                  ),

                  const SizedBox(height: 20),
                  Card(
                    color: Colors.grey[200],
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ketentuan Password:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('✓ Minimal 8 karakter'),
                          Text('✓ Menggunakan huruf besar'),
                          Text('✓ Menggunakan angka'),
                          Text('✓ Menggunakan simbol'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                        : const Text('Register', style: TextStyle(fontSize: 16)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: const Text('Sudah punya akun? Login'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}