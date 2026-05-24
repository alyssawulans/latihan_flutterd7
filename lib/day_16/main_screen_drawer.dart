import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/day_15/contoh.dart';

// Import 3 file layout baru kita tadi
import 'package:latihan_flutterd7/day_16/list_parameter.dart';
import 'package:latihan_flutterd7/day_16/map_stasiun.dart';
import 'package:latihan_flutterd7/day_16/list_with_model_iot.dart';
import 'package:latihan_flutterd7/utils/app_drawer.dart';

class MainScreenDrawer extends StatefulWidget {
  // Tambahkan variabel ini

  const MainScreenDrawer({super.key}); // Update constructor

  @override
  State<MainScreenDrawer> createState() => _MainScreenDrawerState();
}

class _MainScreenDrawerState extends State<MainScreenDrawer> {
  int _selectedIndex = 0;

  // Sesuaikan isi list option dengan layout buatan kita
  static const List<Widget> _widgetOptions = <Widget>[
    InputInteraktifScreen(), // Index 0: Form Input atau Home awal
    ListParameterDay16(), // Index 1: Level 1 (List Kategori)
    MapStasiunDay16(), // Index 2: Level 2 (Map Stasiun)
    ListWithModelIotDay16(), // Index 3: Level 3 (Model Alat IoT)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RUAS - Air Quality Monitor'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F4C43),
        elevation: 0.5,
      ),
      // Memanggil widget drawer kelas bawaanmu
      drawer: AppDrawer(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
