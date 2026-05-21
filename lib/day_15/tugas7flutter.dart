import 'package:flutter/material.dart';

class Tugas7flutter1 extends StatefulWidget {
  const Tugas7flutter1({super.key});

  @override
  State<Tugas7flutter1> createState() => _Tugas7flutter1State();
}

class _Tugas7flutter1State extends State<Tugas7flutter1> {
  bool isCheck = false;
  bool _isDarkMode = false;
  bool isSwitch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode
          ? const Color(0xFF1E272E)
          : const Color(0xFFF4F7F6),
      appBar: AppBar(
        title: Text(
          "RUAS - Input Interaktif",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      // ---- Membuat Drawer --
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[700]!, Colors.teal[900]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.blur_on_rounded, color: Colors.white),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Ruang Napas",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("Menu Interaktif", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Konfigurasi Pemantauan RUAS",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.teal,
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "1. Syarat dan Ketentuan Relawan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  CheckboxListTile(
                    value: isCheck,
                    title: Text(
                      "Saya menyutujui persyaratan pelaporan",
                      style: TextStyle(fontSize: 14),
                    ),
                    onChanged: (bool? value) {
                      setState(() {
                        isCheck = value ?? false;
                        print(value);
                        print(isCheck);
                      });
                    },
                  ),
                  Text(
                    isCheck
                        ? "Pendaftaran diperbolehkan"
                        : "Pendaftran Belum Tersedia",
                  ),
                  SizedBox(height: 1),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "2. Mode Tampilan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SwitchListTile(
                          title: Text("Aktifkan Mode Gelap"),
                          activeThumbColor: Colors.teal[700],
                          contentPadding: EdgeInsets.zero,
                          value: _isDarkMode,
                          onChanged: (bool value) {
                            setState(() {
                              _isDarkMode = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
