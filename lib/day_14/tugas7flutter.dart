import 'package:flutter/material.dart';

// Nama kelas sudah diubah menjadi Tugas7flutter sesuai permintaanmu
class Tugas7flutter extends StatefulWidget {
  const Tugas7flutter({super.key});

  @override
  State<Tugas7flutter> createState() => _Tugas7flutterState();
}

class _Tugas7flutterState extends State<Tugas7flutter> {
  int _selectedIndex = 0;

  // List Halaman Multi-Tab
  final List<Widget> _pages = [
    const HomeScreen(),
    const Scaffold(
      body: Center(
        child: Text(
          "Halaman Peta",
          style: TextStyle(
            color: Color(0xFF1A2E44),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text(
          "Halaman Laporan",
          style: TextStyle(
            color: Color(0xFF1A2E44),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text(
          "Halaman Edukasi",
          style: TextStyle(
            color: Color(0xFF1A2E44),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      // Navigasi Bawah Melayang & Melengkung Persis Seperti Mockup Figma
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.white,
            unselectedItemColor: const Color(0xFF7A8B9E),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.home_filled, 'Beranda', 0),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.map_outlined, 'Peta', 1),
                label: 'Peta',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.assignment_outlined, 'Laporan', 2),
                label: 'Laporan',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.school_outlined, 'Edukasi', 3),
                label: 'Edukasi',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.person_outline, 'Profil', 4),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Desain Pil Aktif Kustom Agar Tidak Menyebabkan Eror Panjang Koleksi
  Widget _buildNavIcon(IconData iconData, String label, int index) {
    bool isActive = _selectedIndex == index;
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF008080),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(iconData, size: 24, color: const Color(0xFF7A8B9E)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF7A8B9E)),
        ),
      ],
    );
  }
}

// ==================== WIDGET TAB 1: HOME SCREEN ====================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F8FB),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Image.asset(
            'assets/images/logo_ruas.png',
            height: 26,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox.shrink();
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_none_outlined,
                  color: Color(0xFF1A2E44),
                  size: 24,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              "Hai, Andi",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A2E44),
              ),
            ),
            const Text(
              "Selamat pagi!",
              style: TextStyle(fontSize: 14, color: Color(0xFF7A8B9E)),
            ),
            const SizedBox(height: 20),

            // Card Lokasi Utama
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE6F2F2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF008080),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Cibadak, Sukabumi",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2E44),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "24 September 2023, 08.30",
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF7A8B9E).withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Banner Komponen AQI dengan Background Gambar Lokal Utama
            Container(
              width: double.infinity,
              height: 210,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                image: const DecorationImage(
                  image: AssetImage('assets/images/gambarbag.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "AQI SAAT INI",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7A8B9E),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "32",
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A2E44),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF2E7D32),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "GOOD",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.gpp_good_outlined,
                            color: Color(0xFF2E7D32),
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Kualitas udara baik untuk aktivitas luar ruangan.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1A2E44),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Ringkasan Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Ringkasan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A2E44),
                  ),
                ),
                Text(
                  "Lihat Semua",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF008080),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Flexible(
                  child: _buildParamCard(
                    Icons.eco_outlined,
                    "PM2.5",
                    "12.0 µg/m³",
                  ),
                ),
                const SizedBox(width: 14),
                Flexible(
                  child: _buildParamCard(
                    Icons.device_thermostat_outlined,
                    "SUHU",
                    "24°C",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Flexible(
                  child: _buildParamCard(
                    Icons.opacity_outlined,
                    "KELEMBAPAN",
                    "90%",
                  ),
                ),
                const SizedBox(width: 14),
                Flexible(
                  child: _buildParamCard(
                    Icons.air_outlined,
                    "ANGIN",
                    "2.1 km/h",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),

            // Pantauan Stasiun Real-Time
            const Text(
              "Pantauan Stasiun Real-Time",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A2E44),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.wb_sunny_outlined,
                    color: Colors.orange,
                    size: 24,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Cibadak, Sukabumi",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A2E44),
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "AQI: 32",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      "GOOD",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 26),

            // Grafik AQI 24 Jam
            const Text(
              "AQI 24 Jam",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A2E44),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              height: 160,
              child: Center(
                child: Icon(
                  Icons.show_chart_rounded,
                  size: 90,
                  color: const Color(0xFF008080).withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: 26),

            // Rekomendasi Aktivitas
            const Text(
              "Rekomendasi Aktivitas",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A2E44),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Flexible(
                  child: _buildActivityCard(
                    Icons.directions_run_outlined,
                    "Olahraga Luar",
                    "Waktu yang tepat untuk lari pagi atau bersepeda.",
                  ),
                ),
                const SizedBox(width: 14),
                Flexible(
                  child: _buildActivityCard(
                    Icons.park_outlined,
                    "Piknik di Taman",
                    "Udara segar sangat mendukung untuk bersantai.",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),

            // Artikel Terbaru
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Artikel Terbaru",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A2E44),
                  ),
                ),
                Text(
                  "Lihat Semua",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF008080),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _buildArticleItem(
              "Apa itu PM2.5 & Mengapa Berbahaya?",
              "5 menit baca",
              'assets/images/artikel1.jpg',
            ),
            _buildArticleItem(
              "Cara Melindungi Diri dari Polusi",
              "4 menit baca",
              'assets/images/artikel2.jpg',
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildParamCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF008080), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A2E44),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(IconData icon, String title, String desc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFF4F8FB),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF008080), size: 24),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A2E44),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleItem(String title, String time, String assetPath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              assetPath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 60,
                height: 60,
                color: Colors.teal.withOpacity(0.1),
                child: const Icon(Icons.image, color: Color(0xFF008080)),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1A2E44),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 13, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _logoFallback() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF008080),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              "R",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          "RUAS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF008080),
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

