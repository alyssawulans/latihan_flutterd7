import 'package:flutter/material.dart';

// --- MODEL CLASS UNTUK LEVEL 3 ---
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

class AppImage1 {
  static const String logo = 'assets/images/logo_ruas.png';
  static const String avatar = 'assets/images/profile.webp';
}

// --- DATA SOURCE REPOSITORY ---
class RuasData {
  // Level 1: List String Sederhana
  static final List<String> listSederhana = [
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

  // Level 2: List of Maps
  static final List<Map<String, dynamic>> listofMap = [
    {
      "nama": "Stasiun Pemukiman",
      "ikon": Icons.home_work_outlined,
      "status": "Inactive",
    },
    {
      "nama": "Zona Industri Barat",
      "ikon": Icons.factory_outlined,
      "status": "Active",
    },
    {
      "nama": "Taman Kota Pusat",
      "ikon": Icons.park_outlined,
      "status": "Active",
    },
    {
      "nama": "Terminal Bus Utama",
      "ikon": Icons.directions_bus_filled_outlined,
      "status": "Active",
    },
    {
      "nama": "Area Sekolah & Edukasi",
      "ikon": Icons.school_outlined,
      "status": "Active",
    },
    {
      "nama": "Kawasan Perkantoran",
      "ikon": Icons.apartment_outlined,
      "status": "Inactive",
    },
    {
      "nama": "Pasar Tradisional",
      "ikon": Icons.storefront_outlined,
      "status": "Active",
    },
    {
      "nama": "Stasiun Pengukur Mobile",
      "ikon": Icons.shutter_speed_outlined,
      "status": "Active",
    },
    {
      "nama": "Hutan Kota Timur",
      "ikon": Icons.forest_outlined,
      "status": "Inactive",
    },
    {
      "nama": "Kawasan Bandara",
      "ikon": Icons.flight_takeoff_outlined,
      "status": "Active",
    },
  ];

  // Level 3: List of Model Objects
  static final List<Alatpantau> listModel = [
    Alatpantau(
      nama: "Sensor RUAS Eco-1",
      deskripsi:
          "Sensor portabel hemat daya untuk mendeteksi kadar PM2.5 di dalam ruangan pemukiman.",
      pathGambar: "assets/images/sensor_indoor.png",
    ),
    Alatpantau(
      nama: "Stasiun RUAS Pro-X",
      deskripsi:
          "Alat pemantau outdoor berskala besar untuk mendeteksi gas berbahaya (CO, NO2, SO2) di area industri.",
      pathGambar: "assets/images/sensor_outdoor.png",
    ),
    Alatpantau(
      nama: "RUAS Pocket Air",
      deskripsi:
          "Alat sekecil gantungan kunci untuk memantau kualitas udara secara real-time saat Anda berjalan kaki.",
      pathGambar: "assets/images/sensor_pocket.png",
    ),
    Alatpantau(
      nama: "Indikator Ozon Smart",
      deskripsi:
          "Alat khusus untuk mengukur ketebalan lapisan gas ozon permukaan di area perkotaan padat kendaraan.",
      pathGambar: "assets/images/sensor_ozone.png",
    ),
    Alatpantau(
      nama: "Termo-Higrometer RUAS",
      deskripsi:
          "Pemantau kombinasi untuk mengukur kelembapan udara tinggi dan fluktuasi suhu ekstrem lingkungan.",
      pathGambar: "assets/images/sensor_temp.png",
    ),
    Alatpantau(
      nama: "RUAS Hydro-Cleaner Monitor",
      deskripsi:
          "Alat integrasi penyaring udara sekaligus pemantau kebersihan sirkulasi udara di ruang publik.",
      pathGambar: "assets/images/sensor_cleaner.png",
    ),
    Alatpantau(
      nama: "Sensor Laser Partikulat",
      deskripsi:
          "Menggunakan teknologi tembakan laser presisi tinggi untuk menghitung micro-partikel debu PM10.",
      pathGambar: "assets/images/sensor_laser.png",
    ),
    Alatpantau(
      nama: "Stasiun Cuaca RUAS v2",
      deskripsi:
          "Perangkat lengkap penakar curah hujan, arah kecepatan angin, dan indeks radiasi UV matahari.",
      pathGambar: "assets/images/sensor_weather.png",
    ),
    Alatpantau(
      nama: "RUAS Car Carbon Detector",
      deskripsi:
          "Dipasang di dashboard mobil untuk memantau kebocoran gas CO yang membahayakan pengemudi.",
      pathGambar: "assets/images/sensor_car.png",
    ),
    Alatpantau(
      nama: "Module IoT Agrikultur",
      deskripsi:
          "Sensor khusus hutan dan area pertanian untuk mengukur tingkat gas amonia dan kesehatan udara tanah.",
      pathGambar: "assets/images/sensor_agri.png",
    ),
  ];
}
