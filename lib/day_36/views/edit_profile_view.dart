import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:latihan_flutterd7/day_36/services/auth_service.dart';
import 'package:latihan_flutterd7/day_36/services/dio_client.dart';
import 'package:latihan_flutterd7/day_36/models/profile_response.dart';

class EditProfileView extends StatefulWidget {
  final Data profileData;

  const EditProfileView({Key? key, required this.profileData}) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late TextEditingController _nameController;
  File? _imageFile;
  String? _base64Image;
  bool _isLoading = false;

  late final AuthService _authService;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profileData.name);
    _authService = AuthService(createDioClient());
  }

  @override
  void dispose() {
    _nameController.dispose();
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
        }
      } catch (_) {}
      if (e.message != null && e.message!.isNotEmpty) {
        return e.message!;
      }
    }
    return e.toString();
  }

  String? _getSanitizedImageUrl(String? url) {
    if (url == null) return null;
    String cleaned = url;
    cleaned = cleaned.replaceAll('http://127.0.0.1:8000', 'https://appabsensi.mobileprojp.com');
    cleaned = cleaned.replaceAll('http://localhost:8000', 'https://appabsensi.mobileprojp.com');
    cleaned = cleaned.replaceAll('http://localhost', 'https://appabsensi.mobileprojp.com');
    return cleaned;
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

  void _saveProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama tidak boleh kosong'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.editProfile(
        {
          'name': name,
          if (_base64Image != null) 'profile_photo': _base64Image,
        }
      );

      if (response.data != null ||
          response.message == 'Profile and photo updated successfully' ||
          response.message == 'Profile updated successfully' ||
          response.message == 'Profil berhasil diperbarui') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil berhasil diperbarui'),
              backgroundColor: Color(0xFF0D9488),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context, true); 
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Gagal memperbarui profil'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getErrorMessage(e)),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
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
    final Color bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF4F8FB);
    final Color cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Edit Profil',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: cardColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 64,
                        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.grey.shade100,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : (_getSanitizedImageUrl(widget.profileData.profilePhotoUrl) != null
                                ? NetworkImage("${_getSanitizedImageUrl(widget.profileData.profilePhotoUrl!)}?v=${DateTime.now().millisecondsSinceEpoch}")
                                : null) as ImageProvider?,
                        child: (_imageFile == null && widget.profileData.profilePhotoUrl == null)
                            ? Icon(Icons.person_outline, size: 60, color: Colors.grey.shade400)
                            : null,
                      ),
                    ),
                    GestureDetector(
                      onTap: _pickImageSource,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D9488),
                          shape: BoxShape.circle,
                          border: Border.all(color: cardColor, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0D9488).withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Nama Lengkap",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAF9),
                  borderRadius: BorderRadius.circular(12),
                  border: isDark ? Border.all(color: const Color(0xFF334155)) : null,
                ),
                child: TextField(
                  controller: _nameController,
                  style: TextStyle(fontSize: 15, color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama Anda',
                    hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : Colors.grey),
                    prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF0D9488)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text(
                          'SIMPAN PERUBAHAN',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
