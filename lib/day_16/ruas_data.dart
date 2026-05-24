import 'ruas_models.dart';
import 'package:flutter/material.dart';

// --- LEVEL 1 DATA (Murni List<String> untuk Kategori/Parameter) ---
List<String> namaParameterList = [
  "Indeks Standar Pencemar Udara (ISPU)",
  "Partikulat Halus (PM2.5)",
  "Partikulat Kasar (PM10)",
  "Gas Karbon Monoksida (CO)",
  "Gas Nitrogen Dioksida (NO2)",
  "Gas Sulfur Dioksida (SO2)",
  "Ozon Permukaan (O3)",
  "Suhu Udara Lingkungan",
  "Kelembapan Udara Spasial",
  "Tekanan Udara Atmosfer",
];

// --- LEVEL 2 DATA (List<Map<String, dynamic>> untuk Stasiun & Ikon) ---
List<Map<String, dynamic>> stasiunList = [
  {"nama": "Stasiun Pemukiman A", "ikon": Icons.home_work_outlined},
  {"nama": "Zona Industri Barat", "ikon": Icons.factory_outlined},
  {"nama": "Taman Kota Pusat", "ikon": Icons.park_outlined},
  {"nama": "Kawasan Bisnis Sudirman", "ikon": Icons.business_outlined},
  {"nama": "Area Rumah Sakit Umum", "ikon": Icons.local_hospital_outlined},
  {"nama": "Kampus Universitas Raya", "ikon": Icons.school_outlined},
  {
    "nama": "Terminal Terpadu Selatan",
    "ikon": Icons.directions_bus_filled_outlined,
  },
  {"nama": "Kaki Gunung Salak", "ikon": Icons.terrain_outlined},
  {"nama": "Pesisir Pantai Utara", "ikon": Icons.water_outlined},
  {"nama": "Zona Konstruksi Baru", "ikon": Icons.construction_outlined},
];

// --- LEVEL 3 DATA (List dengan Model Class untuk Alat IoT RUAS) ---
List<RuasModel> alatRuasWithModel = const [
  RuasModel(
    nama: "Sensor RUAS Eco-1",
    deskripsi:
        "Sensor nirkabel ultra-low power untuk pemantauan PM2.5, suhu, dan kelembapan.",
    pathGambar: "assets/images/eco1.png",
  ),
  RuasModel(
    nama: "Stasiun RUAS Pro-X",
    deskripsi:
        "Hub pemantau cuaca komprehensif yang dilengkapi sensor gas NO2, SO2, dan O3.",
    pathGambar: "assets/images/prox.png",
  ),
  RuasModel(
    nama: "Node RUAS Forest-M",
    deskripsi:
        "Perangkat ruggedized dengan panel surya terintegrasi untuk monitoring kelembapan tanah.",
    pathGambar: "assets/images/forestm.png",
  ),
  RuasModel(
    nama: "Sensor RUAS Aqua-V",
    deskripsi:
        "Alat pemantau kualitas air cerdas yang mengukur pH, kadar oksigen terlarut, dan...",
    pathGambar: "assets/images/aquav.png",
  ),
  RuasModel(
    nama: "Gateway RUAS Core-9",
    deskripsi:
        "Pusat transmisi data LoRaWAN yang mampu menghubungkan hingga 500 node sensor...",
    pathGambar: "assets/images/core9.png",
  ),
  RuasModel(
    nama: "Sensor RUAS Noise-Z",
    deskripsi:
        "Pemantau tingkat kebisingan lingkungan dengan filter frekuensi cerdas untuk...",
    pathGambar: "assets/images/noisez.png",
  ),
  RuasModel(
    nama: "Meter RUAS Energy-S",
    deskripsi:
        "Alat ukur efisiensi energi bangunan yang terhubung langsung ke dashboard...",
    pathGambar: "assets/images/energys.png",
  ),
  RuasModel(
    nama: "Probe RUAS Soil-T",
    deskripsi:
        "Sensor kesuburan tanah dengan deteksi NPK digital untuk optimalisasi...",
    pathGambar: "assets/images/soilt.png",
  ),
  RuasModel(
    nama: "Analyzer RUAS Gas-G",
    deskripsi:
        "Perangkat analisis gas portabel khusus emisi industri dengan konektivitas Bluetooth.",
    pathGambar: "assets/images/gasg.png",
  ),
  RuasModel(
    nama: "Beacon RUAS Light-L",
    deskripsi:
        "Sensor intensitas cahaya matahari dan UV untuk pemantauan radiasi dan...",
    pathGambar: "assets/images/lightl.png",
  ),
];
