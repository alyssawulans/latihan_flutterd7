import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/day_13/welcome_screen.dart';

void main() {
  runApp(const RuasApp());
}

class RuasApp extends StatelessWidget {
  const RuasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RUAS (Ruang Napas)',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF4F8FB),
        fontFamily: 'Poppins',
        primaryColor: const Color(0xFF1A2E44),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A2E44),
          primary: const Color(0xFF1A2E44),
          secondary: Colors.teal,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFFF4F8FB),
          iconTheme: IconThemeData(color: Color(0xFF1A2E44)),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}
