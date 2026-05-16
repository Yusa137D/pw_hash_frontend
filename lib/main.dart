import 'package:flutter/material.dart';

// Import halaman Login dari folder pages
import 'pages/app_visuals.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppPalette.navy,
          primary: AppPalette.navy,
          secondary: AppPalette.orange,
        ),
        scaffoldBackgroundColor: AppPalette.deepNavy,
        fontFamily: 'Roboto',
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: AppPalette.ink),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppPalette.orange,
            textStyle: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
