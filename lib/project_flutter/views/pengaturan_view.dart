import 'package:flutter/material.dart';

class PengaturanView extends StatefulWidget {
  const PengaturanView({super.key});

  @override
  State<PengaturanView> createState() => _PengaturanViewState();
}

class _PengaturanViewState extends State<PengaturanView> {
  bool _notifikasiStatus = true;
  String _bahasaTerpilih = 'Bahasa Indonesia';
  String _temaTerpilih = 'Terang';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pengaturan',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Account section
            const Text(
              'Akun',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black45),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: ListTile(
                leading: const Icon(Icons.info_outline, color: Color(0xFF0D9488)),
                title: const Text('Informasi Akun', style: TextStyle(fontSize: 14)),
                trailing: const Icon(Icons.chevron_right, color: Colors.black38),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Detail akun sudah tertera di halaman profil.')),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Application settings
            const Text(
              'Aplikasi',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black45),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                children: [
                  // Notifikasi toggle
                  SwitchListTile(
                    activeColor: const Color(0xFF0D9488),
                    title: const Text('Notifikasi', style: TextStyle(fontSize: 14)),
                    secondary: const Icon(Icons.notifications_none, color: Color(0xFF0D9488)),
                    value: _notifikasiStatus,
                    onChanged: (bool value) {
                      setState(() {
                        _notifikasiStatus = value;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_notifikasiStatus ? 'Notifikasi diaktifkan' : 'Notifikasi dimatikan'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  // Bahasa selector
                  ListTile(
                    leading: const Icon(Icons.language, color: Color(0xFF0D9488)),
                    title: const Text('Bahasa', style: TextStyle(fontSize: 14)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_bahasaTerpilih, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right, color: Colors.black38),
                      ],
                    ),
                    onTap: () {
                      _showBahasaPicker();
                    },
                  ),
                  const Divider(height: 1),
                  // Tema selector
                  ListTile(
                    leading: const Icon(Icons.palette_outlined, color: Color(0xFF0D9488)),
                    title: const Text('Tema', style: TextStyle(fontSize: 14)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_temaTerpilih, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right, color: Colors.black38),
                      ],
                    ),
                    onTap: () {
                      _showTemaPicker();
                    },
                  ),
                  const Divider(height: 1),
                  // Tentang aplikasi
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: Color(0xFF0D9488)),
                    title: const Text('Tentang Aplikasi', style: TextStyle(fontSize: 14)),
                    trailing: const Text('RUAS v1.0.0', style: TextStyle(fontSize: 12, color: Colors.black45)),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Others
            const Text(
              'Lainnya',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black45),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: ListTile(
                leading: const Icon(Icons.help_outline, color: Color(0xFF0D9488)),
                title: const Text('Bantuan & Hubungi Kami', style: TextStyle(fontSize: 14)),
                trailing: const Icon(Icons.chevron_right, color: Colors.black38),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bantuan: hubungi support@ruas.id')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBahasaPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Bahasa Indonesia'),
              trailing: _bahasaTerpilih == 'Bahasa Indonesia' ? const Icon(Icons.check, color: Color(0xFF0D9488)) : null,
              onTap: () {
                setState(() {
                  _bahasaTerpilih = 'Bahasa Indonesia';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English'),
              trailing: _bahasaTerpilih == 'English' ? const Icon(Icons.check, color: Color(0xFF0D9488)) : null,
              onTap: () {
                setState(() {
                  _bahasaTerpilih = 'English';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTemaPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Terang'),
              trailing: _temaTerpilih == 'Terang' ? const Icon(Icons.check, color: Color(0xFF0D9488)) : null,
              onTap: () {
                setState(() {
                  _temaTerpilih = 'Terang';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Gelap'),
              trailing: _temaTerpilih == 'Gelap' ? const Icon(Icons.check, color: Color(0xFF0D9488)) : null,
              onTap: () {
                setState(() {
                  _temaTerpilih = 'Gelap';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
