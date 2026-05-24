import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/day_16/ruas_data.dart';

class MapStasiunDay16 extends StatefulWidget {
  const MapStasiunDay16({super.key});

  @override
  State<MapStasiunDay16> createState() => _MapStasiunDay16State();
}

class _MapStasiunDay16State extends State<MapStasiunDay16> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F7),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: stasiunList.length,
        itemBuilder: (BuildContext context, int index) {
          final data = stasiunList[index]; // Membaca Map dari List

          return Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F2F1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  data["ikon"],
                  color: const Color(0xFF0F4C43),
                  size: 20,
                ), // Ikon pendukung relevan
              ),
              title: Text(
                data["nama"], // Nama stasiun regional
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
