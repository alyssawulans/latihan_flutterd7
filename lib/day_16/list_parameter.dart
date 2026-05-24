import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/day_16/ruas_data.dart'; // Import file data kita tadi

class ListParameterDay16 extends StatefulWidget {
  const ListParameterDay16({super.key});

  @override
  State<ListParameterDay16> createState() => _ListParameterDay16State();
}

class _ListParameterDay16State extends State<ListParameterDay16> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F7), // Vibe aesthetic RUAS
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: namaParameterList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: ListTile(
              title: Text(
                namaParameterList[index], // Memanggil List<String> murni
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
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
      ),
    );
  }
}
