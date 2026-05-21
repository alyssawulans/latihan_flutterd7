import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Import file constant kamu untuk membaca path gambar lokal

class PendaftaranRuasScreen extends StatefulWidget {
  const PendaftaranRuasScreen({super.key});

  @override
  State<PendaftaranRuasScreen> createState() => _PendaftaranRuasScreenState();
}

class AppImage {
  static const String logo = 'assets/images/logo_ruas.png';
  static const String avatar = 'assets/images/profile.webp';
}

class _PendaftaranRuasScreenState extends State<PendaftaranRuasScreen> {
  // ===========================================================================
  // STATE VARIABLES (Diambil dari Day 15 & Disesuaikan untuk RUAS)
  // ===========================================================================
  bool isCheck = false; // Logika Syarat & Ketentuan (Tugas 1)
  bool isSwitch = false; // Logika Mode Tampilan Gelap/Terang (Tugas 2)
  String? selectedDropdown; // Logika Kategori (Tugas 3)
  DateTime? selectedDate; // Logika DatePicker (Tugas 4)
  TimeOfDay? selectedTime; // Logika TimePicker (Tugas 5)

  // Daftar pilihan kategori stasiun pemantauan udara RUAS
  final List<String> _daftarKategori = [
    "Pemukiman",
    "Kawasan Industri",
    "Hutan & Taman",
    "Lainnya",
  ];

