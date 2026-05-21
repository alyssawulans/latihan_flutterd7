import 'package:flutter/material.dart';

class InputInteraktifScreen extends StatefulWidget {
  const InputInteraktifScreen({super.key});

  @override
  State<InputInteraktifScreen> createState() => _InputInteraktifScreenState();
}

class _InputInteraktifScreenState extends State<InputInteraktifScreen> {
  // ==========================================
  // STATE VARIABLES (PENGELOLA DATA INPUT)
  // ==========================================
  bool _setujuSyarat = false;
  bool _isDarkMode = false;

  // Mengubah data kategori agar masuk akal di aplikasi RUAS
  String _kategoriTerpilih = "Pemukiman";
  final List<String> _daftarKategori = [
    "Pemukiman",
    "Kawasan Industri",
    "Hutan & Taman",
    "Lainnya",
  ];

  String _tanggalLahirText = "Belum Diatur";
  String _waktuPengingatText = "Belum Diatur";

  // ==========================================
  // LOGIKA FUNGSI PICKER (DATE & TIME)
  // ==========================================
  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1945),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Colors.teal[700]!),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _tanggalLahirText =
            "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      });
    }
  }

  Future<void> _pilihWaktu(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Colors.teal[700]!),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _waktuPengingatText =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode
          ? const Color(0xFF1E272E)
          : const Color(0xFFF4F7F6),

      // 1. APP BAR
      appBar: AppBar(
        title: const Text(
          "RUAS - Input Interaktif",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      // 2. NAVIGASI DRAWER
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[700]!, Colors.teal[900]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.blur_on_rounded, color: Colors.white, size: 40),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Ruang Napas",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Menu Fitur Interaktif",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.file_copy_outlined, color: Colors.teal[700]),
              title: const Text("Form Input Fitur"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.home_outlined, color: Colors.teal[700]),
              title: const Text("Kembali ke Beranda"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),

      // 3. BODY UTAMA DENGAN FORM INPUT
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Konfigurasi Pemantauan RUAS",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.teal[900],
              ),
            ),
            const SizedBox(height: 20),

            // KARTU 1: SYARAT & KETENTUAN (CHECKBOX)
            _buatKartuContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "1. Syarat & Ketentuan Relawan",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  CheckboxListTile(
                    title: const Text(
                      "Saya menyetujui persyaratan pelaporan data",
                      style: TextStyle(fontSize: 14),
                    ),
                    activeColor: Colors.teal[700],
                    contentPadding: EdgeInsets.zero,
                    value: _setujuSyarat,
                    onChanged: (bool? value) {
                      setState(() {
                        _setujuSyarat = value ?? false;
                      });
                    },
                  ),
                  Text(
                    _setujuSyarat
                        ? "✓ Pendaftaran diperbolehkan"
                        : "✗ Pendaftaran belum tersedia",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _setujuSyarat
                          ? Colors.green[700]
                          : Colors.red[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // KARTU 2: MODE TAMPILAN (SWITCH)
            _buatKartuContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "2. Mode Tampilan",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SwitchListTile(
                    title: const Text(
                      "Aktifkan Mode Gelap (Eco Dark)",
                      style: TextStyle(fontSize: 14),
                    ),
                    activeThumbColor: Colors.teal[700],
                    contentPadding: EdgeInsets.zero,
                    value: _isDarkMode,
                    onChanged: (bool value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // KARTU 3: KATEGORI WILAYAH (DROPDOWNBUTTON - SUDAH RELEVAN DENGAN RUAS)
            _buatKartuContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "3. Kategori Wilayah Stasiun",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _kategoriTerpilih,
                        isExpanded: true,
                        items: _daftarKategori.map((String kategori) {
                          return DropdownMenuItem<String>(
                            value: kategori,
                            child: Text(kategori),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _kategoriTerpilih = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Anda memilih kategori: $_kategoriTerpilih",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // KARTU 4 & 5: PICKERS (TANGGAL & WAKTU ALARM)
            Row(
              children: [
                Expanded(
                  child: _buatKartuContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "4. Pilih Tanggal",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.calendar_month, size: 16),
                          onPressed: () => _pilihTanggal(context),
                          label: const Text(
                            "Buka Kalender",
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buatKartuContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "5. Atur Pengingat",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.access_time_filled, size: 16),
                          onPressed: () => _pilihWaktu(context),
                          label: const Text(
                            "Atur Waktu",
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ==========================================
            // RESULT AREA (RINGKASAN STATUS DI BAWAH)
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal[200]!, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.assignment_turned_in_rounded,
                        color: Colors.teal[800],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Summary / Hasil Konfigurasi",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.teal, thickness: 1, height: 20),
                  _buatBarisSummary(
                    "Izin Laporan",
                    _setujuSyarat ? "Diperbolehkan" : "Belum Tersedia",
                  ),
                  _buatBarisSummary(
                    "Mode Layar",
                    _isDarkMode ? "Dark Mode Aktif" : "Light Mode",
                  ),
                  _buatBarisSummary("Kategori Wilayah", _kategoriTerpilih),
                  _buatBarisSummary("Tanggal Lahir", _tanggalLahirText),
                  _buatBarisSummary("Waktu Pengingat", _waktuPengingatText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buatKartuContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buatBarisSummary(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.teal[900],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
