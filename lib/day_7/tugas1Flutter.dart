import 'package:flutter/material.dart';

class Tugas1flutter extends StatelessWidget {
  const Tugas1flutter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Saya"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 158, 30, 21),
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),

      // Agar tidak menepi layar
      body: Padding(
        padding: const EdgeInsets.all(20.5),
        child: Column(
          //Membuat posisi jadi ke tengah semua
          crossAxisAlignment: CrossAxisAlignment.center,

          // Membuat elemen Nama
          children: [
            Text(
              "Nama: Alyssa Wulan Sari",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),

            //Membuat elemen Lokasi
            Row(
              // memakai row karena ada dua baris yaitu untuk ikon dan tulisan "Jakarta"
              mainAxisAlignment: MainAxisAlignment
                  .center, //main digunakan karena ada ikon dan teks
              children: [
                // children dipakai kembali karena ikon dan tulisan (baris)
                Icon(Icons.location_on, color: Colors.red),
                Text(
                  "Jakarta Timur",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),

            //const SizedBox(height: 15), //tambahan jarak sebelum baris selanjutnya
            //penggunaan const untuk nilai yang permanen (tidak berubah2)
            // (misal: nama yang (bukan) diambil dari database/input user)

            //Membuat Deskripsi Informasi
            Text(
              "Seorang peserta pelatihan yang sedang mendalami Flutter di PPKD, semoga bisa selesai dan mengikuti sampai akhir dan membuat suatu aplikasi kualitas udara.",
              style: TextStyle(
                fontSize: 15,
                color: const Color.fromARGB(255, 244, 139, 54),
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
