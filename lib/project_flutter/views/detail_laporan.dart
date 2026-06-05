import 'dart:io';

import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/project_flutter/database/ruas_db_helper.dart';
import 'package:latihan_flutterd7/project_flutter/models/laporan_model.dart';
import 'package:latihan_flutterd7/project_flutter/views/laporan_edit_view.dart';
import 'package:latihan_flutterd7/project_flutter/views/riwayat_laporan.dart';

class DetailLaporan extends StatefulWidget {
  final LaporanModel report;
  const DetailLaporan({super.key, required this.report});

  @override
  State<DetailLaporan> createState() => _DetailLaporanState();
}

class _DetailLaporanState extends State<DetailLaporan> {
  final Color primaryTeal = const Color(0xFF0F4C43);
  final Color activeTeal = const Color(0xFF0D9488);
  final Color textDark = const Color(0xFF0F172A);

  late LaporanModel _currentReport;

  @override
  void initState() {
    super.initState();
    _currentReport = widget.report;
  }

  // Getters to act as wrapper mapping LaporanModel to the UI fields
  String get title => _currentReport.judul;
  String get status => _currentReport.status;
  String get category => _currentReport.kategori;
  String get description => _currentReport.deskripsi;
  String get lokasi => _currentReport.lokasi;
  String get koordinat => _currentReport.koordinat;
  String get imageUrl => _currentReport.foto;
  List<String> get imageUrls => [_currentReport.foto];

  String get detailStatusTitle => _currentReport.status;

  String get detailStatusDesc {
    if (_currentReport.status == 'Selesai') {
      return "Laporan telah selesai ditindaklanjuti oleh petugas kebersihan setempat.";
    } else if (_currentReport.status == 'Ditolak') {
      return "Laporan ditolak karena informasi lokasi kurang jelas atau foto tidak relevan.";
    } else {
      return "Laporan Anda sedang kami verifikasi dan teruskan ke pihak terkait.";
    }
  }

  String get detailStatusTime {
    if (_currentReport.status == 'Selesai') {
      return "${_currentReport.tanggal}, 14:30";
    } else if (_currentReport.status == 'Ditolak') {
      return "${_currentReport.tanggal}, 16:00";
    } else {
      return "${_currentReport.tanggal}, 10:15";
    }
  }

  List<Map<String, String>> get timeline {
    if (_currentReport.status == 'Selesai') {
      return [
        {'title': 'Laporan dibuat', 'waktu': '${_currentReport.tanggal}, 09:00'},
        {'title': 'Sedang diproses', 'waktu': '${_currentReport.tanggal}, 10:00'},
        {'title': 'Laporan selesai', 'waktu': '${_currentReport.tanggal}, 14:30'},
      ];
    } else if (_currentReport.status == 'Ditolak') {
      return [
        {'title': 'Laporan dibuat', 'waktu': '${_currentReport.tanggal}, 13:00'},
        {'title': 'Laporan ditolak', 'waktu': '${_currentReport.tanggal}, 16:00'},
      ];
    } else {
      return [
        {'title': 'Laporan dibuat', 'waktu': '${_currentReport.tanggal}, 09:41'},
        {'title': 'Sedang diproses', 'waktu': '${_currentReport.tanggal}, 10:15'},
      ];
    }
  }

  Future<void> _deleteReport() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Laporan'),
        content: const Text('Apakah Anda yakin ingin menghapus laporan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.black54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await RuasDbHelper.instance.deleteLaporan(_currentReport.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Laporan berhasil dihapus'), backgroundColor: Colors.red),
        );
        Navigator.pop(context); // Go back
      }
    }
  }

  Color getStatusColor(String status) {
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

  Color getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return const Color(0xFFECFDF5);
      case 'ditolak':
        return const Color(0xFFFEF2F2);
      case 'diproses':
      default:
        return const Color(0xFFFFFBEB);
    }
  }

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return Icons.check_circle_outline;
      case 'ditolak':
        return Icons.cancel_outlined;
      case 'diproses':
      default:
        return Icons.access_time_rounded;
    }
  }

  void _showFullScreenImage(String url) {
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (context) => Stack(
        children: [
          Center(
            child: InteractiveViewer(
              child: url.startsWith('http')
                  ? Image.network(
                      url,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 64,
                      ),
                    )
                  : Image.file(
                      File(url),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final report = this;
    final statusColor = getStatusColor(_currentReport.status);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryTeal),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Detail Laporan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryTeal,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: activeTeal),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LaporanEditView(laporan: _currentReport),
                ),
              ).then((updated) {
                if (updated != null && updated is LaporanModel) {
                  setState(() {
                    _currentReport = updated;
                  });
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _deleteReport,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Status Laporan Card
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: getStatusBgColor(report.status),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: statusColor.withOpacity(0.2),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Status Laporan",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          getStatusIcon(report.status),
                          color: statusColor,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          report.detailStatusTitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report.detailStatusDesc,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      report.detailStatusTime,
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. Informasi Laporan
              Text(
                "Informasi Laporan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Large Photo Header
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16.0),
                      ),
                      child: report.imageUrl.startsWith('http')
                          ? Image.network(
                              report.imageUrl,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: 180,
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                  ),
                            )
                          : Image.file(
                              File(report.imageUrl),
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: 180,
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            report.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Category Row
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0FDFA),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.assignment,
                                  size: 18,
                                  color: activeTeal,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Kategori",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    Text(
                                      report.category,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: textDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Location Row
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0FDFA),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.location_on,
                                  size: 18,
                                  color: activeTeal,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Lokasi",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    Text(
                                      report.lokasi,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: textDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Description
                          Text(
                            "Deskripsi",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            report.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. Foto Bukti Row
              Text(
                "Foto Bukti",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: report.imageUrls.length,
                  itemBuilder: (context, index) {
                    final imgUrl = report.imageUrls[index];
                    return GestureDetector(
                      onTap: () => _showFullScreenImage(imgUrl),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: imgUrl.startsWith('http')
                              ? Image.network(
                                  imgUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                      ),
                                )
                              : Image.file(
                                  File(imgUrl),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                      ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // 4. Riwayat Status Timeline
              Text(
                "Riwayat Status",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(report.timeline.length, (index) {
                    final step = report.timeline[index];
                    final isLast = index == report.timeline.length - 1;
                    return IntrinsicHeight(
                      child: Row(
                        children: [
                          // Step indicator line & circle
                          Column(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: activeTeal,
                                ),
                              ),
                              if (!isLast)
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    color: activeTeal.withOpacity(0.3),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          // Step details
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    step['title'] ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: textDark,
                                    ),
                                  ),
                                  Text(
                                    step['waktu'] ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
