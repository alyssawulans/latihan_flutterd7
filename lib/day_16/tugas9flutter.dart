import 'package:flutter/material.dart';

class Alatpantau {
  final String nama;
  final String deskripsi;
  final String pathGambar;

  Alatpantau({
    required this.nama,
    required this.deskripsi,
    required this.pathGambar,
  });
}

class Tugas9flutter extends StatelessWidget {
  Tugas9flutter({super.key});

  final List<String> _listSederhana = [
    "Karbon Monoksida (CO)",
    "Partikulat (PM2.5)",
    "Partikulat (PM10)",
    "Sulfur Dioksida (SO2)",
    "Ozon (O3)",
    "Nitrogen Dioksida (NO2)",
    "Indeks Standar Pencemar (ISPU)",
    "Kelembapan Udara",
    "Suhu Lingkungan",
    "Zona Hijau Kota",
  ];

  final List<Map<String, dynamic>> _listofMap = [
    {"nama": "Stasiun Pemukiman A", "ikon": Icons.home_work_outlined},
    {"nama": "Zona Industri Barat", "ikon": Icons.factory_outlined},
    {"nama": "Taman Kota Pusat", "ikon": Icons.park_outlined},
    {
      "nama": "Terminal Bus Utama",
      "ikon": Icons.directions_bus_filled_outlined,
    },
    {"nama": "Area Sekolah & Edukasi", "ikon": Icons.school_outlined},
    {"nama": "Kawasan Perkantoran", "ikon": Icons.apartment_outlined},
    {"nama": "Pasar Tradisional", "ikon": Icons.storefront_outlined},
    {"nama": "Stasiun Pengukur Mobile", "ikon": Icons.shutter_speed_outlined},
    {"nama": "Hutan Kota Timur", "ikon": Icons.forest_outlined},
    {"nama": "Kawasan Bandara", "ikon": Icons.flight_takeoff_outlined},
  ];

