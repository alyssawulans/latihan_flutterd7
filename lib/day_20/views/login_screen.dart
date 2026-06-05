import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/button_navi.dart';
import 'package:latihan_flutterd7/day_13/welcome_screen.dart';
import 'package:latihan_flutterd7/day_20/database/db_helper.dart';
import 'package:latihan_flutterd7/day_20/models/user_model_sql.dart';
import 'package:latihan_flutterd7/extension/navigator.dart';

class LoginScreen20 extends StatefulWidget {
  const LoginScreen20({super.key});

  @override
  State<LoginScreen20> createState() => _LoginScreen20State();
}

class _LoginScreen20State extends State<LoginScreen20> {
  final _loginFormKey = GlobalKey<FormState>();
  bool obscurePassword = true;
  bool isCheck = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();

    final loginUserObj = UserModelSql(
      nama: "",
      email: email,
      phone: "",
      password: pass,
      alamat: "",
    );

    final pengguna = await DBHelper().loginUser(loginUserObj);
    if (!mounted) return;

    if (pengguna != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selamat datang kembali, ${pengguna.nama}!')),
      );
      context.pushAndRemoveAll(const Bottomnavi());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login gagal! Email atau Password salah.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      // appBar: AppBar(
      //   backgroundColor: const Color(0xFFF4F8FB),
      //   centerTitle: true,
      //   title: const Text(
      //     "Masuk Akun",
      //     style: TextStyle(
      //       fontSize: 18,
      //       fontWeight: FontWeight.bold,
      //       color: Color(0xFF1A2E44),
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _loginFormKey,
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 30),
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
                        "Selamat Datang",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2E44),
                        ),
                      ),
                      const Text(
                        "Kembali Melangkah !",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Masuk untuk melanjutkan kontribusimu di lingkungan bersih RUAS",
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
                        keyboardType: TextInputType.emailAddress,
                        decoration: _buildInputDecoration(
                          "Masukkan Email Anda",
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
                        "Kata Sandi",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2E44),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        obscuringCharacter: "*",
                        decoration:
                            _buildInputDecoration(
                              "Masukkan Kata Sandi Anda", // Diubah agar sesuai konteks login
                              Icons.lock_outline_rounded,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey,
                                ),
                                onPressed: () => setState(
                                  () => obscurePassword = !obscurePassword,
                                ),
                              ),
                            ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Kata Sandi tidak boleh kosong";
                          }
                          return null;
                        },
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Lupa Kata Sandi?",
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),

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
                            if (_loginFormKey.currentState!.validate()) {
                              login();
                            }
                          },
                          child: const Text(
                            "Masuk Sekarang",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
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
                      _buildSocialButton(
                        label: "Masuk dengan Google",
                        icon: Icons.g_mobiledata_rounded,
                        iconColor: Colors.red,
                      ),
                      const SizedBox(height: 12),
                      _buildSocialButton(
                        label: "Masuk dengan Apple",
                        icon: Icons.apple,
                        iconColor: Colors.black,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                Text.rich(
                  TextSpan(
                    text: "Belum Punya Akun?",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              context.pushAndRemoveAll(const WelcomeScreen()),
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
      // Diaktifkan kembali untuk menghandle style error textfield
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

Widget _buildSocialButton({
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
