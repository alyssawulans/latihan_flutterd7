import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/day_15/form_pendaftaran_tab.dart';
import 'package:latihan_flutterd7/day_15/tentang_tab.dart';

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

class _UtamaNavigasiScreenState extends State<UtamaNavigasiScreen> {
  // Poin 5: Tracker Index Tab aktif
  int _currentIndex = 0;
  bool isSwitch = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isSwitch
        ? const Color(0xFF15191C)
        : const Color(0xFFF5F8F7);
    Color primaryText = isSwitch ? Colors.white : const Color(0xFF0F4C43);

    // List halaman memanggil file luar yang di-import
    final List<Widget> pages = [
      FormPendaftaranTab(
        isSwitch: isSwitch,
        onModeChanged: (val) => setState(() => isSwitch = val),
      ),
      TentangTab(isSwitch: isSwitch),
    ];

    final List<String> titles = ["Halaman Utama RUAS", "Tentang Aplikasi"];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isSwitch ? const Color(0xFF1D2428) : Colors.white,
        title: Text(
          titles[_currentIndex],
          style: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

      // Poin 5: Logic Drawer hanya aktif di Tab 0 (Home)
      drawer: _currentIndex == 0
          ? Drawer(
              child: Container(
                color: backgroundColor,
                child: Column(
                  children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(color: Color(0xFF0F4C43)),
                      child: Center(
                        child: Text(
                          "Ruang Napas",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.assignment_ind_outlined),
                      title: const Text("Pendaftaran Akun"),
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            )
          : null, // Sembunyikan otomatis di tab selain Home

      body: pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF00594C),
        backgroundColor: isSwitch ? const Color(0xFF1D2428) : Colors.white,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Tentang"),
        ],
      ),
    );
  }
}
