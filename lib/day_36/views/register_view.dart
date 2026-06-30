import 'dart:convert';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:latihan_flutterd7/day_36/models/all_batches_model.dart' as batch_m;
import 'package:latihan_flutterd7/day_36/models/training_model.dart' as training_m;
import 'package:latihan_flutterd7/day_36/services/auth_service.dart';
import 'package:latihan_flutterd7/day_36/services/dio_client.dart';
import 'package:latihan_flutterd7/day_36/views/login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _registerFormKey = GlobalKey<FormState>();
  bool obscureNewPassword = true;
  bool isCheck = false;
  bool _isLoading = false;

  // Controllers
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String _jenisKelamin = 'Laki-Laki';
  File? _imageFile;
  String? _base64Image;

  List<batch_m.Datum> _batches = [];
  List<training_m.Datum> _trainings = [];
  int? _selectedBatchId;
  int? _selectedTrainingId;
  bool _isLoadingData = true;

  late final AuthService _authService;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _authService = AuthService(createDioClient());
    _fetchDropdownData();
  }

  Future<void> _fetchDropdownData() async {
    try {
      final batchResponse = await _authService.getBatches();
      final trainingResponse = await _authService.getTrainings();

      if (mounted) {
        setState(() {
          _batches = batchResponse.data ?? [];
          _trainings = trainingResponse.data ?? [];
          _isLoadingData = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingData = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengambil data Batch & Training: ${_getErrorMessage(e)}'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    namaController.dispose();
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

  Future<void> _pickImageSource() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "Pilih Sumber Foto",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A2E44),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPickerOption(
                    icon: Icons.camera_alt_rounded,
                    label: "Kamera",
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  _buildPickerOption(
                    icon: Icons.photo_library_rounded,
                    label: "Galeri",
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF0D9488), size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        final String extension = image.path.split('.').last.toLowerCase();
        final String mimeType = (extension == 'png') ? 'image/png' : 'image/jpeg';
        setState(() {
          _imageFile = File(image.path);
          _base64Image = "data:$mimeType;base64," + base64Encode(bytes);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil gambar: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showTermsBottomSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Syarat & Ketentuan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A2E44),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(color: isDark ? const Color(0xFF334155) : null),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selamat datang. Dengan mendaftar, Anda setuju untuk mematuhi ketentuan berikut:",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "1. Akun Pengguna",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Anda wajib memberikan informasi pendaftaran yang akurat.",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Saya Mengerti",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPrivacyBottomSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Kebijakan Privasi",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A2E44),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(color: isDark ? const Color(0xFF334155) : null),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Kebijakan Privasi ini menjelaskan perlindungan data pribadi Anda:",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "1. Informasi yang Kami Kumpulkan",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Kami mengumpulkan data pendaftaran seperti nama, email.",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Saya Mengerti",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
                  "Pendaftaran Berhasil",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A2E44),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Akun Anda berhasil didaftarkan! Silakan masuk menggunakan email dan kata sandi Anda.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
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
                      "Masuk Sekarang",
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
                  "Pendaftaran Gagal",
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
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
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
                      "Tutup",
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

  void _register() async {
    if (_registerFormKey.currentState == null ||
        !_registerFormKey.currentState!.validate()) {
      return;
    }
    if (!isCheck) {
      _showErrorDialog(
        "Anda harus menyetujui Syarat & Ketentuan serta Kebijakan Privasi terlebih dahulu.",
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.register({
        'name': namaController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'jenis_kelamin': _jenisKelamin == 'Laki-Laki' ? 'L' : 'P',
        'profile_photo': _base64Image ?? "",
        if (_selectedBatchId != null) 'batch_id': _selectedBatchId,
        if (_selectedTrainingId != null) 'training_id': _selectedTrainingId,
      });

      if (!mounted) return;

      if (response.data != null ||
          response.message == 'User berhasil didaftarkan' ||
          response.message == 'Registrasi berhasil') {
        _showSuccessDialog();
      } else {
        _showErrorDialog(response.message ?? 'Registrasi gagal');
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

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Background Gradient Circles for Premium Look
          Positioned(
            top: -100,
            left: -100,
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
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Form(
                  key: _registerFormKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "Buat Akun",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const Text(
                              "Mulai Langkahmu !",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D9488),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Daftarkan dirimu untuk bergabung dalam program",
                              style: TextStyle(fontSize: 13, color: subTextColor),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
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
                            Center(
                              child: GestureDetector(
                                onTap: _pickImageSource,
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFF0D9488),
                                          width: 3.5,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 56,
                                        backgroundColor: isDark
                                            ? const Color(0xFF0F172A)
                                            : Colors.grey.shade100,
                                        backgroundImage: _imageFile != null
                                            ? FileImage(_imageFile!)
                                            : null,
                                        child: _imageFile == null
                                            ? Icon(
                                                Icons.person_add_alt_1_outlined,
                                                size: 48,
                                                color: isDark
                                                    ? Colors.grey.shade600
                                                    : Colors.grey.shade400,
                                              )
                                            : null,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF0D9488),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "Nama Lengkap",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: namaController,
                              style: TextStyle(color: textColor, fontSize: 14),
                              decoration: _buildInputDecoration(
                                "Masukkan Nama Lengkap Anda",
                                Icons.person_outline,
                                isDark,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Nama Lengkap tidak boleh kosong";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
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
                                "Masukkan Email Aktif",
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
                              "Jenis Kelamin",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: textColor),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _jenisKelamin,
                              dropdownColor: cardColor,
                              style: TextStyle(color: textColor, fontSize: 14),
                              decoration: _buildInputDecoration(
                                "",
                                Icons.wc_outlined,
                                isDark,
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'Laki-Laki',
                                  child: Text(
                                    'Laki-Laki',
                                    style: TextStyle(color: textColor),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Perempuan',
                                  child: Text(
                                    'Perempuan',
                                    style: TextStyle(color: textColor),
                                  ),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _jenisKelamin = val);
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Batch",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      _isLoadingData
                                          ? const Center(
                                              child: SizedBox(
                                                height: 24,
                                                width: 24,
                                                child: CircularProgressIndicator(
                                                  color: Color(0xFF0D9488),
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                            )
                                          : DropdownButtonFormField<int>(
                                              isExpanded: true,
                                              value: _selectedBatchId,
                                              dropdownColor: cardColor,
                                              style: TextStyle(
                                                color: textColor,
                                                fontSize: 14,
                                              ),
                                              decoration: _buildInputDecoration(
                                                "Pilih Batch",
                                                Icons.layers_outlined,
                                                isDark,
                                              ),
                                              items: _batches.map((batch) {
                                                return DropdownMenuItem<int>(
                                                  value: batch.id,
                                                  child: Text(
                                                    batch.batchKe ?? '-',
                                                    style: TextStyle(
                                                      color: textColor,
                                                      fontSize: 13,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (val) {
                                                setState(
                                                  () => _selectedBatchId = val,
                                                );
                                              },
                                            ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pelatihan",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      _isLoadingData
                                          ? const Center(
                                              child: SizedBox(
                                                height: 24,
                                                width: 24,
                                                child: CircularProgressIndicator(
                                                  color: Color(0xFF0D9488),
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                            )
                                          : DropdownButtonFormField<int>(
                                              isExpanded: true,
                                              value: _selectedTrainingId,
                                              dropdownColor: cardColor,
                                              style: TextStyle(
                                                color: textColor,
                                                fontSize: 14,
                                              ),
                                              decoration: _buildInputDecoration(
                                                "Pilih Pelatihan",
                                                Icons.class_outlined,
                                                isDark,
                                              ),
                                              items: _trainings.map((training) {
                                                return DropdownMenuItem<int>(
                                                  value: training.id,
                                                  child: Text(
                                                    training.title ?? '-',
                                                    style: TextStyle(
                                                      color: textColor,
                                                      fontSize: 13,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (val) {
                                                setState(
                                                  () => _selectedTrainingId = val,
                                                );
                                              },
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Kata Sandi Baru",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: passwordController,
                              obscureText: obscureNewPassword,
                              obscuringCharacter: "*",
                              style: TextStyle(color: textColor, fontSize: 14),
                              decoration:
                                  _buildInputDecoration(
                                    "Buat Kata Sandi Kuat",
                                    Icons.lock_outline_rounded,
                                    isDark,
                                  ).copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        obscureNewPassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.grey.shade500,
                                        size: 20,
                                      ),
                                      onPressed: () => setState(
                                        () => obscureNewPassword =
                                            !obscureNewPassword,
                                      ),
                                    ),
                                  ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Kata Sandi tidak boleh kosong";
                                }
                                if (value.length < 6) {
                                  return "Kata Sandi minimal 6 karakter";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            Theme(
                              data: ThemeData(
                                unselectedWidgetColor: isDark
                                    ? const Color(0xFF64748B)
                                    : Colors.grey,
                                checkboxTheme: CheckboxThemeData(
                                  side: BorderSide(
                                    color: isDark
                                        ? const Color(0xFF64748B)
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              child: CheckboxListTile(
                                title: Text.rich(
                                  TextSpan(
                                    text: "Saya setuju dengan",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                    children: [
                                      TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = _showTermsBottomSheet,
                                        text: " Syarat & Ketentuan",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0D9488),
                                          fontSize: 12,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: " dan",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = _showPrivacyBottomSheet,
                                        text: " Kebijakan Privasi",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0D9488),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                value: isCheck,
                                activeColor: const Color(0xFF0D9488),
                                checkColor: Colors.white,
                                contentPadding: EdgeInsets.zero,
                                controlAffinity: ListTileControlAffinity.leading,
                                onChanged: (newValue) {
                                  setState(() {
                                    isCheck = newValue ?? false;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
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
                                        if (_registerFormKey.currentState!.validate()) {
                                          _register();
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
                                        "Daftar Sekarang",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),
                      Text.rich(
                        TextSpan(
                          text: "Sudah Punya Akun?",
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginView(),
                                    ),
                                  );
                                },
                              text: " Masuk Di Sini",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D9488),
                                fontSize: 14,
                              ),
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
}