  final List<Alatpantau> _listModel = [
    Alatpantau(
      nama: "Sensor RUAS Eco-1",
      deskripsi:
          "Sensor portabel hemat daya untuk mendeteksi kadar PM2.5 di dalam ruangan pemukiman.",
      pathGambar:
          "assets/images/tugas9flutter/sensor_indoor.png", // Pastikan nanti file gambarnya ada atau gunakan fallback icon jika kosong
    ),
    Alatpantau(
      nama: "Stasiun RUAS Pro-X",
      deskripsi:
          "Alat pemantau outdoor berskala besar untuk mendeteksi gas berbahaya (CO, NO2, SO2) di area industri.",
      pathGambar: "assets/images/tugas9flutter/sensor_outdoor.png",
    ),
    Alatpantau(
      nama: "RUAS Pocket Air",
      deskripsi:
          "Alat sekecil gantungan kunci untuk memantau kualitas udara secara real-time saat Anda berjalan kaki.",
      pathGambar: "assets/images/tugas9flutter/sensor_pocket.png",
    ),
    Alatpantau(
      nama: "Indikator Ozon Smart",
      deskripsi:
          "Alat khusus untuk mengukur ketebalan lapisan gas ozon permukaan di area perkotaan padat kendaraan.",
      pathGambar: "assets/images/tugas9flutter/sensor_ozone.png",
    ),
    Alatpantau(
      nama: "Termo-Higrometer RUAS",
      deskripsi:
          "Pemantau kombinasi untuk mengukur kelembapan udara tinggi dan fluktuasi suhu ekstrem lingkungan.",
      pathGambar: "assets/images/tugas9flutter/sensor_temp.png",
    ),
    Alatpantau(
      nama: "RUAS Hydro-Cleaner Monitor",
      deskripsi:
          "Alat integrasi penyaring udara sekaligus pemantau kebersihan sirkulasi udara di ruang publik.",
      pathGambar: "assets/images/tugas9flutter/sensor_cleaner.png",
    ),
    Alatpantau(
      nama: "Sensor Laser Partikulat",
      deskripsi:
          "Menggunakan teknologi tembakan laser presisi tinggi untuk menghitung micro-partikel debu PM10.",
      pathGambar: "assets/images/tugas9flutter/sensor_laser.png",
    ),
    Alatpantau(
      nama: "Stasiun Cuaca RUAS v2",
      deskripsi:
          "Perangkat lengkap penakar curah hujan, arah kecepatan angin, dan indeks radiasi UV matahari.",
      pathGambar: "assets/images/tugas9flutter/sensor_weather.png",
    ),
    Alatpantau(
      nama: "RUAS Car Carbon Detector",
      deskripsi:
          "Dipasang di dashboard mobil untuk memantau kebocoran gas CO yang membahayakan pengemudi.",
      pathGambar: "assets/images/tugas9flutter/sensor_car.png",
    ),
    Alatpantau(
      nama: "Module IoT Agrikultur",
      deskripsi:
          "Sensor khusus hutan dan area pertanian untuk mengukur tingkat gas amonia dan kesehatan udara tanah.",
      pathGambar: "assets/images/tugas9flutter/sensor_agri.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xFFF5F8F7),
        appBar: AppBar(
          backgroundColor: Color(0xFF0F4C43),
          elevation: 0,
          title: const Text(
            "Katalog Data Dinamis RUAS",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.amber,
            tabs: [
              Tab(text: "Level 1 (List)"),
              Tab(text: "Level 2 (Map)"),
              Tab(text: "Level 3 (Model)"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAMPILAN LEVEL 1
            _buildLevel1(),

            // TAMPILAN LEVEL 2
            _buildLevel2(),

            // TAMPILAN LEVEL 3
            _buildLevel3(),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // LEVEL 1 UI: ListView.builder + ListTile sederhana
  // ===========================================================================
  Widget _buildLevel1() {
    return ListView.builder(
      itemCount: _listSederhana.length,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemBuilder: (context, index) {
        return Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(
              _listSederhana[index],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F4C43),
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // LEVEL 2 UI: ListView.builder membaca Map dinamis (Nama & Ikon)
  // ===========================================================================
  Widget _buildLevel2() {
    return ListView.builder(
      itemCount: _listofMap.length,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemBuilder: (context, index) {
        // Mengambil map data berdasarkan index saat ini
        final Map<String, dynamic> item = _listofMap[index];

        return Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFE0F2F1),
              child: Icon(item["ikon"], color: const Color(0xFF0F4C43)),
            ),
            title: Text(
              item["nama"],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text("Status Stasiun Pemantau: Aktif"),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // LEVEL 3 UI: ListView.builder + Custom Widget memanggil Objek Model
  // ===========================================================================
  Widget _buildLevel3() {
    return ListView.builder(
      itemCount: _listModel.length,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemBuilder: (context, index) {
        // Memanggil custom widget secara rapi dan mengirim data objek modelnya
        return ItemProdukAlat(produk: _listModel[index]);
      },
    );
  }
}

// ===========================================================================
// CUSTOM WIDGET UNTUK LEVEL 3 (Model-View Separation)
// ===========================================================================
class ItemProdukAlat extends StatelessWidget {
  final Alatpantau produk; // Menangkap kiriman data objek model dari atas

  const ItemProdukAlat({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Penampil Gambar (Menggunakan Gambar Lokal dengan Pengaman Fallback Icon)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  produk.pathGambar,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Jika file aset fisik gambar belum kamu download, otomatis diganti ikon keren ini
                    return const Icon(
                      Icons.developer_board,
                      size: 40,
                      color: Color(0xFF0F4C43),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Kolom Konten Teks (Nama & Deskripsi)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.nama,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F4C43),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    produk.deskripsi,
                    maxLines: 3,
                    overflow: TextOverflow
                        .ellipsis, // Teks otomatis berubah jadi titik-titik (...) jika kepanjangan
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
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
  }
}
