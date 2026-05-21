import 'package:flutter/material.dart';

class TentangTab extends StatelessWidget {
  final bool isSwitch;

  const TentangTab({super.key, required this.isSwitch});

  @override
  Widget build(BuildContext context) {
    Color cardColor = isSwitch ? const Color(0xFF21282C) : Colors.white;
    Color primaryText = isSwitch ? Colors.teal[200]! : const Color(0xFF0F4C43);
    Color secondaryText = isSwitch ? Colors.white70 : Colors.black87;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.blur_on_rounded, size: 64, color: primaryText),
              const SizedBox(height: 12),
              Text(
                "RUAS (Ruang Napas)",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Aplikasi pemantauan kualitas udara modern untuk menganalisis tingkat kebersihan udara di berbagai stasiun pemantauan wilayah secara real-time.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: secondaryText,
                  height: 1.4,
                ),
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Nama Pembuat"),
                  Text(
                    "Siswa PPKD B6",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Versi"),
                  Text(
                    "v1.0.0 (Tugas 8)",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
