import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latihan_flutterd7/day_13/welcome_screen.dart';
import 'package:latihan_flutterd7/extension/navigator.dart';

class Tugas7flutter1 extends StatefulWidget {
  const Tugas7flutter1({super.key});

  @override
  State<Tugas7flutter1> createState() => _Tugas7flutter1State();
}

class AppImage {
  static const String logo = 'assets/images/logo_ruas.png';
  static const String avatar = 'assets/images/profile.webp';
}

class _Tugas7flutter1State extends State<Tugas7flutter1> {
  bool isCheck = false;
  bool isSwitch = false;
  String? selectedDropdown;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final List<String> _daftarKategori = [
    "Pemukiman",
    "Kawasan Industri",
    "Hutan & Taman",
    "Lainnya",
  ];

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isSwitch ? Color(0xFF15191C) : Color(0xFFF5F8F7);
    Color cardColor = isSwitch ? const Color(0xFF21282C) : Colors.white;
    Color primaryText = isSwitch ? Colors.white : const Color(0xFF0F4C43);
    Color secondaryText = isSwitch ? Colors.white70 : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,

      // ======== APPBAR MENU ===========
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
            SizedBox(width: 8),
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

      // ---- Membuat Drawer --
      drawer: Drawer(
        // child: Container(
        //   color: backgroundColor,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0F4C43), Color(0xFF1F786B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          AppImage.logo,
                          height: 80,
                          width: 80,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.blur_on_rounded,
                              color: isSwitch
                                  ? Colors.teal[300]
                                  : const Color(0xFF0F4C43),
                              size: 80,
                            );
                          },
                        ),

                        SizedBox(width: 12),
                        Text(
                          "Ruang\nNapas",
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

            ListTile(
              leading: const Icon(
                Icons.assignment_ind_outlined,
                color: Color(0xFF0F4C43),
              ),
              title: Text(
                "Log Out",
                style: TextStyle(
                  color: primaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              tileColor: isSwitch
                  ? Colors.teal.withOpacity(0.1)
                  : const Color(0xFFE0F2F1),
              onTap: () => context.pushReplacement(const WelcomeScreen()),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pendaftaran Akun RUAS",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),
            SizedBox(height: 6),

            Text(
              "Lengkapi data di bawah untuk memantau kualitas udara di sekitar Anda.",
              style: TextStyle(
                fontSize: 14,
                color: isSwitch ? Colors.white60 : Colors.black54,
                height: 1.3,
              ),
            ),

            SizedBox(height: 24),

            //SYARAT KETENTUAN
            _buatKartuContainer(
              cardColor: cardColor,
              child: Column(
                children: [
                  _buatJudul(
                    Icons.description_outlined,
                    "Syarat dan Ketentuan",
                    isSwitch,
                  ),
                  SizedBox(height: 12),

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
                  SizedBox(height: 8),
                  Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.grey),
                    child: CheckboxListTile(
                      title: Text(
                        "Saya menyetujui Persyaratan",
                        style: TextStyle(fontSize: 13, color: secondaryText),
                      ),
                      value: isCheck,
                      activeColor: Color(0xFF0F4C43),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,

                      onChanged: (bool? value) {
                        setState(() {
                          isCheck = value ?? false;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isCheck ? Color(0xFFE8F5E9) : Color(0xFFFFEBEE),
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
                        SizedBox(width: 8),
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
            SizedBox(height: 16),

            // Membuat Tampilan Mode Terang dan Gelap
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
                activeThumbColor: Color(0xFF0F4C43),
                contentPadding: EdgeInsets.zero,

                onChanged: (bool value) {
                  setState(() {
                    isSwitch = value;
                  });
                },
              ),
            ),
            SizedBox(height: 16),

            // Membuat Dropdown Kategori
            _buatKartuContainer(
              cardColor: cardColor,
              child: Column(
                children: [
                  _buatJudul(Icons.category_outlined, "Kategori", isSwitch),

                  SizedBox(height: 12),
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
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 3, height: 32, color: Colors.green[300]),
                      SizedBox(width: 8),
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
            SizedBox(height: 16),

            // Membuat Jadwal (Date dan Time picker)
            _buatKartuContainer(
              cardColor: cardColor,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buatJudul(
                    Icons.calendar_today_outlined,
                    "PenJadwalan",
                    isSwitch,
                  ),
                  SizedBox(height: 14),
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

            //Membuat Hasil Konfigurasi
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isSwitch ? Color(0xFF1E2F2C) : Color(0xFFE3F2F0),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Color(0xFFB2DFDB).withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.assignment_turned_in,
                        color: Color(0xFF00594C),
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Summary/Hasil Konfigurasi",
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
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(color: Color(0xFFB2DFDB), height: 1),
                  ),

                  //Membuat Baris Rangkuman
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
            SizedBox(height: 24),

            // Simpan Konfigurasi
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
      // Membuat Bottom Navigation Bar
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     border: Border(
      //       top: BorderSide(
      //         color: isSwitch ? Colors.transparent : Colors.grey[200]!,
      //         width: 1,
      //       ),
      //     ),
      //   ),
      //   child: BottomNavigationBar(
      //     currentIndex: 0,
      //     selectedItemColor: const Color(0xFF00594C),
      //     unselectedItemColor: Colors.grey[500],
      //     selectedFontSize: 11,
      //     unselectedFontSize: 11,
      //     type: BottomNavigationBarType.fixed,
      //     backgroundColor: isSwitch ? const Color(0xFF1D2428) : Colors.white,
      //     items: const [
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.home_outlined, size: 22),
      //         label: "Home",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.info_outline, size: 22),
      //         label: "Info Aplikasi",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.map_outlined, size: 22),
      //         label: "Map",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.history_toggle_off, size: 22),
      //         label: "History",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.person, size: 22),
      //         label: "Profile",
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

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

  Widget _buatJudul(IconData icon, String title, bool isDark) {
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
        color: isDark ? Color(0xFF2B343A) : const Color(0xFFF0F7F6),
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
