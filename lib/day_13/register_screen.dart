import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/day_13/tugas6flutter.dart';
import 'package:latihan_flutterd7/extension/navigator.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();
  bool obscureNewPassword = true;

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Pengguna wajib klik tombol di pop-up untuk menutupnya
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              16,
            ), // Sudut melengkung biar estetik
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.teal, size: 28),
              SizedBox(width: 10),
              Text(
                "Berhasil",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A2E44), // Deep Navy RUAS
                ),
              ),
            ],
          ),
          content: const Text(
            "Selamat! Anda berhasil masuk ke aplikasi RUAS. Mari jaga udara bersih bersama.",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.pushAndRemoveAll(
                  Tugas6flutter1(),
                ); // Menutup dialog pop-up
                // Kamu bisa tambahkan navigasi pindah ke halaman utama/dashboard di sini jika ada
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Daftar Akun",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A2E44),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _registerFormKey,
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 85,
                        height: 85,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/logo_ruas.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Buat Akun",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2E44),
                        ),
                      ),
                      const Text(
                        "Mulai Langkahmu !",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Daftarkan dirimu untuk bergabung ke lingkungan bersih RUAS",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nama Lengkap",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2E44),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: _buildInputDecoration(
                          "Masukkan Nama Lengkap Anda",
                          Icons.person_outline,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "Nama Lengkap tidak boleh kosong";
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Email atau Nomor Telepon",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2E44),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: _buildInputDecoration(
                          "Masukkan Email Aktif",
                          Icons.email_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "Email tidak boleh kosong";
                          if (!value.contains("@"))
                            return "Format email tidak valid";
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Kata Sandi Baru",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2E44),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        obscureText: obscureNewPassword,
                        obscuringCharacter: "*",
                        decoration:
                            _buildInputDecoration(
                              "Buat Kata Sandi Kuat",
                              Icons.lock_outline_rounded,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscureNewPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey,
                                ),
                                onPressed: () => setState(
                                  () =>
                                      obscureNewPassword = !obscureNewPassword,
                                ),
                              ),
                            ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "Kata Sandi tidak boleh kosong";
                          if (value.length < 6)
                            return "Kata Sandi minimal harus 6 karakter";
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      // --- CARI ELEVATED BUTTON DAFTAR SEKARANG ---
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A2E44),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            // 1. Validasi input form pendaftaran
                            if (_registerFormKey.currentState!.validate()) {
                              print("Pendaftaran akun berhasil...");

                              // 2. DI SINI TEMPAT MEMANGGIL POP-UP NYA!
                              _showSuccessDialog(context);
                              context.pushAndRemoveAll(const Tugas6flutter1());
                            }
                          },

                          child: Text(
                            "Daftar Sekarang",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                Text.rich(
                  TextSpan(
                    text: "Sudah Punya Akun?",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.push(const Tugas6flutter()),
                        text: " Masuk Sekarang",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData prefixIcon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFFF8FAF9),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1.5, color: Colors.teal),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      prefixIcon: Icon(prefixIcon, color: const Color(0xFF1A2E44)),
    );
  }
}
