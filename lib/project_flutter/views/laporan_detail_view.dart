import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/project_flutter/database/ruas_db_helper.dart';
import 'package:latihan_flutterd7/project_flutter/models/laporan_model.dart';
import 'package:latihan_flutterd7/project_flutter/views/laporan_edit_view.dart';

class LaporanDetailView extends StatefulWidget {
  final LaporanModel laporan;
  const LaporanDetailView({super.key, required this.laporan});

  @override
  State<LaporanDetailView> createState() => _LaporanDetailViewState();
}

class _LaporanDetailViewState extends State<LaporanDetailView> {
  late LaporanModel _currentLaporan;
  String _pelaporName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentLaporan = widget.laporan;
    _loadPelapor();
  }

  Future<void> _loadPelapor() async {
    final user = await RuasDbHelper.instance.getUser(_currentLaporan.userId);
    if (user != null) {
      if (mounted) {
        setState(() {
          _pelaporName = user.nama;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _pelaporName = 'Andi Pratama';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteReport() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Laporan'),
        content: const Text('Apakah Anda yakin ingin menghapus laporan ini secara permanen dari database?'),
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
      await RuasDbHelper.instance.deleteLaporan(_currentLaporan.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Laporan berhasil dihapus'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context); // Go back to list
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.orange;
    if (_currentLaporan.status == 'Selesai') {
      statusColor = Colors.green;
    } else if (_currentLaporan.status == 'Ditolak') {
      statusColor = Colors.red;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Laporan',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF0D9488)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LaporanEditView(laporan: _currentLaporan),
                ),
              ).then((updatedReport) {
                if (updatedReport != null && updatedReport is LaporanModel) {
                  setState(() {
                    _currentLaporan = updatedReport;
                  });
                }
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF0D9488)))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Photo display header
                  Container(
                    height: 220,
                    width: double.infinity,
                    color: Colors.grey.shade100,
                    child: _currentLaporan.foto.startsWith('assets/')
                        ? Image.asset(
                            _currentLaporan.foto,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.broken_image_outlined,
                              size: 60,
                              color: Colors.grey,
                            ),
                          )
                        : const Center(
                            child: Icon(Icons.photo_outlined, size: 60, color: Colors.black26),
                          ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status badge row
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _currentLaporan.status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Title
                        Text(
                          _currentLaporan.judul,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Info cards grid
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow(Icons.category_outlined, 'Kategori', _currentLaporan.kategori),
                              const Divider(height: 16),
                              _buildInfoRow(Icons.location_on_outlined, 'Lokasi', _currentLaporan.lokasi),
                              const Divider(height: 16),
                              _buildInfoRow(Icons.calendar_today_outlined, 'Tanggal', _currentLaporan.tanggal),
                              const Divider(height: 16),
                              _buildInfoRow(Icons.person_outline, 'Pelapor', _pelaporName),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Coordinates telemetry card
                        if (_currentLaporan.koordinat.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6F5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFCCE5E1)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.gps_fixed, color: Color(0xFF0D9488), size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Telemetri GPS (Koordinat)',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F766E),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _currentLaporan.koordinat,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'monospace',
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Membuka peta eksternal...')),
                                    );
                                  },
                                  icon: const Icon(Icons.map, size: 14, color: Color(0xFF0D9488)),
                                  label: const Text(
                                    'Buka Peta',
                                    style: TextStyle(fontSize: 11, color: Color(0xFF0D9488), fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Description
                        const Text(
                          'Deskripsi Laporan',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _currentLaporan.deskripsi,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Timeline progress
                        const Text(
                          'Alur Tindak Lanjut',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTimeline(),
                        const SizedBox(height: 36),

                        // Delete button
                        ElevatedButton.icon(
                          onPressed: _deleteReport,
                          icon: const Icon(Icons.delete_outline, color: Colors.white),
                          label: const Text('Hapus Laporan', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54, size: 20),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline() {
    bool isDiproses = _currentLaporan.status == 'Diproses' || _currentLaporan.status == 'Selesai';
    bool isSelesai = _currentLaporan.status == 'Selesai';

    return Column(
      children: [
        _buildTimelineStep('Laporan Diterima', 'Laporan Anda telah berhasil masuk database lokal RUAS.', true),
        _buildTimelineLine(isDiproses),
        _buildTimelineStep('Sedang Diproses', 'Petugas sedang meninjau lokasi pelanggaran lingkungan.', isDiproses),
        _buildTimelineLine(isSelesai),
        _buildTimelineStep('Selesai Ditindak', 'Kondisi lingkungan sudah dibersihkan atau diselesaikan.', isSelesai),
      ],
    );
  }

  Widget _buildTimelineStep(String title, String desc, bool isActive) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isActive ? const Color(0xFF0D9488) : Colors.grey.shade300,
          child: Icon(
            isActive ? Icons.check : Icons.circle,
            size: isActive ? 14 : 8,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isActive ? Colors.black87 : Colors.black38,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 12,
                  color: isActive ? Colors.black54 : Colors.black38,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineLine(bool isActive) {
    return Container(
      margin: const EdgeInsets.only(left: 11, top: 2, bottom: 2),
      alignment: Alignment.centerLeft,
      child: Container(
        height: 24,
        width: 2,
        color: isActive ? const Color(0xFF0D9488) : Colors.grey.shade300,
      ),
    );
  }
}
