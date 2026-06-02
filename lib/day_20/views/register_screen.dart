import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/day_20/database/db_helper.dart';
import 'package:latihan_flutterd7/day_20/models/user_model_sql.dart';
import 'package:latihan_flutterd7/day_20/views/login_screen.dart';
import 'package:latihan_flutterd7/extension/navigator.dart';

class RegisterScreen20 extends StatefulWidget {
  const RegisterScreen20({super.key});

  @override
  State<RegisterScreen20> createState() => _RegisterScreen20State();
}

class _RegisterScreen20State extends State<RegisterScreen20> {
  final _registerFormKey = GlobalKey<FormState>();
  bool obscureNewPassword = true;

  // Controller
  final TextEditingController namaidController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  // Bersihkan controller saat screen ditutup untuk menghemat RAM
  @override
  void dispose() {
    namaidController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  void register() async {
    
    if (_registerFormKey.currentState == null ||
        !_registerFormKey.currentState!.validate()) {
      return; 
    }

    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final pass = passwordController.text;
    final alamat = alamatController.text.trim();

    final user = UserModelSql(
      email: email,
      phone: phone,
      password: pass,
      alamat: alamat,
    );

    bool success = await DBHelper().registerUser(user);

    if (!mounted) return;

    if (success) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      // Bersihkan SnackBar lama jika ada
      scaffoldMessenger.clearSnackBars();

      // Tampilkan SnackBar baru
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text("Akun Berhasil Dibuat!"),
          duration: Duration(seconds: 2),
        ),
      );

      // Pindah halaman setelah SnackBar dipicu
      context.pushAndRemoveAll(const LoginScreen20());
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Email sudah Terdaftar")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F8FB),
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
                        controller: namaidController,
                        decoration: _buildInputDecoration(
                          "Masukkan Nama Lengkap Anda",
                          Icons.person_outline,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Nama Lengkap tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2E44),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: emailController,
                        decoration: _buildInputDecoration(
                          "Masukkan Email Aktif",
                          Icons.email_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Email tidak boleh kosong";
                          }
                          if (!value.contains("@")) {
                            return "Format email tidak valid";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Nomor Telepon",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2E44),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: _buildInputDecoration(
                          "Masukkan Nomor Telepon",
                          Icons.call,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Nomor Telepon tidak boleh kosong";
                          }
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
                        controller: passwordController,
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
                          if (value == null || value.isEmpty) {
                            return "Kata Sandi tidak boleh kosong";
                          }
                          if (value.length < 6) {
                            return "Kata Sandi minimal harus 6 karakter";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Alamat Tempat Tinggal",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2E44),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: alamatController,
                        decoration: _buildInputDecoration(
                          "Masukkan Alamat",
                          Icons.location_city_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Alamat tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      // --- PERBAIKAN TOMBOL DAFTAR SEKARANG ---
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
                          onPressed: register,
                          child: const Text(
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
                          ..onTap = () =>
                              context.pushAndRemoveAll(const LoginScreen20()),
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
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1.5, color: Colors.teal),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      // Diaktifkan kembali agar warna garis luar berubah merah saat eror/kosong
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      prefixIcon: Icon(prefixIcon, color: const Color(0xFF1A2E44)),
    );
  }
}
