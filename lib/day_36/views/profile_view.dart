import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:latihan_flutterd7/day_36/services/auth_service.dart';
import 'package:latihan_flutterd7/day_36/services/token_storage.dart';
import 'package:latihan_flutterd7/day_36/views/login_view.dart';
import 'package:latihan_flutterd7/day_36/views/edit_profile_view.dart';
import 'package:latihan_flutterd7/day_36/views/detail_user_view.dart';
import 'package:latihan_flutterd7/day_36/models/profile_response.dart';
import 'package:latihan_flutterd7/day_36/services/dio_client.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final AuthService _authService;
  Data? _profileData;
  bool _isLoading = true;
  String? _errorMessage;
  int _imageVersion = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(createDioClient());
    _loadProfile();
  }

  String _getErrorMessage(dynamic e) {
    if (e is DioException) {
      try {
        final responseData = e.response?.data;
        if (responseData != null) {
          if (responseData is Map) {
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

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await _authService.getProfile();
      if (response.data != null) {
        setState(() {
          _profileData = response.data;
          _imageVersion = DateTime.now().millisecondsSinceEpoch;
        });
      } else {
        setState(() {
          _errorMessage = response.message ?? 'Gagal mengambil data profil.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = _getErrorMessage(e);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _logout() async {
    await TokenStorage.clearToken();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF4F8FB),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0D9488),
                strokeWidth: 3,
              ),
            )
          : _errorMessage != null
              ? _buildErrorView(isDark)
              : _buildModernProfile(isDark),
    );
  }

  Widget _buildErrorView(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF3B1E1E) : const Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFEF4444),
                size: 54,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Gagal Memuat Profil",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A2E44),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage ?? "Terjadi kesalahan tidak dikenal.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _loadProfile,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text("Coba Lagi"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text("Keluar"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildModernProfile(bool isDark) {
    if (_profileData == null) return const SizedBox();

    final Color cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final Color subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600;

    return RefreshIndicator(
      onRefresh: _loadProfile,
      color: const Color(0xFF0D9488),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Top Header Background Gradient
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0D9488), Color(0xFF045D56)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                  ),
                ),
                // Decorative Elements
                Positioned(
                  top: -50,
                  right: -50,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.06),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: -30,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.04),
                    ),
                  ),
                ),
                // Top App Bar Icons
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Profil Saya",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.logout_rounded, color: Colors.white),
                            onPressed: _logout,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Profile Avatar & Info Card Overlapping
                Container(
                  margin: const EdgeInsets.only(top: 160, left: 24, right: 24),
                  padding: const EdgeInsets.only(top: 70, bottom: 24, left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : Colors.white.withOpacity(0.8),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        _profileData?.name ?? 'Guest User',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _profileData?.email ?? 'Belum ada email',
                        style: TextStyle(
                          fontSize: 14,
                          color: subTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: _buildMiniStat(
                              Icons.wc_outlined,
                              "Gender",
                              _profileData?.jenisKelamin == 'L'
                                  ? 'Laki-Laki'
                                  : (_profileData?.jenisKelamin == 'P' ? 'Perempuan' : '-'),
                              isDark,
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 1.2,
                            color: isDark ? const Color(0xFF334155) : Colors.grey.shade300,
                          ),
                          Expanded(
                            child: _buildMiniStat(
                              Icons.layers_outlined,
                              "Batch",
                              _profileData?.batchKe ?? '-',
                              isDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // The Avatar Itself (Positioned to break out of the card)
                Positioned(
                  top: 96,
                  left: 0,
                  right: 0,
                  child: Center(
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
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 56,
                            backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF4F8FB),
                            backgroundImage: _getSanitizedImageUrl(_profileData?.profilePhotoUrl) != null
                                ? NetworkImage("${_getSanitizedImageUrl(_profileData!.profilePhotoUrl!)}?v=$_imageVersion")
                                : null,
                            child: _profileData?.profilePhotoUrl == null
                                ? Icon(Icons.person, size: 50, color: Colors.grey.shade400)
                                : null,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileView(profileData: _profileData!),
                              ),
                            );
                            if (result == true) {
                              _loadProfile();
                            }
                          },
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
                            child: const Icon(Icons.edit_rounded, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Program Terdaftar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : Colors.white.withOpacity(0.9),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D9488).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.menu_book_rounded, color: Color(0xFF0D9488), size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pelatihan",
                                style: TextStyle(fontSize: 12, color: subTextColor, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _profileData?.trainingTitle ?? 'Belum ada training',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailUserView(profileData: _profileData!),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person_search_rounded, color: Colors.white, size: 22),
                      label: const Text(
                        'Lihat Detail Lengkap',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D9488),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String title, String value, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF0D9488), size: 24),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}
