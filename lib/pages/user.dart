import 'package:flutter/material.dart';
import 'login.dart';

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
    // Menentukan warna berdasarkan tingkat kekuatan password
    Color strengthColor = strength.contains('Strong') ? Colors.green : Colors.orange;
    if (strength.contains('Very Weak')) strengthColor = Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DASHBOARD USER'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Selamat datang, $username',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 40),
                    _infoTile(Icons.lock, 'Metode Keamanan', method),
                    const SizedBox(height: 10),
                    _infoTile(
                      Icons.shield, 
                      'Kekuatan Password', 
                      strength, 
                      textColor: strengthColor
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Sistem ini menggunakan enkripsi satu arah untuk melindungi integritas data Anda.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value, {Color? textColor}) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 15),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
      ],
    );
  }
}