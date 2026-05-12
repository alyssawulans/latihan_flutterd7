import 'package:flutter/material.dart';

class Tugas3flutter extends StatelessWidget {
  const Tugas3flutter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F8FB),
      appBar: AppBar(
        title: Text("Registrasi & Katalog"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),

          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(blurRadius: 5, color: Colors.black12),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    // Input Nama Pengguna
                    Text(
                      "Pengisian Form",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Nama Pengguna",
                        hintText: "Masukkan Nama Pengguna",
                        hintStyle: TextStyle(fontSize: 14),
                        filled: true,
                        fillColor: const Color.fromARGB(36, 0, 150, 135),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    // Input alamat Pengguna
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Alamat Pengguna",
                        hintText: "Masukkan Alamat Pengguna",
                        hintStyle: TextStyle(fontSize: 14),
                        filled: true,
                        fillColor: const Color.fromARGB(36, 0, 150, 135),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    // Input No Handphone
                    TextField(
                      decoration: InputDecoration(
                        labelText: "No.Handphone",
                        hintText: "Masukkan No.Handphone Pengguna",
                        hintStyle: TextStyle(fontSize: 14),
                        filled: true,
                        fillColor: const Color.fromARGB(36, 0, 150, 135),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    // Input Email
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Email Pengguna",
                        hintText: "Masukkan Email Pengguna",
                        hintStyle: TextStyle(fontSize: 14),
                        filled: true,
                        fillColor: const Color.fromARGB(36, 0, 150, 135),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    // Input Konfirmasi Password
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Konfirmasi Email",
                        hintText: "Masukkan Konfirmasi Email Pengguna",
                        hintStyle: TextStyle(fontSize: 14),
                        filled: true,
                        fillColor: const Color.fromARGB(36, 0, 150, 135),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 12.4),
                  Text("LINGKUNGAN BERBAHAYA"),
                  SizedBox(height: 12.4),
                  GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    shrinkWrap: true,
                    crossAxisSpacing: 5,
                    children: [
                      buildStack("assets/images/polutan_1.webp", "AIR"),
                      buildStack("assets/images/polutan_2.png", "Bisa"),
                      buildStack("assets/images/polutan_3.jpg", "BERBAHAYA"),
                      buildStack("assets/images/polutan_4.jpg", "BERBAHAYA"),
                      buildStack("assets/images/polutan_5.png", "BERBAHAYA"),
                      buildStack("assets/images/polutan_6.webp", "BERBAHAYA"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stack buildStack(String imagename, String ket) {
    return Stack(
      alignment: AlignmentGeometry.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(imagename, fit: BoxFit.cover),
          ),
        ),

        Positioned(
          bottom: -10,
          child: Container(
            padding: EdgeInsets.all(4.0),
            width: 80,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.red,
            ),

            child: Text(
              ket,
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
