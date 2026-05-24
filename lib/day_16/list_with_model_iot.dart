import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/day_16/ruas_data.dart';
import 'package:latihan_flutterd7/day_16/ruas_models.dart';

class ListWithModelIotDay16 extends StatefulWidget {
  const ListWithModelIotDay16({super.key});

  @override
  State<ListWithModelIotDay16> createState() => _ListWithModelIotDay16State();
}

class _ListWithModelIotDay16State extends State<ListWithModelIotDay16> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F7),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: alatRuasWithModel.length,
        itemBuilder: (BuildContext context, int index) {
          // Memanggil custom widget ItemProduk dengan melempar data objek model
          return ItemProduk(produk: alatRuasWithModel[index]);
        },
      ),
    );
  }
}

// --- CUSTOM WIDGET MANDIRI LEVEL 3 (Wajib menyertakan Gambar & Deskripsi) ---
class ItemProduk extends StatelessWidget {
  final RuasModel produk;
  const ItemProduk({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Penampil Gambar (Wajib Gambar)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                produk.pathGambar,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 70,
                  height: 70,
                  color: const Color(0xFFE0F2F1),
                  child: const Icon(
                    Icons.developer_board,
                    color: Color(0xFF0F4C43),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Penampil Konten (Wajib Deskripsi)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF0F4C43),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    produk.deskripsi, // Menampilkan deskripsi objek model
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
