import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/day_15/tentang_tab.dart';
import 'package:latihan_flutterd7/day_15/tugas7flutter.dart';
import 'package:latihan_flutterd7/day_17/tugas9flutter.dart';
import 'package:latihan_flutterd7/day_20/views/home_screen.dart';
import 'package:latihan_flutterd7/project_flutter/views/laporan_beranda.dart';
import 'package:latihan_flutterd7/project_flutter/views/buat_laporan.dart';
import 'package:latihan_flutterd7/project_flutter/views/riwayat_laporan.dart';

// Nested navigation shell for Laporan tab
class LaporanTabShell extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const LaporanTabShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        Widget builder;
        switch (settings.name) {
          case '/':
            builder = const LaporanBeranda();
            break;
          case '/buat':
            builder = const BuatLaporan();
            break;
          case '/riwayat':
            builder = const RiwayatLaporan();
            break;
          default:
            builder = const LaporanBeranda();
        }
        return MaterialPageRoute(
          builder: (context) => builder,
          settings: settings,
        );
      },
    );
  }
}

class Bottomnavi extends StatefulWidget {
  const Bottomnavi({super.key});

  @override
  State<Bottomnavi> createState() => _BottomnaviState();
}

class _BottomnaviState extends State<Bottomnavi> {
  int _selectedIndex = 2; // Default to Laporan (index 2) to display the RUAS features
  bool isSwitch = false;

  void _onItemTapped(int index) {
    if (index == 2 && _selectedIndex == 2) {
      // If already on Laporan tab, pop back to its root view
      LaporanTabShell.navigatorKey.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = <Widget>[
      const Tugas7flutter1(), // Index 0 (Home)
      const Tugas9flutter1(), // Index 1 (Maps)
      const LaporanTabShell(), // Index 2 (Laporan)
      TentangTab(isSwitch: isSwitch), // Index 3 (Edukasi)
      const HomeScreenDay20(), // Index 4 (Profil)
    ];

    const Color activeTeal = Color(0xFF0D9488);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: Container(
        height: 76,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomNavItem(
              index: 0,
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: "Home",
            ),
            _buildBottomNavItem(
              index: 1,
              icon: Icons.map_outlined,
              activeIcon: Icons.map,
              label: "Maps",
            ),
            // Prominent center Laporan button
            GestureDetector(
              onTap: () => _onItemTapped(2),
              child: Container(
                width: 80,
                height: 56,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: _selectedIndex == 2 ? activeTeal : Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment,
                      color: _selectedIndex == 2 ? Colors.white : Colors.grey[700],
                      size: 24,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Laporan",
                      style: TextStyle(
                        color: _selectedIndex == 2 ? Colors.white : Colors.grey[700],
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomNavItem(
              index: 3,
              icon: Icons.menu_book_outlined,
              activeIcon: Icons.menu_book,
              label: "Edukasi",
            ),
            _buildBottomNavItem(
              index: 4,
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: "Profil",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    const Color activeTeal = Color(0xFF0D9488);
    final bool isActive = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? activeTeal : Colors.grey[400],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? activeTeal : Colors.grey[400],
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
