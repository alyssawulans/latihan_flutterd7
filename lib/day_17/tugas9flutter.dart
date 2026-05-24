import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/day_17/ruas_data.dart'; // Import file data kita tadi

class Tugas9flutter1 extends StatelessWidget {
  const Tugas9flutter1({super.key});

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
        title: const Text(
          "RUAS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryTeal,
            fontSize: 19,
            letterSpacing: 0.5,
          ),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // LEVEL 1: PARAMETER UDARA (Horizontal Chips)
            // ==========================================
            const Text(
              "Level 1: Parameter Udara",
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
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Chip(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.teal, width: 0.8),
                      label: Text(
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
            // LEVEL 2: STASIUN REGIONAL (Grid 2 Kolom)
            // ==========================================
            const Text(
              "Level 2: Stasiun Regional",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryTeal,
              ),
            ),
            const Text(
              "Stasiun regional pemantauan wilayah pemukiman.",
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
                            const SizedBox(height: 2),
                            const Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: Colors.green,
                                  size: 8,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Active",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.green,
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
            // LEVEL 3: ALAT IoT RUAS (Vertical List Card)
            // ==========================================
            const Text(
              "Level 3: Alat IoT RUAS",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryTeal,
              ),
            ),
            const Text(
              "Alat IoT RUAS - Katalog perangkat bisnis profesional.",
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
                        // Placeholder Gambar / Gambar Asli jika disiapkan
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              alat.pathGambar,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback jika aset gambar belum ditaruh di pubspec.yaml
                                return const Icon(
                                  Icons.developer_board,
                                  color: Colors.grey,
                                  size: 30,
                                );
                              },
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

            const SizedBox(height: 16),

            // Banner Info MVC bawah sesuai contoh gambar kamu
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
                      "Model-View Separation (MVC)\nLayar ini mengimplementasikan pemisahan logic AlatPantau sebagai model data dan visualisasi katalog sebagai View.",
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
