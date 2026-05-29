import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/button_navi.dart';
import 'package:latihan_flutterd7/extension/navigator.dart';

class HalamanKonfirmasi extends StatelessWidget {
  final String namaLengkap;
  final String alamat;

  const HalamanKonfirmasi({
    super.key,
    required this.namaLengkap,
    required this.alamat,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1A2E44);
    return Scaffold(
      backgroundColor: Color(0xFFF5F8F7),
      appBar: AppBar(
        backgroundColor: Color(0xFFF4F8FB),
        elevation: 0,
        title: Text(
          "Pendaftaran Berhasil",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_box, color: Colors.teal, size: 90),
                SizedBox(height: 24),

                Text(
                  "Terima Kasih, $namaLengkap \ndari $alamat telah mendaftar.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 12),

                Text(
                  "Akun Anda telah tersimpan dengan aman di sistem pemantauan RUAS.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),

                SizedBox(height: 40),

                SizedBox(
                  width: 150,
                  height: 46,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.teal, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();

                      context.pushAndRemoveAll(Bottomnavi());
                    },
                    child: Text(
                      "Selesai",
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
