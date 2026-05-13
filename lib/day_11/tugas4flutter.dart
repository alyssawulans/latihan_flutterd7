import 'package:flutter/material.dart';

class Tugas4flutter extends StatelessWidget {
  const Tugas4flutter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Laporan & Riwayat Udara",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(255, 246, 246, 247),

      body: ListView(
        padding: EdgeInsets.all(16.0),
        physics: BouncingScrollPhysics(),

        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Text(
                  "Laporan Kondisi Udara",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 12),
                // Input Laporan Lokasi
                TextField(
                  decoration: InputDecoration(
                    labelText: "Titik Lokasi (Nama Jalan/Gedung)",
                    hintText: "Masukan Titik Lokasi (Nama Jalan/Gedung)",
                    filled: true,
                    fillColor: const Color.fromARGB(14, 0, 150, 135),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.map),
                  ),
                ),

                SizedBox(height: 12),
                //  Nilai AQI
                TextField(
                  decoration: InputDecoration(
                    labelText: "Skor AQI Teramati",
                    hintText: "Masukan Skor AQI Teramati",
                    filled: true,
                    fillColor: const Color.fromARGB(14, 0, 150, 135),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.air),
                  ),
                ),

                SizedBox(height: 12),
                // Input Nama Pelapor
                TextField(
                  decoration: InputDecoration(
                    labelText: "Nama Pelapor",
                    hintText: "Masukan Nama Pelapor",
                    filled: true,
                    fillColor: const Color.fromARGB(14, 0, 150, 135),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),

                SizedBox(height: 12),
                //  Input Catatan Tambahan
                TextField(
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: "Catatan Tambahan (Misal: Berkabut/Bau Asap)",
                    hintText: "Masukan Catatan Teramati",
                    filled: true,
                    fillColor: const Color.fromARGB(14, 0, 150, 135),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.notes),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),

          Divider(),
          SizedBox(height: 12),

          Text(
            "Riwayat Laporan Terakhir",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          // Membuat Laporan
          SizedBox(height: 6),
          //Laporan #1
          Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),

            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.warning, color: Colors.white),
                  ),
                  title: Text(
                    "Jakarta Pusat",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "AQI: 156 - Tidak Sehat. Dilaporkan 5 menit lalu.",
                  ),
                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          //Laporan #2
          Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.cloud, color: Colors.white),
                  ),
                  title: Text(
                    "Bandung Kota",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("AQI: 95 - Sedang. Dilaporkan 30 menit lalu."),
                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          //Laporan #3
          Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check_circle, color: Colors.white),
                  ),
                  title: Text(
                    "Yogyakarta",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("AQI: 42 - Baik. Dilaporkan 1 Hari lalu."),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          //Laporan #4
          Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.masks_rounded, color: Colors.white),
                  ),
                  title: Text(
                    "Semarang",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "AQI: 120 - Sensitif. Dilaporkan 1 hari lalu.",
                  ),
                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          //Laporan #5
          Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check_circle, color: Colors.white),
                  ),
                  title: Text(
                    "Blitar",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("AQI: 20 - Baik. Dilaporkan 3 hari lalu."),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
