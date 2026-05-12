import 'package:flutter/material.dart';

class Latihan1 extends StatelessWidget {
  const Latihan1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F8FB),
      appBar: AppBar(
        title: Text("Profil RUAS: Ruang Napas"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            // Identitas Aplikasi Utama
            const SizedBox(height: 10),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.asset('assets/images/logobaru1.png', height: 100),
                    Text(
                      "Ruang Napas",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    Text(
                      "Smart Air Quality Insight",
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Kontak email (Detail Kontak)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(blurRadius: 5, color: Colors.black12),
                  ],
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email, color: Colors.teal),
                    SizedBox(width: 10),
                    Text("info@ruangnapas.id", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Informasi Pendukung
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(blurRadius: 5, color: Colors.black12),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, color: Colors.teal),
                    SizedBox(width: 8),
                    Text("0812-2222-3333"),
                    Spacer(),
                    Icon(Icons.location_on, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Jakarta"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Statistik horizontal
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Column(
                        children: [
                          Text(
                            "85",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "AQI Hari Ini",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 15),

                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "PM2.5",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Polutan Dominan",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Deskripsi Naratif
            const SizedBox(height: 25),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Ruang Napas adalah aplikasi pemantauan kualitas udara "
                "yang membantu pengguna memahami kondisi udara secara "
                "real-time, memberikan prediksi kualitas udara, serta "
                "menyediakan insight berbasis data untuk mendukung "
                "aktivitas harian yang lebih sehat.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
            ),

            const SizedBox(height: 15),

            // Visual Branding
            Container(
              height: 150,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: AssetImage('assets/images/gambarbag.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
