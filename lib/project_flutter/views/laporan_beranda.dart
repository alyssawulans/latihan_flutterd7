import 'dart:io';

import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/project_flutter/database/ruas_db_helper.dart';
import 'package:latihan_flutterd7/project_flutter/models/laporan_model.dart';
import 'package:latihan_flutterd7/project_flutter/views/buat_laporan.dart';
import 'package:latihan_flutterd7/project_flutter/views/detail_laporan.dart';
import 'package:latihan_flutterd7/project_flutter/views/riwayat_laporan.dart';

class LaporanBeranda extends StatefulWidget {
  const LaporanBeranda({super.key});

  @override
  State<LaporanBeranda> createState() => _LaporanBerandaState();
}

class _LaporanBerandaState extends State<LaporanBeranda> {
  final Color primaryTeal = const Color(0xFF0F4C43);
  final Color activeTeal = const Color(0xFF0D9488);
  final Color textDark = const Color(0xFF0F172A);

  List<LaporanModel> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() {
      _isLoading = true;
    });
    final results = await RuasDbHelper.instance.getLaporans();
    if (mounted) {
      setState(() {
        _reports = results;
        _isLoading = false;
      });
    }
  }

  // Static list of categories with assets/images or icons
  final List<Map<String, dynamic>> categories = [
    {
      "nama": "Pembuangan Sampah",
      "icon": Icons.delete_outline,
      "color": const Color(0xFF0D9488),
    },
    {
      "nama": "Pembakaran Sampah",
      "icon": Icons.local_fire_department_outlined,
      "color": const Color(0xFFEA580C),
    },
    {
      "nama": "Polusi Udara",
      "icon": Icons.cloud_outlined,
      "color": const Color(0xFF0284C7),
    },
    {
      "nama": "Limbah Cair",
      "icon": Icons.water_drop_outlined,
      "color": const Color(0xFF2563EB),
    },
    {
      "nama": "Kebisingan",
      "icon": Icons.volume_up_outlined,
      "color": const Color(0xFF7C3AED),
    },
    {
      "nama": "Lainnya",
      "icon": Icons.more_horiz_outlined,
      "color": const Color(0xFF475569),
    },
  ];

  Color getBadgeTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesay':
      case 'selesai':
        return const Color(0xFF10B981);
      case 'ditolak':
        return const Color(0xFFEF4444);
      case 'diproses':
      default:
        return const Color(0xFFF97316);
    }
  }

  Color getBadgeBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return const Color(0xFFECFDF5);
      case 'ditolak':
        return const Color(0xFFFEF2F2);
      case 'diproses':
      default:
        return const Color(0xFFFFF7ED);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Take the 3 most recent reports from SQLite
    final recentReports = _reports.take(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F8FB),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Image.asset(
            'assets/images/logo_ruas.png',
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox.shrink();
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              // decoration: const BoxDecoration(
              //   color: Colors.white,
              //   shape: BoxShape.circle,
              // ),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_none_outlined,
                  color: Color(0xFF1A2E44),
                  size: 24,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Banner Section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryTeal, activeTeal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: primaryTeal.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Laporkan masalah\nlingkungan di\nsekitar Anda",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Partisipasi Anda membantu menjaga kualitas udara dan lingkungan kita tetap sehat.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.85),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryTeal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BuatLaporan(),
                        ),
                      ).then((_) {
                        _loadReports();
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: primaryTeal, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          "Buat Laporan Baru",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Kategori Laporan Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Kategori Laporan",
                    style: TextStyle(
                      color: textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RiwayatLaporan(),
                        ),
                      ).then((_) {
                        setState(() {});
                      });
                    },
                    child: Text(
                      "Lihat Semua",
                      style: TextStyle(
                        color: activeTeal,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return GestureDetector(
                  onTap: () {
                    // Dynamic category pre-selection
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BuatLaporan(),
                      ),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[100]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.01),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: cat['color'].withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            cat['icon'],
                            color: cat['color'],
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cat['nama'],
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // 3. Laporan Terbaru Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Laporan Terbaru",
                    style: TextStyle(
                      color: textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RiwayatLaporan(),
                        ),
                      ).then((_) {
                        _loadReports();
                      });
                    },
                    child: Text(
                      "Lihat Semua",
                      style: TextStyle(
                        color: activeTeal,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),

            _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(color: Color(0xFF0D9488)),
                    ),
                  )
                : recentReports.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              Icon(Icons.assignment_outlined, size: 48, color: Colors.grey[300]),
                              const SizedBox(height: 8),
                              Text("Belum ada laporan", style: TextStyle(color: Colors.grey[400])),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: recentReports.length,
                        itemBuilder: (context, index) {
                          final item = recentReports[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey[100]!),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.01),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailLaporan(report: item),
                                    ),
                                  ).then((_) {
                                    _loadReports();
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: _buildReportImage(item.foto),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.judul,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: textDark,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item.lokasi,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: getBadgeBgColor(item.status),
                                                    borderRadius: BorderRadius.circular(
                                                      12,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    item.status,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: getBadgeTextColor(
                                                        item.status,
                                                      ),
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  item.tanggal,
                                                  style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildReportImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: 68,
        height: 68,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _errorImage(),
      );
    } else if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        width: 68,
        height: 68,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _errorImage(),
      );
    } else if (path.isNotEmpty) {
      return Image.file(
        File(path),
        width: 68,
        height: 68,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _errorImage(),
      );
    } else {
      return _errorImage();
    }
  }

  Widget _errorImage() {
    return Container(
      width: 68,
      height: 68,
      color: Colors.grey[200],
      child: const Icon(
        Icons.broken_image,
        color: Colors.grey,
      ),
    );
  }
}
