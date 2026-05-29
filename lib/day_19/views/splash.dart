import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/button_navi.dart';
import 'package:latihan_flutterd7/day_13/tugas6flutter.dart';
import 'package:latihan_flutterd7/day_19/database/preference_handler.dart';
import 'package:latihan_flutterd7/extension/navigator.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 5));
    // Contoh saat proses login berhasil
    print(PreferenceHandler.isLogin);

    if (!mounted) return;
    if (PreferenceHandler.isLogin) {
      context.pushAndRemoveAll(Bottomnavi());
    } else {
      context.pushAndRemoveAll(Tugas6flutter1());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Warna tema hijau laut dari logo
    const Color temaHijau = Colors.teal;
    const Color teksAbu = Color(0xFF757575);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Latar belakang gradasi radial halus
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Colors.white, // Lebih terang di tengah
              Color(0xFFF5F5F5), // Abu-abu muda di pinggir
            ],
            center: Alignment.center,
            radius: 1.0,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Jarak dari atas layar
              const SizedBox(height: 100),

              // Elemen Atas: Logo dan Teks Logo
              Column(
                children: [
                  // Logo Asset
                  Image.asset(
                    'assets/images/logo_ruas.png',
                    height: 100, // Sesuaikan ukuran logo
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),

                  // Teks "RUAS" besar di bawah logo
                  const Text(
                    'RUAS',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D2428),
                      letterSpacing: 1.2,
                    ),
                  ),

                  // Teks tagline kecil abu-abu
                  const Text(
                    'Ruang Napas Untuk Semua',
                    style: TextStyle(
                      fontSize: 14,
                      color: teksAbu,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),

              // Spacer untuk mendorong elemen tengah ke tengah layar
              const Spacer(flex: 2),

              // Elemen Tengah: Teks Deskripsi Tambahan
              Column(
                children: const [
                  Text(
                    'RUAS',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D2428),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ruang Napas Untuk Semua',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: temaHijau,
                    ),
                  ),
                ],
              ),

              // Spacer untuk mendorong elemen bawah ke bawah layar
              const Spacer(flex: 3),

              // Elemen Bawah: Progress Bar, Status, dan Versi
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    // Progress Bar kustom
                    SizedBox(
                      width: 150, // Batasi lebar progress bar
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: const LinearProgressIndicator(
                          value: 0.3, // Dummy progress (30%)
                          backgroundColor: Color(0xFFE0E0E0), // Abu-abu muda
                          valueColor: AlwaysStoppedAnimation<Color>(temaHijau),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Teks Status
                    const Text(
                      'Initializing Air Quality Sensors...',
                      style: TextStyle(
                        fontSize: 13,
                        color: teksAbu,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Teks Versi
                    const Text(
                      'V1.0.0',
                      style: TextStyle(
                        fontSize: 11,
                        color: teksAbu,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),

              // Jarak dari bawah layar
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