// ==================== WIDGET TAB 2: PROFILE SCREEN ====================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F8FB),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/images/profile.webp',
          height: 26,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none_outlined,
                color: Color(0xFF1A2E44),
                size: 26,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Card User Info Utama Persis Gambar profile.png
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      'assets/images/avatar.jpg',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const CircleAvatar(
                            radius: 40,
                            backgroundColor: Color(0xFFE6F2F2),
                            child: Icon(
                              Icons.person,
                              size: 45,
                              color: Color(0xFF008080),
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    "Andi Pratama",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A2E44),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "andi.pratama@email.com",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 130,
                    height: 40,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFF008080),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Edit Profil",
                        style: TextStyle(
                          color: Color(0xFF008080),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            const Text(
              "Pengaturan",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A2E44),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  _buildListTile(
                    Icons.notifications_none_outlined,
                    "Notifikasi",
                    "",
                  ),
                  _buildListTile(
                    Icons.location_on_outlined,
                    "Lokasi Saya",
                    "Cibadak, Sukabumi",
                  ),
                  _buildListTile(
                    Icons.calendar_view_day_outlined,
                    "Satuan",
                    "µg/m³, °C, km/h",
                  ),
                  _buildListTile(
                    Icons.language_outlined,
                    "Bahasa",
                    "Bahasa Indonesia",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            const Text(
              "Tentang",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A2E44),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  _buildListTile(Icons.info_outline, "Tentang RUAS", ""),
                  _buildListTile(Icons.gavel_outlined, "Kebijakan Privasi", ""),
                  _buildListTile(
                    Icons.description_outlined,
                    "Syarat & Ketentuan",
                    "",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Keluar Akun Merah Elegan
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                  size: 20,
                ),
                label: const Text(
                  "Keluar",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String trailingText) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFFF4F8FB),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF008080), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1A2E44),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText.isNotEmpty)
            Text(
              trailingText,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
      onTap: () {},
    );
  }
}

// Ekstensi helper Image.asset agar aman dari crash sekecil apa pun di compiler local web
extension on Image {
  static Widget asset(
    String name, {
    double? height,
    double? width,
    BoxFit? fit,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
    Widget? errorWidget,
  }) {
    return Image(
      image: AssetImage(name),
      height: height,
      width: width,
      fit: fit,
      errorBuilder:
          errorBuilder ??
          (context, error, stackTrace) =>
              errorWidget ?? const Icon(Icons.broken_image),
    );
  }
}
