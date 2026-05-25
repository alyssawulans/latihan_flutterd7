import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/day_15/form_pendaftaran_tab.dart';
import 'package:latihan_flutterd7/day_15/tentang_tab.dart';
// MENYESUAIKAN IMPORT: Mengarah ke day_16 sesuai struktur direktori VS Code kamu

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RUAS',
      home: const UtamaNavigasiScreen(),
    );
  }
}

class UtamaNavigasiScreen extends StatefulWidget {
  const UtamaNavigasiScreen({super.key});

  @override
  State<UtamaNavigasiScreen> createState() => _UtamaNavigasiScreenState();
}

class AppImage {
  static const String logo = 'assets/images/logo_ruas.png';
  static const String avatar = 'assets/images/profile.webp';
}

class _UtamaNavigasiScreenState extends State<UtamaNavigasiScreen> {
  int _currentIndex = 0;
  bool isSwitch = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isSwitch
        ? const Color(0xFF15191C)
        : const Color(0xFFF5F8F7);
    Color primaryText = isSwitch ? Colors.white : const Color(0xFF0F4C43);

    // 1. DAFTAR HALAMAN TAB (Menyisipkan MainScreenDrawer dari day_16 di indeks tengah)
    final List<Widget> pages = [
      FormPendaftaranTab(
        isSwitch: isSwitch,
        onModeChanged: (val) => setState(() => isSwitch = val),
      ),
      // Membawa state isSwitch agar tema Katalog sinkron dengan setelan Dark/Light Mode di Home
      // MainScreenDrawerDay15(isSwitch: isSwitch),
      TentangTab(isSwitch: isSwitch),
    ];

    // 2. LOGIC ANTI-BENTROK: Jika membuka Tab Katalog (Index 1), sembunyikan AppBar utama
    final PreferredSizeWidget? kustomAppBar = _currentIndex == 1
        ? null
        : AppBar(
            backgroundColor: isSwitch ? const Color(0xFF1D2428) : Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: primaryText),
            title: Row(
              children: [
                Image.asset(
                  AppImage.logo,
                  height: 26,
                  width: 26,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.blur_on_rounded,
                      color: isSwitch
                          ? Colors.teal[300]
                          : const Color(0xFF0F4C43),
                      size: 26,
                    );
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  "RUAS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryText,
                    fontSize: 19,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.transparent,
                  backgroundImage: const AssetImage(AppImage.avatar),
                ),
              ),
            ],
          );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: kustomAppBar,

      // 3. LOGIC DRAWER UTAMA: Hanya aktif saat di Tab Home (Index 0)
      drawer: _currentIndex == 0
          ? Drawer(
              child: Container(
                color: backgroundColor,
                child: Column(
                  children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(color: Color(0xFF0F4C43)),
                      child: Center(
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage("assets/images/logo_ruas.png"),
                              height: 70,
                              width: 70,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Ruang Napas",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.assignment_ind_outlined),
                      title: const Text("Pendaftaran Akun"),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text("Info Aplikasi"),
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            )
          : null, // Bernilai null pada Tab Katalog & Tentang agar Drawer internal yang bekerja

      body: pages[_currentIndex],

      // 4. BOTTOM NAVIGATION BAR (Navigasi bawah 3 Menu)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF00594C),
        backgroundColor: isSwitch ? const Color(0xFF1D2428) : Colors.white,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories_outlined),
            label: "Katalog",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Tentang"),
        ],
      ),
    );
  }
}