  @override
  Widget build(BuildContext context) {
    // LOGIKA WARNA: Berubah dinamis mengikuti status switch (Tugas 2)
    Color backgroundColor = isSwitch
        ? const Color(0xFF15191C)
        : const Color(0xFFF5F8F7);
    Color cardColor = isSwitch ? const Color(0xFF21282C) : Colors.white;
    Color primaryText = isSwitch ? Colors.white : const Color(0xFF0F4C43);
    Color secondaryText = isSwitch ? Colors.white70 : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,

      // ===========================================================================
      // 1. APP BAR (Menggunakan Asset Gambar Lokal)
      // ===========================================================================
      appBar: AppBar(
        backgroundColor: isSwitch ? const Color(0xFF1D2428) : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryText),
        title: Row(
          children: [
            // Logo RUAS dari Asset Lokal (Pojok Kiri Atas)
            Image.asset(
              AppImage.logo,
              height: 26,
              width: 26,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.blur_on_rounded,
                  color: isSwitch ? Colors.teal[300] : const Color(0xFF0F4C43),
                  size: 26,
                );
              },
            ),
            const SizedBox(width: 8),
            Text(
              "RUAS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryText,
                fontSize: 19,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.transparent,
              // Foto Profil User dari Asset Lokal (Pojok Kanan Atas)
              backgroundImage: const AssetImage(AppImage.avatar),
            ),
          ),
        ],
      ),

      // ===========================================================================
      // 2. NAVIGASI DRAWER (Tugas Standar Arsitektur Menu Samping)
      // ===========================================================================
      drawer: Drawer(
        child: Container(
          color: backgroundColor,
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F4C43), Color(0xFF1F786B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.blur_on_rounded, color: Colors.white, size: 36),
                    SizedBox(width: 12),
                    Text(
                      "Ruang Napas",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.assignment_ind_outlined,
                  color: Color(0xFF0F4C43),
                ),
                title: Text(
                  "Pendaftaran Akun",
                  style: TextStyle(
                    color: primaryText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                tileColor: isSwitch
                    ? Colors.teal.withOpacity(0.1)
                    : const Color(0xFFE0F2F1),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),

      // ===========================================================================
      // 3. BODY UTAMA (Dibungkus ScrollView biar ga OVERFLOW)
      // ===========================================================================
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pendaftaran Akun",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Lengkapi data di bawah untuk memantau kualitas udara di sekitar Anda.",
              style: TextStyle(
                fontSize: 14,
                color: isSwitch ? Colors.white60 : Colors.black54,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 24),

            // -----------------------------------------------------------------------
            // SEKSI 1: SYARAT & KETENTUAN (Tugas 1)
            // -----------------------------------------------------------------------
            _buatKartuContainer(
              cardColor: cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buatJudulSeksi(
                    Icons.description_outlined,
                    "Syarat & Ketentuan",
                    isSwitch,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSwitch
                          ? const Color(0xFF2B343A)
                          : const Color(0xFFF2F6F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Detail Syarat & Ketentuan:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSwitch
                                ? Colors.teal[300]
                                : const Color(0xFF0F4C43),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Penggunaan Data: Data kualitas udara yang dikumpulkan akan digunakan untuk analisis lingkungan global dan lokal secara anonim.",
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryText,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Privasi Pengguna: Kami berkomitmen melindungi data pribadi Anda dan tidak akan membagikannya kepada pihak ketiga tanpa izin.",
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryText,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.grey),
                    child: CheckboxListTile(
                      title: Text(
                        "Saya menyetujui persyaratan",
                        style: TextStyle(fontSize: 13, color: secondaryText),
                      ),
                      value: isCheck,
                      activeColor: const Color(0xFF0F4C43),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) {
                        setState(() {
                          isCheck = value ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isCheck
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCheck
                              ? Icons.check_circle_outline
                              : Icons.error_outline,
                          size: 16,
                          color: isCheck ? Colors.green[700] : Colors.red[700],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isCheck
                              ? "Pendaftaran diperbolehkan"
                              : "Pendaftaran belum tersedia",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isCheck
                                ? Colors.green[700]
                                : Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // -----------------------------------------------------------------------
            // SEKSI 2: MODE TAMPILAN (Tugas 2)
            // -----------------------------------------------------------------------
            _buatKartuContainer(
              cardColor: cardColor,
              child: SwitchListTile(
                secondary: Icon(
                  Icons.dark_mode_outlined,
                  color: isSwitch ? Colors.teal[300] : const Color(0xFF0F4C43),
                ),
                title: Text(
                  "Mode Tampilan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryText,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  "Aktifkan Mode Gelap",
                  style: TextStyle(fontSize: 12, color: secondaryText),
                ),
                value: isSwitch,
                activeColor: const Color(0xFF0F4C43),
                contentPadding: EdgeInsets.zero,
                onChanged: (bool value) {
                  setState(() {
                    isSwitch = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // -----------------------------------------------------------------------
            // SEKSI 3: KATEGORI PRODUK/WILAYAH (Dropdown)
            // -----------------------------------------------------------------------
            _buatKartuContainer(
              cardColor: cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buatJudulSeksi(
                    Icons.category_outlined,
                    "Kategori Produk",
                    isSwitch,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isSwitch ? const Color(0xFF2B343A) : Colors.white,
                      border: Border.all(
                        color: isSwitch ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedDropdown,
                        hint: Text(
                          "Pilih Kategori...",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                        isExpanded: true,
                        dropdownColor: isSwitch
                            ? const Color(0xFF21282C)
                            : Colors.white,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey,
                        ),
                        style: TextStyle(color: secondaryText, fontSize: 14),
                        items: _daftarKategori.map((String val) {
                          return DropdownMenuItem(value: val, child: Text(val));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedDropdown = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 3, height: 32, color: Colors.grey[300]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedDropdown == null
                              ? "Anda belum memilih kategori"
                              : "Analisis kualitas udara untuk kategori $selectedDropdown.",
                          style: TextStyle(
                            fontSize: 13,
                            color: isSwitch ? Colors.white60 : Colors.black54,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // -----------------------------------------------------------------------
            // SEKSI 4 & 5: PENJADWALAN (Date & Time Picker)
            // -----------------------------------------------------------------------
            _buatKartuContainer(
              cardColor: cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buatJudulSeksi(
                    Icons.calendar_today_outlined,
                    "Penjadwalan",
                    isSwitch,
                  ),
                  const SizedBox(height: 14),
                  _buatTombolPicker(
                    isDark: isSwitch,
                    label: "Pilih Tanggal",
                    icon: Icons.calendar_month_outlined,
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1945),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 12),
                    child: Text(
                      "Tanggal Lahir: ${selectedDate == null ? '-- / -- / ----' : DateFormat('dd-MM-yyyy').format(selectedDate!)}",
                      style: TextStyle(fontSize: 13, color: secondaryText),
                    ),
                  ),
                  _buatTombolPicker(
                    isDark: isSwitch,
                    label: "Atur Pengingat",
                    icon: Icons.alarm_on_rounded,
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedTime = picked;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      "Pengingat diatur pukul: ${selectedTime == null ? '-- : --' : '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'}",
                      style: TextStyle(fontSize: 13, color: secondaryText),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ===========================================================================
            //  SUMMARY / HASIL KONFIGURASI
            // ===========================================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isSwitch
                    ? const Color(0xFF1E2F2C)
                    : const Color(0xFFE3F2F0),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFB2DFDB).withOpacity(0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.assignment_turned_in,
                        color: Color(0xFF00594C),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Summary / Hasil Konfigurasi",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isSwitch
                              ? Colors.teal[200]
                              : const Color(0xFF00594C),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(color: Color(0xFFB2DFDB), height: 1),
                  ),
                  // Baris data rangkuman dinamis
                  _buatBarisSummary(
                    "Izin Laporan",
                    isCheck ? "Diperbolehkan" : "Belum Tersedia",
                    isSwitch,
                  ),
                  _buatBarisSummary(
                    "Mode Layar",
                    isSwitch ? "Dark Mode" : "Light Mode",
                    isSwitch,
                  ),
                  _buatBarisSummary(
                    "Kategori Wilayah",
                    selectedDropdown ?? "Belum Dipilih",
                    isSwitch,
                  ),
                  _buatBarisSummary(
                    "Tanggal Lahir",
                    selectedDate == null
                        ? "Belum Diatur"
                        : DateFormat('dd-MM-yyyy').format(selectedDate!),
                    isSwitch,
                  ),
                  _buatBarisSummary(
                    "Waktu Pengingat",
                    selectedTime == null
                        ? "Belum Diatur"
                        : '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                    isSwitch,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ===========================================================================
            // 4. TOMBOL SIMPAN KONFIGURASI
            // ===========================================================================
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00594C).withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00594C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Simpan Konfigurasi",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ===========================================================================
      // 5. BOTTOM NAVIGATION BAR
      // ===========================================================================
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isSwitch ? Colors.transparent : Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: 3,
          selectedItemColor: const Color(0xFF00594C),
          unselectedItemColor: Colors.grey[500],
          selectedFontSize: 11,
          unselectedFontSize: 11,
          type: BottomNavigationBarType.fixed,
          backgroundColor: isSwitch ? const Color(0xFF1D2428) : Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 22),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined, size: 22),
              label: "Map",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_toggle_off, size: 22),
              label: "History",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 22),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // WIDGET HELPER METHODS
  // ===========================================================================
  Widget _buatKartuContainer({
    required Widget child,
    required Color cardColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buatJudulSeksi(IconData icon, String title, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? Colors.teal[300] : const Color(0xFF0F4C43),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }

  Widget _buatTombolPicker({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2B343A) : const Color(0xFFF0F7F6),
        border: Border.all(
          color: isDark
              ? Colors.teal.withOpacity(0.3)
              : const Color(0xFFE2EFEF),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F786B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: const Color(0xFF1F786B), size: 18),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Khusus untuk menyusun baris teks Summary kiri-kanan secara rapi
  Widget _buatBarisSummary(String label, String value, bool isDark) {
    // Memberikan warna gelap/hijau tebal pada value jika data sudah diisi/valid
    bool isDefault =
        value == "Belum Tersedia" ||
        value == "Belum Diatur" ||
        value == "Belum Dipilih";
    Color valueColor = isDefault
        ? (isDark ? Colors.grey[400]! : Colors.grey[600]!)
        : (isDark ? Colors.teal[200]! : const Color(0xFF0F4C43));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
