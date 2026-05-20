import 'package:flutter/material.dart';

class halamanBeranda extends StatefulWidget {
  const halamanBeranda({super.key});

  @override
  State<halamanBeranda> createState() => _halamanBerandaState();
}

class _halamanBerandaState extends State<halamanBeranda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Beranda",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A2E44),
          ),
        ),
        backgroundColor: const Color(0xFFF4F8FB),
        elevation: 0,

        iconTheme: const IconThemeData(color: Color(0xFF1A2E44)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Hai, Alyssa Wulan Sari"),
            Text("Selamat Pagi"),
            SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.teal,
                    size: 28,
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: [
                      Text("Cibadak, Sukabumi"),
                      Text("25 September 2026, 08.30"),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text("AQI SAAT INI"),
                        Text("32"),
                        Row(
                          children: [
                            Icon(Icons.check_box_rounded),
                            Text("GOOD"),
                          ],
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
