import 'package:flutter/material.dart';

class TentangTab extends StatefulWidget {
  final isSwitch;

  const TentangTab({super.key, required this.isSwitch});

  @override
  State<TentangTab> createState() => _TentangTabState();
}

class _TentangTabState extends State<TentangTab> {
  @override
  Widget build(BuildContext context) {
    // Color backgroundColor = isSwitch ? Color(0xFF15191C) : Color(0xFFF5F8F7);
    Color cardColor = widget.isSwitch ? const Color(0xFF21282C) : Colors.white;
    Color primaryText = widget.isSwitch
        ? Colors.teal[200]!
        : const Color(0xFF0F4C43);
    Color secondaryText = widget.isSwitch ? Colors.white70 : Colors.black87;

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
              Image.asset(
                'assets/images/logo_ruas.png',
                height: 120,
                width: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.blur_on_rounded,
                    color: widget.isSwitch
                        ? Colors.teal[300]
                        : const Color(0xFF0F4C43),
                    size: 26,
                  );
                },
              ),
              // Icon(Icons.blur_on_rounded, size: 64, color: primaryText),
              const SizedBox(height: 12),
              Column(
                children: [
                  Text(
                    "RUAS",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: primaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Ruang Napas",
                    style: TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                      color: primaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
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
                    "Alyssa Wulan Sari",
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
                    "v1.0.0",
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
