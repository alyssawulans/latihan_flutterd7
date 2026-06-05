import 'dart:io';
import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/project_flutter/database/ruas_db_helper.dart';
import 'package:latihan_flutterd7/project_flutter/models/laporan_model.dart';
import 'package:latihan_flutterd7/project_flutter/views/detail_laporan.dart';
import 'package:latihan_flutterd7/project_flutter/views/laporan_beranda.dart';

// Keep a stub ReportItem and ReportStorage for backwards compatibility if needed, but we will use LaporanModel
class ReportItem {
  final String title;
  final String date;
  final String status;
  final List<String> imageUrls;
  final String category;
  final String description;
  final String lokasi;
  final String koordinat;
  final String detailStatusTitle;
  final String detailStatusDesc;
  final String detailStatusTime;
  final List<Map<String, String>> timeline;

  ReportItem({
    required this.title,
    required this.date,
    required this.status,
    required this.imageUrls,
    required this.category,
    required this.description,
    required this.lokasi,
    required this.koordinat,
    required this.detailStatusTitle,
    required this.detailStatusDesc,
    required this.detailStatusTime,
    required this.timeline,
  });

  String get imageUrl => imageUrls.isNotEmpty ? imageUrls.first : "";
}

class ReportStorage {
  static final List<ReportItem> reports = [];
}

class RiwayatLaporan extends StatefulWidget {
  const RiwayatLaporan({super.key});

  @override
  State<RiwayatLaporan> createState() => _RiwayatLaporanState();
}

class _RiwayatLaporanState extends State<RiwayatLaporan> {
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
  // Colors based on premium design system
  final Color primaryTeal = const Color(0xFF0F4C43);
  final Color activeTeal = const Color(0xFF0D9488);
  final Color textDark = const Color(0xFF0F172A);

  Color getBadgeTextColor(String status) {
    switch (status.toLowerCase()) {
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

  Color getBadgeBorderColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return const Color(0xFFA7F3D0);
      case 'ditolak':
        return const Color(0xFFFECACA);
      case 'diproses':
      default:
        return const Color(0xFFFED7AA);
    }
  }

  Widget _buildReportList(String filterStatus) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF0D9488)));
    }

    final filteredList = _reports.where((item) {
      if (filterStatus == 'Semua') return true;
      return item.status.toLowerCase() == filterStatus.toLowerCase();
    }).toList();

    if (filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_turned_in_outlined,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 12),
            Text(
              "Belum ada laporan status $filterStatus",
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final item = filteredList[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
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
                    // Report Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildItemImage(item.foto),
                    ),
                    const SizedBox(width: 16),
                    // Title and Date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.judul,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textDark,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.tanggal,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Chevron and Status Badge
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey[400],
                          size: 18,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: getBadgeBgColor(item.status),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: getBadgeBorderColor(item.status),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            item.status,
                            style: TextStyle(
                              color: getBadgeTextColor(item.status),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _errorImage(),
      );
    } else if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _errorImage(),
      );
    } else if (path.isNotEmpty) {
      return Image.file(
        File(path),
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _errorImage(),
      );
    } else {
      return _errorImage();
    }
  }

  Widget _errorImage() {
    return Container(
      width: 72,
      height: 72,
      color: Colors.grey[100],
      child: const Icon(
        Icons.broken_image,
        color: Colors.grey,
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC), // Modern off-white background
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: primaryTeal),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                // If we can't pop, go back to LaporanBeranda
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LaporanBeranda(),
                  ),
                );
              }
            },
          ),
          title: Text(
            'Riwayat Laporan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryTeal,
              fontSize: 20,
            ),
          ),
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: primaryTeal,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3.0,
            labelColor: primaryTeal,
            unselectedLabelColor: Colors.grey[400],
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            tabs: const [
              Tab(text: 'Semua'),
              Tab(text: 'Diproses'),
              Tab(text: 'Selesai'),
              Tab(text: 'Ditolak'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildReportList('Semua'),
            _buildReportList('Diproses'),
            _buildReportList('Selesai'),
            _buildReportList('Ditolak'),
          ],
        ),
      ),
    );
  }
}
