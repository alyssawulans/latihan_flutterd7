import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/project_flutter/database/ruas_db_helper.dart';
import 'package:latihan_flutterd7/project_flutter/models/laporan_model.dart';
import 'package:latihan_flutterd7/project_flutter/views/detail_laporan.dart';
import 'package:latihan_flutterd7/project_flutter/views/main_navigation_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _userName = 'Andi Pratama';
  int _laporanCount = 0;
  int _edukasiCount = 0;
  List<LaporanModel> _recentLaporan = [];
  bool _isLoading = true;

  final Color primaryTeal = const Color(0xFF0F4C43);
  final Color activeTeal = const Color(0xFF0D9488);
  final Color textDark = const Color(0xFF0F172A);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('current_user_name') ?? 'Andi Pratama';

    // Get statistics
    final lCount = await RuasDbHelper.instance.getLaporanCount();
    final eCount = await RuasDbHelper.instance.getEdukasiCount();

    // Get recent reports
    final allReports = await RuasDbHelper.instance.getLaporans();
    final recent = allReports.take(3).toList();

    if (mounted) {
      setState(() {
        _userName = name;
        _laporanCount = lCount;
        _edukasiCount = eCount;
        _recentLaporan = recent;
        _isLoading = false;
      });
    }
  }

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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF0D9488)),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              color: activeTeal,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Curved Header Gradient
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryTeal, activeTeal],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(32),
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        top: 54,
                        left: 24,
                        right: 24,
                        bottom: 48,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hai, $_userName 👋',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Mari jaga lingkungan kita tetap bersih & asri!',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.notifications_none_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Sub Location Indicator inside header
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white.withOpacity(0.9),
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Cibadak, Sukabumi • 24 Sep 2023',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // 2. Floating AQI Panel Card
                    Transform.translate(
                      offset: const Offset(0, -28),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Circular Progress Gauge
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 68,
                                      height: 68,
                                      child: CircularProgressIndicator(
                                        value: 32 / 100,
                                        strokeWidth: 6.5,
                                        backgroundColor: Colors.grey[100],
                                        color: const Color(0xFF10B981),
                                      ),
                                    ),
                                    const Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '32',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1A2E44),
                                          ),
                                        ),
                                        Text(
                                          'AQI',
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                // Text stats
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFECFDF5),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Text(
                                              'Kualitas Baik',
                                              style: TextStyle(
                                                color: Color(0xFF10B981),
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      const Text(
                                        'Udara sangat sehat untuk dinikmati di luar ruangan.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF475569),
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            const SizedBox(height: 16),
                            // Metrics details row grid
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildMiniParam(
                                  Icons.eco_outlined,
                                  'PM2.5',
                                  '12 µg/m³',
                                ),
                                _buildMiniParam(
                                  Icons.thermostat,
                                  'Suhu',
                                  '28°C',
                                ),
                                _buildMiniParam(
                                  Icons.water_drop_outlined,
                                  'Lembab',
                                  '65%',
                                ),
                                _buildMiniParam(
                                  Icons.air,
                                  'Ozon (O³)',
                                  '0.02 ppm',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 3. Quick Stats Cards Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Menu Layanan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),

                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.45,
                            children: [
                              _buildRedesignedStatCard(
                                title: 'Laporan Saya',
                                value: '$_laporanCount',
                                desc: 'Ajuan laporan Anda',
                                icon: Icons.description_outlined,
                                color: const Color(0xFFFFF7ED),
                                iconColor: const Color(0xFFEA580C),
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MainNavigationShell(
                                            initialTab: 2,
                                          ),
                                    ),
                                    (route) => false,
                                  );
                                },
                              ),
                              _buildRedesignedStatCard(
                                title: 'Edukasi',
                                value: '$_edukasiCount',
                                desc: 'Artikel kebersihan',
                                icon: Icons.menu_book_outlined,
                                color: const Color(0xFFEFF6F5),
                                iconColor: activeTeal,
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MainNavigationShell(
                                            initialTab: 3,
                                          ),
                                    ),
                                    (route) => false,
                                  );
                                },
                              ),
                              _buildRedesignedStatCard(
                                title: 'Peta Lokasi',
                                value: '6',
                                desc: 'Titik pantau AQI',
                                icon: Icons.map_outlined,
                                color: const Color(0xFFEFF6FF),
                                iconColor: const Color(0xFF2563EB),
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MainNavigationShell(
                                            initialTab: 1,
                                          ),
                                    ),
                                    (route) => false,
                                  );
                                },
                              ),
                              _buildRedesignedStatCard(
                                title: 'AQI Rerata',
                                value: '32',
                                desc: 'Tingkat Sukabumi',
                                icon: Icons.air_outlined,
                                color: const Color(0xFFECFDF5),
                                iconColor: const Color(0xFF10B981),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 4. Recent Laporan Feed
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Laporan Terbaru',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MainNavigationShell(initialTab: 2),
                                ),
                                (route) => false,
                              );
                            },
                            child: Text(
                              'Lihat Semua',
                              style: TextStyle(
                                color: activeTeal,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _recentLaporan.isEmpty
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFF1F5F9),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.description_outlined,
                                    color: Colors.grey[300],
                                    size: 44,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Belum ada laporan masuk',
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _recentLaporan.length,
                              itemBuilder: (context, index) {
                                final report = _recentLaporan[index];
                                return _buildRedesignedReportItem(report);
                              },
                            ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMiniParam(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: activeTeal, size: 18),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A2E44),
          ),
        ),
      ],
    );
  }

  Widget _buildRedesignedStatCard({
    required String title,
    required String value,
    required String desc,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: iconColor.withOpacity(0.18), width: 1.5),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              color.withOpacity(0.35),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        desc,
                        style: TextStyle(
                          fontSize: 10,
                          color: textDark.withOpacity(0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 12,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRedesignedReportItem(LaporanModel report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailLaporan(report: report),
              ),
            ).then((_) => _loadData());
          },
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: report.foto.startsWith('assets/')
                      ? Image.asset(
                          report.foto,
                          width: 76,
                          height: 76,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 76,
                                height: 76,
                                color: Colors.teal.shade50,
                                child: Icon(Icons.image, color: activeTeal),
                              ),
                        )
                      : Container(
                          width: 76,
                          height: 76,
                          color: Colors.teal.shade50,
                          child: Icon(
                            Icons.photo_library_outlined,
                            color: activeTeal,
                          ),
                        ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.judul,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              report.lokasi,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            report.tanggal,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: getBadgeBgColor(report.status),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              report.status,
                              style: TextStyle(
                                color: getBadgeTextColor(report.status),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
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
  }
}
