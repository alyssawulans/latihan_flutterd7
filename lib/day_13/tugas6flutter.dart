import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/button_navi.dart';
import 'package:latihan_flutterd7/day_17/tugas10flutter.dart';
import 'package:latihan_flutterd7/day_19/database/preference_handler.dart';
import 'package:latihan_flutterd7/extension/navigator.dart';

class Tugas6flutter1 extends StatefulWidget {
  const Tugas6flutter1({super.key});

  @override
  State<Tugas6flutter1> createState() => _Tugas6flutter1State();
}

class _Tugas6flutter1State extends State<Tugas6flutter1> {
  // Deklarasi FormKey agar fungsi validator pada TextFormField bisa bekerja
  final _formKey = GlobalKey<FormState>();

  bool back = false;
  bool masuk = false;

  void _showBerhasil(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User wajib klik OK
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
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await PreferenceHandler.setLogin(true);
                Navigator.of(context).pop();

                context.pushReplacement(const Bottomnavi());
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "OK",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAllert(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Silakan periksa kembali form login Anda!"),
        backgroundColor: const Color(0xFF1A2E44),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "Kembali",
          textColor: Colors.teal[100],
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Masuk",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A2E44),
          ),
        ),
        backgroundColor: const Color(0xFFF4F8FB),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1A2E44)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // --- Input LOGO ---
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/logo_ruas.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Selamat Datang",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2E44), // Deep Navy RUAS
                        ),
                      ),
                      const Text(
                        "Kembali !",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Masuk untuk melanjutkan ke aplikasi RUAS",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // --- AREA INPUT CONTAINER ---
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
                        "Email atau Nomor Telepon",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2E44),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Masukkan Email atau Nomor Telepon",
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAF9),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              width: 1.5,
                              color: Colors.teal,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Color(0xFF1A2E44),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email Tidak Boleh Kosong";
                          } else if (!value.contains("@")) {
                            return "Format tidak lengkap (kurang '@')";
                          }
                          return null; // Mengembalikan null jika input valid
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Kata Sandi",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2E44),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        obscureText: true,
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                          hintText: "Masukkan Password",
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAF9),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              width: 1.5,
                              color: Colors.teal,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: const Icon(
                            Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: Color(0xFF1A2E44),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Kata Sandi Tidak Boleh Kosong";
                          } else if (value.length < 6 || value.length > 10) {
                            return "Kata Sandi Tidak Valid (6-10 Karakter)";
                          }
                          return null; // Mengembalikan null jika input valid
                        },
                      ),
                      const SizedBox(height: 12),

                      // Link Lupa Sandi rata kanan
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "Lupa Kata Sandi?",
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- TOMBOL MASUK UTAMA ---
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A2E44),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              print("Syarat terpenuhi, memproses login...");
                              _showBerhasil(context);
                            } else {
                              // Jika gagal validasi, baru tampilkan Alert SnackBar
                              _showAllert(context);
                            }
                          },
                          child: const Text(
                            "Masuk",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- SEPARATOR (ATAU) ---
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "atau",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // --- SOCIAL BUTTONS ---
                      _buildMasuk(
                        label: "Masuk dengan Google",
                        icon: Icons.g_mobiledata_rounded,
                        iconColor: Colors.red,
                      ),
                      const SizedBox(height: 12),
                      _buildMasuk(
                        label: "Masuk dengan Apple",
                        icon: Icons.apple,
                        iconColor: Colors.black,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),

                // --- FOOTER DAFTAR ---
                Text.rich(
                  TextSpan(
                    text: "Belum Punya Akun?",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.push(const Tugas10flutter()),
                        text: " Daftar Sekarang",
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

  // Fungsi pembantu membuat tombol sosial media yang seragam
  OutlinedButton _buildMasuk({
    required String label,
    required IconData icon,
    required Color iconColor,
  }) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {},
      icon: Icon(icon, color: iconColor, size: 24),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
