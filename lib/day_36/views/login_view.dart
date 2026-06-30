import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:latihan_flutterd7/day_36/services/auth_service.dart';
import 'package:latihan_flutterd7/day_36/services/dio_client.dart';
import 'package:latihan_flutterd7/day_36/services/token_storage.dart';
import 'package:latihan_flutterd7/day_36/views/profile_view.dart';
import 'package:latihan_flutterd7/day_36/views/register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _loginFormKey = GlobalKey<FormState>();
  bool obscurePassword = true;
  bool _isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(createDioClient());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String _getErrorMessage(dynamic e) {
    if (e is DioException) {
      try {
        final responseData = e.response?.data;
        if (responseData != null) {
          if (responseData is Map) {
            if (responseData.containsKey('errors')) {
              final errors = responseData['errors'];
              if (errors is Map) {
                final messages = <String>[];
                errors.forEach((key, value) {
                  if (value is List) {
                    messages.addAll(value.map((v) => v.toString()));
                  } else {
                    messages.add(value.toString());
                  }
                });
                if (messages.isNotEmpty) {
                  return messages.join('\n');
                }
              }
            }
            if (responseData.containsKey('message')) {
              return responseData['message'].toString();
            }
          }
          if (responseData is String && responseData.isNotEmpty) {
            try {
              final parsed = jsonDecode(responseData);
              if (parsed is Map && parsed.containsKey('message')) {
                return parsed['message'].toString();
              }
            } catch (_) {}
          }
        }
      } catch (_) {}
      if (e.message != null && e.message!.isNotEmpty) {
        return e.message!;
      }
    }
    return e.toString();
  }

  void _showSuccessDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 28.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0F2625)
                        : const Color(0xFFE6F4F1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF0D9488),
                    size: 48,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Masuk Berhasil",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A2E44),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Selamat datang kembali! Mari terus bersama.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileView(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D9488),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: const Text(
                      "Mulai Sekarang",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 28.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF3B1E1E)
                        : const Color(0xFFFEE2E2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_rounded,
                    color: Color(0xFFEF4444),
                    size: 48,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Gagal Masuk",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A2E44),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: const Text(
                      "Coba Lagi",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _login() async {
    final email = emailController.text.trim();
    final pass = passwordController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.login({
        'email': email,
        'password': pass,
      });

      if (!mounted) return;

      if (response.data != null && response.data!.token != null) {
        final token = response.data!.token!;
        await TokenStorage.saveToken(token);
        _showSuccessDialog();
      } else {
        _showErrorDialog(
          response.message ?? 'Email atau Kata Sandi salah. Silakan coba lagi.',
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(_getErrorMessage(e));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF4F8FB);
    final Color cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final Color textColor = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF1A2E44);
    final Color subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    final Color dividerColor = isDark
        ? const Color(0xFF334155)
        : Colors.grey[300]!;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Background Gradient Circles for Premium Look
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0D9488).withOpacity(isDark ? 0.15 : 0.1),
                    const Color(0xFF045D56).withOpacity(isDark ? 0.05 : 0.02),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF045D56).withOpacity(isDark ? 0.1 : 0.05),
                    const Color(0xFF0D9488).withOpacity(isDark ? 0.05 : 0.02),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      // Header Logo & Text
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.fingerprint_rounded,
                              size: 44,
                              color: Color(0xFF0D9488),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Selamat Datang",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Aplikasi Absensi PPKD B6",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0D9488),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Masuk untuk mengakses profil dan data pelatihan",
                            style: TextStyle(fontSize: 13, color: subTextColor),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Login Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF334155)
                                : Colors.white.withOpacity(0.9),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 24,
                              color: isDark
                                  ? Colors.black.withOpacity(0.4)
                                  : const Color(0xFF0D9488).withOpacity(0.06),
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: textColor, fontSize: 14),
                              decoration: _buildInputDecoration(
                                "Masukkan Email Anda",
                                Icons.email_outlined,
                                isDark,
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
                            Text(
                              "Kata Sandi",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: passwordController,
                              obscureText: obscurePassword,
                              obscuringCharacter: "*",
                              style: TextStyle(color: textColor, fontSize: 14),
                              decoration:
                                  _buildInputDecoration(
                                    "Masukkan Kata Sandi Anda",
                                    Icons.lock_outline_rounded,
                                    isDark,
                                  ).copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        obscurePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.grey.shade500,
                                        size: 20,
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
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Fitur lupa kata sandi belum tersedia.',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Lupa Kata Sandi?",
                                  style: TextStyle(
                                    color: Color(0xFF0D9488),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Sign In Button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D9488),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        if (_loginFormKey.currentState!.validate()) {
                                          _login();
                                        }
                                      },
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : const Text(
                                        "Masuk Sekarang",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(color: dividerColor, thickness: 1),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    "atau masuk dengan",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(color: dividerColor, thickness: 1),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildSocialButton(
                              label: "Google",
                              icon: Icons.g_mobiledata_rounded,
                              iconColor: Colors.red,
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),
                      Text.rich(
                        TextSpan(
                          text: "Belum memiliki akun?",
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RegisterView(),
                                    ),
                                  );
                                },
                              text: " Daftar Sekarang",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0D9488),
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    String hint,
    IconData prefixIcon,
    bool isDark,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 13,
        color: isDark ? const Color(0xFF64748B) : Colors.grey.shade500,
      ),
      filled: true,
      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAF9),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1.5, color: Color(0xFF0D9488)),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF0D9488),
      ),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required IconData icon,
    required Color iconColor,
    required bool isDark,
  }) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        side: BorderSide(
          color: isDark ? const Color(0xFF334155) : Colors.grey[300]!,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {},
      icon: Icon(icon, color: iconColor, size: 24),
      label: Text(
        label,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
