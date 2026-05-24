import 'package:flutter/material.dart';
import 'alat_model.dart';

class KatalogPage extends StatefulWidget {
  const KatalogPage({super.key});

  @override
  State<KatalogPage> createState() => _KatalogPageState();
}

class _KatalogPageState extends State<KatalogPage> {
  // State untuk mengontrol halaman mana yang aktif dari Drawer
  int _activeDrawerIndex = 0; // 0: Level 1, 1: Level 2, 2: Level 3

  // State dummy untuk BottomNavigationBar (biar pemanis visual mirip mockup)
  final int _bottomNavIndex = 1; // Default di 'Katalog'

  // -----------------------------------------------------------------------
  // LEVEL 1 DATA: List<String> murni berisi nama kategori (Minimal 10 data)
  // -----------------------------------------------------------------------
  final List<String> _listSederhana = [
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

  // -----------------------------------------------------------------------
  // LEVEL 2 DATA: List<Map<String, dynamic>> Nama & Ikon (Minimal 10 data)
  // -----------------------------------------------------------------------
  final List<Map<String, dynamic>> _listOfMap = [
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

  // -----------------------------------------------------------------------
  // LEVEL 3 DATA: List of Model Class (Nama, Gambar, Deskripsi)
  // -----------------------------------------------------------------------
  final List<AlatPemantau> _listModel = [
    AlatPemantau(
      nama: "Sensor RUAS Eco-1",
      deskripsi:
          "Sensor nirkabel ultra-low power untuk pemantauan PM2.5, suhu, dan kelembapan.",
      pathGambar: "assets/images/tugas9flutter/sensor_agri.png",
    ),
    AlatPemantau(
      nama: "Stasiun RUAS Pro-X",
      deskripsi:
          "Hub pemantau cuaca komprehensif yang dilengkapi sensor gas NO2, SO2, dan O3.",
      pathGambar: "assets/images/tugas9flutter/sensor_agri.png",
    ),
    AlatPemantau(
      nama: "Node RUAS Forest-M",
      deskripsi:
          "Perangkat ruggedized dengan panel surya terintegrasi untuk monitoring kelembapan tanah.",
      pathGambar: "assets/images/tugas9flutter/sensor_agri.png",
    ),
    AlatPemantau(
      nama: "Sensor RUAS Aqua-V",
      deskripsi:
          "Alat pemantau kualitas air cerdas yang mengukur pH, kadar oksigen terlarut, dan...",
      pathGambar:
          "assets/images/tugas9flutter/sensor_agri.pnger/sensor_agri.png",
    ),
    AlatPemantau(
      nama: "Sensor RUAS Noise-Z",
      deskripsi:
          "Pemantau tingkat kebisingan lingkungan dengan filter frekuensi cerdas untuk...",
      pathGambar: "assets/images/tugas9flutter/sensor_agri.png",
    ),
    AlatPemantau(
      nama: "Meter RUAS Energy-S",
      deskripsi:
          "Alat ukur efisiensi energi bangunan yang terhubung langsung ke dashboard...",
      pathGambar: "assets/images/tugas9flutter/sensor_agri.png",
    ),
    AlatPemantau(
      nama: "Probe RUAS Soil-T",
      deskripsi:
          "Sensor kesuburan tanah dengan deteksi NPK digital untuk optimalisasi...",
      pathGambar: "assets/images/tugas9flutter/sensor_agri.png",
    ),
    AlatPemantau(
      nama: "Analyzer RUAS Gas-G",
      deskripsi:
          "Perangkat analisis gas portabel khusus emisi industri dengan konektivitas Bluetooth.",
      pathGambar: "assets/images/tugas9flutter/sensor_agri.png",
    ),
    AlatPemantau(
      nama: "Beacon RUAS Light-L",
      deskripsi:
          "Sensor intensitas cahaya matahari dan UV untuk pemantauan radiasi dan...",
      pathGambar: "assets/images/tugas9flutter/sensor_agri.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const Color appBgColor = Color(0xFFF5F8F7);
    const Color primaryTeal = Color(0xFF0F4C43); // Warna khas RUAS

    return Scaffold(
      backgroundColor: appBgColor,

      // ===========================================================================
      // APP BAR (Sesuai Gambar Mockup dengan Foto Profil Kanan Atas)
      // ===========================================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: primaryTeal),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "RUAS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryTeal,
                letterSpacing: 0.8,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/profile.webp', // Fallback otomatis ke avatar jika aset kosong
                height: 34,
                width: 34,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.account_circle,
                  size: 34,
                  color: primaryTeal,
                ),
              ),
            ),
          ],
        ),
      ),

      // ===========================================================================
      // DRAWER MENU (Sesuai Persis dengan Gambar Struktur Samping Mockup L1)
      // ===========================================================================
      drawer: Drawer(
        child: Container(
          color: appBgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  children: [
                    Icon(Icons.blur_on_rounded, color: primaryTeal, size: 32),
                    SizedBox(width: 10),
                    Text(
                      "RUAS",
                      style: TextStyle(
                        color: primaryTeal,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 10, bottom: 5),
                child: Text(
                  "KATALOG KUALITAS UDARA",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              // Item Navigasi Drawer Berdasarkan Level Penilaian
              _buildDrawerItem(
                Icons.grid_view_rounded,
                "L1: Parameter",
                0,
                primaryTeal,
              ),
              _buildDrawerItem(
                Icons.location_on_outlined,
                "L2: Stasiun",
                1,
                primaryTeal,
              ),
              _buildDrawerItem(
                Icons.developer_board,
                "L3: Alat IoT",
                2,
                primaryTeal,
              ),

              const Divider(height: 30, indent: 16, endIndent: 16),
              _buildDrawerItem(
                Icons.settings_outlined,
                "Pengaturan",
                -1,
                primaryTeal,
              ),
              _buildDrawerItem(
                Icons.help_outline_rounded,
                "Bantuan",
                -1,
                primaryTeal,
              ),
            ],
          ),
        ),
      ),

      // ===========================================================================
      // BODY SWITCHING BERDASARKAN DRAWER INDEX YANG DIPILIH
      // ===========================================================================
      body: IndexedStack(
        index: _activeDrawerIndex,
        children: [
          _buildLevel1Layout(primaryTeal),
          _buildLevel2Layout(primaryTeal),
          _buildLevel3Layout(primaryTeal),
        ],
      ),

      // ===========================================================================
      // BOTTOM NAVIGATION BAR (Sesuai Gambar bawah Mockup)
      // ===========================================================================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryTeal,
        unselectedItemColor: Colors.grey[500],
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted_rounded),
            activeIcon: Icon(Icons.format_list_bulleted_rounded),
            label: "Katalog",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_toggle_off_rounded),
            activeIcon: Icon(Icons.history),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  // Fungsi Pembentuk Item List Drawer dengan Highlight Warna Aktif
  Widget _buildDrawerItem(
    IconData icon,
    String title,
    int index,
    Color themeColor,
  ) {
    final bool isSelected = _activeDrawerIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE0F2F1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: isSelected ? themeColor : Colors.black54),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? themeColor : Colors.black87,
          ),
        ),
        onTap: () {
          if (index != -1) {
            setState(() => _activeDrawerIndex = index); // Ganti halaman body
          }
          Navigator.pop(context); // Tutup drawer otomatis
        },
      ),
    );
  }

  // ===========================================================================
  // LAYOUT LEVEL 1: Murni List<String> + ListTile(title: Text(...))
  // ===========================================================================
  Widget _buildLevel1Layout(Color mainColor) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: _listSederhana.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Katalog Level 1: Parameter",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Pemantauan kualitas udara dan kondisi meteorologi secara real-time.",
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        if (index == _listSederhana.length + 1) {
          return Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Indeks Kualitas Udara (AQI)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "42 - Baik",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.42,
                    minHeight: 6,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                  ),
                ),
              ],
            ),
          );
        }

        // WAJIB TUGAS LEVEL 1: ListTile(title: Text(...))
        return Card(
          color: Colors.white,
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            title: Text(
              _listSederhana[index - 1],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // LAYOUT LEVEL 2: List of Map + ListTile(leading: Icon(...), title: Text(...))
  // ===========================================================================
  Widget _buildLevel2Layout(Color mainColor) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: _listOfMap.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Katalog Level 2: Stasiun Regional",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Pilih stasiun regional untuk memantau data kualitas udara dan parameter lingkungan.",
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        if (index == _listOfMap.length + 1) {
          return Container(
            margin: const EdgeInsets.only(top: 12),
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: mainColor,
            ),
            padding: const EdgeInsets.all(16),
            child: const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Data lingkungan terpercaya\nuntuk masa depan yang lebih bersih.",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          );
        }

        final item = _listOfMap[index - 1];

        // WAJIB TUGAS LEVEL 2: ListTile(leading: Icon(...), title: Text(...))
        return Card(
          color: Colors.white,
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFE0F2F1),
                shape: BoxShape.circle,
              ),
              child: Icon(item["ikon"], color: mainColor, size: 20),
            ),
            title: Text(
              item["nama"],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Status: Aktif",
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // LAYOUT LEVEL 3: Model Class + Custom Widget ItemProduk (Gambar & Deskripsi)
  // ===========================================================================
  Widget _buildLevel3Layout(Color mainColor) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: _listModel.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Katalog Level 3: Alat IoT RUAS",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Eksplorasi lini perangkat pemantauan lingkungan presisi tinggi untuk ekosistem berkelanjutan.",
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        if (index == _listModel.length + 1) {
          return Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: mainColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Model-View Separation (MVC)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "Layar ini mengimplementasikan pemisahan logic AlatPemantau sebagai data model (Model) dan visualisasi katalog sebagai presentasi layer (View). Semua data perangkat ditarik secara dinamis dari registry IoT RUAS untuk menjamin integritas data lintas platform.",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        }

        // WAJIB TUGAS LEVEL 3: Memanggil Custom Widget ItemProduk
        return ItemProduk(produk: _listModel[index - 1]);
      },
    );
  }
}

// ===========================================================================
// CUSTOM WIDGET UNTUK LEVEL 3 (Wajib Memakai Atribut Gambar & Deskripsi)
// ===========================================================================
class ItemProduk extends StatelessWidget {
  final AlatPemantau produk;

  const ItemProduk({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    const Color primaryTeal = Color(0xFF0F4C43);

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                produk.pathGambar,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 70,
                  height: 70,
                  color: const Color(0xFFE0F2F1),
                  child: const Icon(Icons.developer_board, color: primaryTeal),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: primaryTeal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    produk.deskripsi,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
