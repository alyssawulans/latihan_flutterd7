import 'package:flutter/material.dart';

class Tugas3flutter extends StatelessWidget {
  const Tugas3flutter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F8FB),
      appBar: AppBar(
        title: Text(
          "Registrasi & Edukasi",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(blurRadius: 5, color: Colors.black12),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 12,
                  children: [
                    Text(
                      "Form Registrasi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Nama Pengguna
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Nama Pengguna",
                        hintText: "Masukkan Nama Pengguna",
                        filled: true,
                        fillColor: const Color.fromARGB(14, 0, 150, 135),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),

                    // Email Pengguna
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Email Pengguna",
                        hintText: "Masukkan Email Pengguna",
                        filled: true,
                        fillColor: const Color.fromARGB(14, 0, 150, 135),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),

                    // No.Telephone Pengguna
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Telephone Pengguna",
                        hintText: "Masukkan No. Telephone Pengguna",
                        filled: true,
                        fillColor: const Color.fromARGB(14, 0, 150, 135),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),

                    // Password Input
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Input Password",
                        hintText: "Masukkan Password",
                        filled: true,
                        fillColor: const Color.fromARGB(14, 0, 150, 135),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.key),
                      ),
                    ),

                    // Konfirm Password Pengguna
                    TextField(
                      obscureText: true,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                        labelText: "Konfirmasi Password",
                        hintText: "Masukkan Konfirmasi Password",
                        filled: true,
                        fillColor: const Color.fromARGB(14, 0, 150, 135),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: Icon(Icons.visibility),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Wilayah Pemantauan Kualitas Udara Terdekat",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    eduRuas("assets/images/kota_1.jpg", "Jakarta"),
                    eduRuas("assets/images/kota_2.jpg", "Bandung"),
                    eduRuas("assets/images/kota_3.jpg", "Yogyakarta"),
                    eduRuas("assets/images/kota_4.jpeg", "Semarang"),
                    eduRuas("assets/images/kota_5.jpeg", "Lampung"),
                    eduRuas("assets/images/kota_6.webp", "Padang"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Stack eduRuas(String gambar, String info) {
    return Stack(
      alignment: AlignmentGeometry.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(3),
          height: double.infinity,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(gambar, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          bottom: -5,
          child: Container(
            padding: EdgeInsets.all(4.0),
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.blueGrey,
            ),
            child: Text(
              info,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
