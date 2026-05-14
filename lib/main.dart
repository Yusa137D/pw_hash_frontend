import 'package:flutter/material.dart';

// Import halaman Login dari folder pages
import 'pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulasi Keamanan Password',
      debugShowCheckedModeBanner: false, // Menghilangkan pita "DEBUG" di pojok kanan atas
      theme: ThemeData(
        // Tema utama aplikasi menggunakan warna dasar biru
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true, // Wajib true agar SegmentedButton dan UI modern lainnya tampil sempurna
      ),
      // Menetapkan LoginScreen sebagai halaman pertama yang dimuat
      home: const LoginScreen(), 
    );
  }
}