import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormPendaftaranTab extends StatefulWidget {
  final bool isSwitch;
  final ValueChanged<bool> onModeChanged;

  const FormPendaftaranTab({
    super.key,
    required this.isSwitch,
    required this.onModeChanged,
  });

  @override
  State<FormPendaftaranTab> createState() => _FormPendaftaranTabState();
}

class _FormPendaftaranTabState extends State<FormPendaftaranTab> {
  // STATE VARIABLES INTERNAL FORM
  bool isCheck = false;
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
    Color cardColor = widget.isSwitch ? const Color(0xFF21282C) : Colors.white;
    Color primaryText = widget.isSwitch
        ? Colors.white
        : const Color(0xFF0F4C43);
    Color secondaryText = widget.isSwitch ? Colors.white70 : Colors.black87;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
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
          const SizedBox(height: 6),
          Text(
            "Lengkapi data di bawah untuk memantau kualitas udara di sekitar Anda.",
            style: TextStyle(
              fontSize: 14,
              color: widget.isSwitch ? Colors.white60 : Colors.black54,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 24),

          // SEKSI 1: SYARAT & KETENTUAN
          _buatKartuContainer(
            cardColor: cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buatJudulSeksi(
                  Icons.description_outlined,
                  "Syarat & Ketentuan",
                  widget.isSwitch,
                ),
                const SizedBox(height: 12),
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.grey),
                  child: CheckboxListTile(
                    title: Text(
                      "Saya menyetujui persyaratan penggunaan data.",
                      style: TextStyle(fontSize: 13, color: secondaryText),
                    ),
                    value: isCheck,
                    activeColor: const Color(0xFF0F4C43),
                    contentPadding: EdgeInsets.zero,
                    onChanged: (bool? value) {
                      setState(() {
                        isCheck = value ?? false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // SEKSI 2: MODE TAMPILAN
          _buatKartuContainer(
            cardColor: cardColor,
            child: SwitchListTile(
              secondary: Icon(
                Icons.dark_mode_outlined,
                color: widget.isSwitch
                    ? Colors.teal[300]
                    : const Color(0xFF0F4C43),
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
              value: widget.isSwitch,
              activeColor: const Color(0xFF0F4C43),
              contentPadding: EdgeInsets.zero,
              onChanged: widget.onModeChanged, // Lempar ke parent (main.dart)
            ),
          ),
          const SizedBox(height: 16),

          // SEKSI 3: KATEGORI WILAYAH (DROPDOWN)
          _buatKartuContainer(
            cardColor: cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buatJudulSeksi(
                  Icons.category_outlined,
                  "Kategori Produk",
                  widget.isSwitch,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: widget.isSwitch
                        ? const Color(0xFF2B343A)
                        : Colors.white,
                    border: Border.all(
                      color: widget.isSwitch
                          ? Colors.grey[700]!
                          : Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedDropdown,
                      hint: Text(
                        "Pilih Kategori...",
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                      isExpanded: true,
                      dropdownColor: widget.isSwitch
                          ? const Color(0xFF21282C)
                          : Colors.white,
                      style: TextStyle(color: secondaryText, fontSize: 14),
                      items: _daftarKategori
                          .map(
                            (String val) =>
                                DropdownMenuItem(value: val, child: Text(val)),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedDropdown = value),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // SEKSI 4 & 5: PENJADWALAN
          _buatKartuContainer(
            cardColor: cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buatJudulSeksi(
                  Icons.calendar_today_outlined,
                  "Penjadwalan",
                  widget.isSwitch,
                ),
                const SizedBox(height: 14),
                _buatTombolPicker(
                  label: "Pilih Tanggal",
                  icon: Icons.calendar_month_outlined,
                  isDark: widget.isSwitch,
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1945),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => selectedDate = picked);
                  },
                ),
                Text(
                  "Tanggal Lahir: ${selectedDate == null ? '--/--/----' : DateFormat('dd-MM-yyyy').format(selectedDate!)}",
                  style: TextStyle(fontSize: 13, color: secondaryText),
                ),
                const SizedBox(height: 12),
                _buatTombolPicker(
                  label: "Atur Pengingat",
                  icon: Icons.alarm_on_rounded,
                  isDark: widget.isSwitch,
                  onPressed: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) setState(() => selectedTime = picked);
                  },
                ),
                Text(
                  "Pengingat: ${selectedTime == null ? '--:--' : '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'}",
                  style: TextStyle(fontSize: 13, color: secondaryText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // SEKSI RANGKUMAN (SUMMARY)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: widget.isSwitch
                  ? const Color(0xFF1E2F2C)
                  : const Color(0xFFE3F2F0),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _buatBarisSummary(
                  "Izin Laporan",
                  isCheck ? "Diperbolehkan" : "Belum Tersedia",
                  widget.isSwitch,
                ),
                _buatBarisSummary(
                  "Mode Layar",
                  widget.isSwitch ? "Dark Mode" : "Light Mode",
                  widget.isSwitch,
                ),
                _buatBarisSummary(
                  "Kategori Wilayah",
                  selectedDropdown ?? "Belum Dipilih",
                  widget.isSwitch,
                ),
                _buatBarisSummary(
                  "Tanggal Lahir",
                  selectedDate == null
                      ? "Belum Diatur"
                      : DateFormat('dd-MM-yyyy').format(selectedDate!),
                  widget.isSwitch,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET HELPERS
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
      margin: const EdgeInsets.only(bottom: 4),
      width: double.infinity,
      height: 40,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label),
      ),
    );
  }

  Widget _buatBarisSummary(String label, String value, bool isDark) {
    return Row(
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
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
