import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latihan_flutterd7/project_flutter/database/ruas_db_helper.dart';
import 'package:latihan_flutterd7/project_flutter/views/splash_view.dart';
import 'package:latihan_flutterd7/project_flutter/views/pengaturan_view.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  String _userName = 'Andi Pratama';
  String _userEmail = 'andi.pratama@gmail.com';
  String _userPhone = '081234567890';
  String _joinDate = '24 Sep 2023';
  int _laporanCount = 0;
  int _edukasiCount = 0;
  bool _isLoading = true;

  final Color primaryTeal = const Color(0xFF0F4C43);
  final Color activeTeal = const Color(0xFF0D9488);
  final Color textDark = const Color(0xFF0F172A);

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('current_user_id') ?? 1;

    final user = await RuasDbHelper.instance.getUser(userId);
    final lCount = await RuasDbHelper.instance.getLaporanCount();
    final eCount = await RuasDbHelper.instance.getEdukasiCount();

    if (mounted) {
      setState(() {
        if (user != null) {
          _userName = user.nama;
          _userEmail = user.email;
          _userPhone = user.nomorTelp;
          _joinDate = user.tanggalDaftar;
        }
        _laporanCount = lCount;
        _edukasiCount = eCount;
        _isLoading = false;
      });
    }
  }

  void _editProfile() {
    final nameController = TextEditingController(text: _userName);
    final phoneController = TextEditingController(text: _userPhone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Nomor Telepon'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.black54)),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final userId = prefs.getInt('current_user_id') ?? 1;

              await RuasDbHelper.instance.updateUserProfile(
                userId,
                nameController.text.trim(),
                phoneController.text.trim(),
              );

              await prefs.setString('current_user_name', nameController.text.trim());

              if (mounted) {
                Navigator.pop(context);
                _loadUserProfile();
              }
            },
            child: const Text('Simpan', style: TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _changePassword() {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Ubah Kata Sandi'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Kata Sandi Baru',
            hintText: 'Minimal 6 karakter',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.black54)),
          ),
          TextButton(
            onPressed: () async {
              if (passwordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kata sandi minimal 6 karakter'), backgroundColor: Colors.red),
                );
                return;
              }

              final prefs = await SharedPreferences.getInstance();
              final userId = prefs.getInt('current_user_id') ?? 1;

              await RuasDbHelper.instance.updateUserPassword(
                userId,
                passwordController.text,
              );

              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kata sandi berhasil diperbarui'), backgroundColor: Color(0xFF0D9488)),
                );
              }
            },
            child: const Text('Perbarui', style: TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar Aplikasi'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun RUAS Anda?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.black54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Keluar', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SplashView()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F8FB),
        elevation: 0,
        title: Text(
          'Profil Saya',
          style: TextStyle(color: primaryTeal, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF0D9488)))
          : RefreshIndicator(
              onRefresh: _loadUserProfile,
              color: const Color(0xFF0D9488),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile card layout
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Color(0xFFF1F5F9)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // Avatar
                            const CircleAvatar(
                              radius: 44,
                              backgroundImage: AssetImage('assets/images/profile.webp'),
                              backgroundColor: Color(0xFFE2F1ED),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _userName,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _userEmail,
                              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _editProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF0FDFA),
                                foregroundColor: activeTeal,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 0,
                              ),
                              child: const Text('Edit Profil', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Stats Grid Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard('Laporan', '$_laporanCount'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatCard('Artikel', '$_edukasiCount'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatCard('Bergabung', _joinDate),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Quick Settings Options
                    Text(
                      'Pengaturan Cepat',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textDark),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.01),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildMenuTile(
                            Icons.lock_outline,
                            'Ubah Kata Sandi',
                            onTap: _changePassword,
                          ),
                          const Divider(height: 1),
                          _buildMenuTile(
                            Icons.settings_outlined,
                            'Pengaturan Aplikasi',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PengaturanView()),
                              ).then((_) => _loadUserProfile());
                            },
                          ),
                          const Divider(height: 1),
                          _buildMenuTile(
                            Icons.info_outline,
                            'Tentang Aplikasi',
                            onTap: () {
                              showAboutDialog(
                                context: context,
                                applicationName: 'RUAS',
                                applicationVersion: '1.0.0 (Tugas 13 Final Project)',
                                applicationIcon: Image.asset('assets/images/logo_ruas.png', height: 48),
                                children: [
                                  const Text('Ruang Napas Untuk Semua (RUAS) adalah platform pelaporan pencemaran udara dan edukasi kebersihan lingkungan untuk presentasi final project.'),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Logout Button
                    OutlinedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text('Keluar', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: activeTeal),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, {required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: activeTeal),
      title: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textDark),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.black38),
      onTap: onTap,
    );
  }
}
