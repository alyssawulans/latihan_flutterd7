import 'package:flutter/material.dart';

class Tugas5flutter extends StatefulWidget {
  const Tugas5flutter({super.key});

  @override
  State<Tugas5flutter> createState() => _Tugas5flutterState();
}

class _Tugas5flutterState extends State<Tugas5flutter> {
  bool suka = false;
  bool showID = false;
  bool bukaPanduan = false;
  bool badgeAnggota = false;
  int pointIkut = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          pointIkut--;
          setState(() {});
        },
        backgroundColor: Colors.red,

        icon: Icon(Icons.remove_circle_outline),
        label: Text("Kurangi Poin"),
      ),
      backgroundColor: Color(0xFFF4F8FB),

      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "Ruang Napas - Profil & Komunitas",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                showID = !showID;
              });
            },
            icon: Icon(Icons.menu),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage("assets/images/profile.webp"),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Alyssa Wulan Sari",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Relawan Udara Sehat", style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // ELEVATED BUTTON (ID User)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                onPressed: () {
                  setState(() {
                    showID = !showID;
                  });
                },

                child: Text(
                  showID ? "Sembunyikan User ID" : "Tampilkan User ID",
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      showID ? "ID Anggota: RN-MEMBER-9921X" : "",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const Divider(height: 40),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dukung Gerakan Gunakan Transportasi Umum",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          suka
                              ? "Kamu menyukai program ini"
                              : "Ketuk hati untuk mendukung",
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        suka = !suka;
                      });
                    },
                    icon: Icon(Icons.favorite),
                    color: suka ? Colors.red : Colors.grey,
                  ),
                ],
              ),
              const Divider(height: 40),

              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  padding: EdgeInsets.all(3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Komunitas Ruang Napas",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            bukaPanduan = !bukaPanduan;
                          });
                        },
                        child: Text(
                          bukaPanduan
                              ? "Sembunyikan Aturan"
                              : "Baca Aturan Komunitas",
                        ),
                      ),
                      Text(
                        bukaPanduan
                            ? "1. Dilarang menyebarkan berita hoax seputar kualitas udara.\n2. Laporan wajib disertai data koordinat lokasi yang valid demi akurasi stasiun."
                            : "",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 40),

              // Membuat Badge Komunitas (INKWELL)
              Material(
                color: badgeAnggota ? Colors.amber[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  splashColor: Colors.grey,
                  onTap: () {
                    print("Kotak Berhasil Disentuh");
                    setState(() {
                      badgeAnggota = !badgeAnggota;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.0),

                    child: Row(
                      children: [
                        Icon(
                          badgeAnggota
                              ? Icons.verified
                              : Icons.verified_outlined,
                          color: badgeAnggota
                              ? Colors.amber[900]
                              : Colors.grey[600],
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            badgeAnggota
                                ? "Keanggotaan Aktif"
                                : "Ketuk untuk Aktifkan Keanggotaan Anggota",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: badgeAnggota
                                  ? Colors.amber[900]
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(height: 40),

              GestureDetector(
                onTap: () {
                  print("Ditekan Sekali");
                  setState(() {
                    pointIkut += 1;
                  });
                },
                onDoubleTap: () {
                  print("Ditekan Dua Kali");
                  setState(() {
                    pointIkut += 2;
                  });
                },
                onLongPress: () {
                  print("Tahan Lama");
                  setState(() {
                    pointIkut += 3;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 80),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.star, color: Colors.white),
                      SizedBox(height: 8),
                      Text(
                        "Ambil Poin Keanggotaan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 5),

                      Text(
                        "(Ketuk Poin Keanggotaan)",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      SizedBox(height: 15),

                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text("Poin Kamu: $pointIkut XP"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
