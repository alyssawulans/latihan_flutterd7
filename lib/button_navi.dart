import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/day_15/tentang_tab.dart';
import 'package:latihan_flutterd7/day_15/tugas7flutter.dart';
import 'package:latihan_flutterd7/day_17/tugas9flutter.dart';

// 1. Pastikan nama class State-nya terhubung dengan StatefulWidget-nya
class Bottomnavi extends StatefulWidget {
  const Bottomnavi({super.key});

  @override
  State<Bottomnavi> createState() => _BottomnaviState();
}

class _BottomnaviState extends State<Bottomnavi> {
  int _selectedIndex = 0;
  bool isSwitch = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> button = <Widget>[
      const Tugas7flutter1(), // Index 0
      const Tugas9flutter1(), // Index 1
      TentangTab(isSwitch: isSwitch), // Index 2
    ];
    return Scaffold(
      // 2. Tampilkan halaman yang aktif saat ini di dalam body
      body: button[_selectedIndex],
      backgroundColor: const Color(0xFFF5F8F7),

      // 3. Taruh BottomNavigationBar di dalam properti bottomNavigationBar milik Scaffold
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF5F8F7),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 22),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined, size: 22),
            label: "Katalog",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline, size: 22),
            label: "Info Aplikasi",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.history_toggle_off, size: 22),
          //   label: "History",
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person, size: 22),
          //   label: "Profile",
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey, // Warna menu saat tidak dipilih
        onTap: _onItemTapped,
      ),
    );
  }
}
