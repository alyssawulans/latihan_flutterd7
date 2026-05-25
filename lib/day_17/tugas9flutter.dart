import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/day_15/tugas7flutter.dart';
import 'package:latihan_flutterd7/day_17/ruas_data.dart'; // Import file data kita tadi

class Tugas9flutter1 extends StatefulWidget {
  const Tugas9flutter1({super.key});

  @override
  State<Tugas9flutter1> createState() => _Tugas9flutter1State();
}

class _Tugas9flutter1State extends State<Tugas9flutter1> {
  @override
  Widget build(BuildContext context) {
    const Color primaryTeal = Color(0xFF0F4C43);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Tombol burger menu otomatis muncul di sini untuk membuka Drawer internal Katalog
        iconTheme: const IconThemeData(color: primaryTeal),
        title: Row(
          children: [
            Image.asset(
              AppImage.logo,
              height: 26,
              width: 26,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.blur_on_rounded, size: 26);
              },
            ),
            SizedBox(width: 8),

            Text(
              "RUAS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryTeal,
                fontSize: 19,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(
                'assets/images/profile.webp',
              ), // Menggunakan avatar lokal
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // PARAMETER UDARA (Horizontal Chips)
            // ==========================================
            const Text(
              "Parameter Udara",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryTeal,
              ),
            ),
            const Text(
              "Parameter utama dalam pemantauan kualitas udara.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: RuasData.listSederhana.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5),

                    child: Container(
                      padding: EdgeInsets.all(8),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        RuasData.listSederhana[index],
                        style: const TextStyle(
                          color: primaryTeal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // ==========================================
            // STASIUN REGIONAL
            // ==========================================
            const Text(
              "Stasiun Regional",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryTeal,
              ),
            ),
            const Text(
              "Stasiun regional pemantauan wilayah pemukiman. Sistem pemantau mikroklimat regional yang mengintegrasikan berbagai sensor IoT untuk mendeteksi polutan di wilayah domestik.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Supaya scroll menyatu dengan halaman utama
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.3, // Proporsi kotak stasiun
              ),
              itemCount: RuasData.listofMap.length,
              itemBuilder: (context, index) {
                final stasiun = RuasData.listofMap[index];
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(stasiun['ikon'], color: primaryTeal, size: 28),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              stasiun['nama'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: stasiun['status'] == "Inactive"
                                      ? Colors.amber[900]
                                      : Colors.green[600],
                                  size: 8,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  stasiun['status'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: stasiun['status'] == "Inactive"
                                        ? Colors.amber[900]
                                        : Colors.green[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // ==========================================
            // ALAT IoT RUAS
            // ==========================================
            const Text(
              "RUAS Smart Devices",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryTeal,
              ),
            ),
            const Text(
              "Katalog solusi IoT modular yang dirancang untuk kebutuhan bisnis modern RUAS menghadirkan infrastruktur pemantauan udara cerdas yang membantu perusahaan Anda memenuhi standar kesehatan lingkungan (ESG) secara presisi.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: RuasData.listModel.length,
              itemBuilder: (context, index) {
                final alat = RuasData.listModel[index];

                return Card(
                  color: Colors.white,
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),

                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(8),
                            child: Image.asset(
                              alat.pathGambar,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alat.nama,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: primaryTeal,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                alat.deskripsi,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: primaryTeal.withOpacity(0.3)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: primaryTeal, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Ekosistem RUAS\nSetiap perangkat di atas dirancang khusus untuk mendeteksi berbagai parameter polusi. Ketuk salah satu alat untuk melihat detail sensor dan mulai menjaga kesegaran udara di sekitarmu.",
                      style: TextStyle(
                        fontSize: 10,
                        color: primaryTeal,
                        height: 1.4,
                      ),
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
