import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:latihan_flutterd7/project_flutter/database/ruas_db_helper.dart';
import 'package:latihan_flutterd7/project_flutter/models/aqi_station_model.dart';
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

  String _currentLocationName = 'Cibadak, Sukabumi';
  AqiStation? _nearestStation;

  String get _cityName {
    final parts = _currentLocationName.split(',');
    if (parts.isNotEmpty) {
      return parts.last.trim();
    }
    return 'kota Anda';
  }

  List<int> _get7DayAqiValues() {
    if (_nearestStation == null) return [32, 32, 32, 32, 32, 32, 32];
    final String name = _nearestStation!.name;
    final int currentAqi = _nearestStation!.aqi;
    final int seed = name.hashCode;
    final List<int> vals = [];
    for (int i = 0; i < 6; i++) {
      final double offset = sin(seed + i) * 20;
      final int val = (currentAqi + offset).round().clamp(15, 200);
      vals.add(val);
    }
    vals.add(currentAqi);
    return vals;
  }

  List<String> _get7DayAqiDates() {
    final List<String> dates = [];
    const idLocale = 'id_ID';
    for (int i = 6; i >= 0; i--) {
      final DateTime date = DateTime.now().subtract(Duration(days: i));
      dates.add(DateFormat('dd MMM', idLocale).format(date));
    }
    return dates;
  }

  Future<void> _fetchGPSLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: Duration(seconds: 4),
          ),
        );

        final double lat = position.latitude;
        final double lon = position.longitude;

        // Cari stasiun pemantau AQI terdekat dari koordinat GPS ini
        AqiStation? closestStation;
        double minDistance = double.infinity;

        for (final station in AqiStation.defaultStations) {
          final double distance = Geolocator.distanceBetween(
            lat,
            lon,
            station.position.latitude,
            station.position.longitude,
          );
          if (distance < minDistance) {
            minDistance = distance;
            closestStation = station;
          }
        }

        String resolvedAddress = "";

        try {
          final client = HttpClient();
          client.userAgent =
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) LatihanFlutterD7/1.0";
          final request = await client
              .getUrl(
                Uri.parse(
                  'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&zoom=16',
                ),
              )
              .timeout(const Duration(seconds: 3));

          final response = await request.close();
          if (response.statusCode == 200) {
            final responseBody = await response.transform(utf8.decoder).join();
            final decoded = json.decode(responseBody);
            final address = decoded['address'];
            if (address != null) {
              final road =
                  address['road'] ??
                  address['suburb'] ??
                  address['village'] ??
                  '';
              final city =
                  address['city'] ??
                  address['town'] ??
                  address['city_district'] ??
                  address['municipality'] ??
                  address['county'] ??
                  '';

              List<String> parts = [];
              if (road.toString().isNotEmpty) parts.add(road.toString());
              if (city.toString().isNotEmpty) parts.add(city.toString());

              if (parts.isNotEmpty) {
                resolvedAddress = parts.join(', ');
              }
            }
            if (resolvedAddress.isEmpty) {
              resolvedAddress = decoded['display_name'] ?? "";
            }
          }
        } catch (_) {}

        if (mounted) {
          setState(() {
            if (resolvedAddress.isNotEmpty) {
              _currentLocationName = resolvedAddress;
            } else if (closestStation != null) {
              _currentLocationName =
                  '${closestStation.name}, ${closestStation.region}';
            }
            if (closestStation != null) {
              _nearestStation = closestStation;
            }
          });
        }
      }
    } catch (_) {
      // Fail silently
    }
  }

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
        _nearestStation ??= AqiStation.defaultStations.firstWhere(
          (s) => s.name == 'Sukabumi',
          orElse: () => AqiStation.defaultStations.first,
        );
        _isLoading = false;
      });
    }

    _fetchGPSLocation();
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
                physics: const BouncingScrollPhysics(),
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_getGreeting()}, \n$_userName 👋',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _getDynamicQuote(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.2,
                                ),
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
                                color: Colors.white.withValues(alpha: 0.9),
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$_currentLocationName • ${DateFormat('dd MMM yyyy', 'id_ID').format(DateTime.now())}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // 2. Floating AQI Panel Card (Beautified like mockup)
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
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left details column
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'AQI Saat Ini',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Text(
                                            '${_nearestStation?.aqi ?? 32}',
                                            style: TextStyle(
                                              fontSize: 44,
                                              fontWeight: FontWeight.w900,
                                              color:
                                                  _nearestStation?.color ??
                                                  const Color(0xFF10B981),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  _nearestStation?.color ??
                                                  const Color(0xFF10B981),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              _nearestStation?.status ?? 'Baik',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        _nearestStation?.description ??
                                            'Kualitas udara baik untuk aktivitas luar ruangan.',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF475569),
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Right Side Illustration/Photo
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    'assets/images/project_akhir/bag_2.png',
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.fitWidth,
                                    alignment: AlignmentGeometry.bottomCenter,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              width: 110,
                                              height: 90,
                                              color: const Color(0xFFE2F1ED),
                                              child: const Icon(
                                                Icons.apartment_rounded,
                                                color: Color(0xFF0D9488),
                                                size: 36,
                                              ),
                                            ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            const SizedBox(height: 16),
                            // Metrics details row grid
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildMiniParam(
                                  Icons.eco_outlined,
                                  'PM2.5',
                                  '${_nearestStation?.pm25 ?? 12} µg/m³',
                                ),
                                _buildMiniParam(
                                  Icons.thermostat,
                                  'Suhu',
                                  '${_nearestStation?.temp ?? 28}°C',
                                ),
                                _buildMiniParam(
                                  Icons.water_drop_outlined,
                                  'Lembab',
                                  '${_nearestStation?.humidity ?? 65}%',
                                ),
                                _buildMiniParam(
                                  Icons.air,
                                  'Ozon (O³)',
                                  '${(_nearestStation?.o3 ?? 0.02).toStringAsFixed(3)} ppm',
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            const SizedBox(height: 16),
                            _buildHealthRecommendations(),
                          ],
                        ),
                      ),
                    ),

                    // 3. Quick Stats Cards Grid ("Ringkasan")
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ringkasan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
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
                                value: '${AqiStation.defaultStations.length}',
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
                                value: '${_nearestStation?.aqi ?? 32}',
                                desc:
                                    'Tingkat ${_nearestStation?.name ?? "Sukabumi"}',
                                icon: Icons.air_outlined,
                                color:
                                    (_nearestStation?.color ??
                                            const Color(0xFFECFDF5))
                                        .withValues(alpha: 0.12),
                                iconColor:
                                    _nearestStation?.color ??
                                    const Color(0xFF10B981),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 4. Grafik AQI 7 Hari Terakhir
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: AqiLineChart(
                        values: _get7DayAqiValues(),
                        dates: _get7DayAqiDates(),
                        chartColor:
                            _nearestStation?.color ?? const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 5. Aktivitas & Tips
                    _buildAktivitasDanTips(),
                    const SizedBox(height: 20),

                    // 6. Recent Laporan Feed
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
                    const SizedBox(height: 6),

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
                              padding: EdgeInsets.zero,
                              itemCount: _recentLaporan.length,
                              itemBuilder: (context, index) {
                                final report = _recentLaporan[index];
                                return _buildRedesignedReportItem(report);
                              },
                            ),
                    ),
                    const SizedBox(height: 110),
                  ],
                ),
              ),
            ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  String _getDynamicQuote() {
    final quotes = [
      'Mari jaga lingkungan kita tetap bersih & asri!',
      'Udara bersih adalah hak bersama, yuk kurangi emisi!',
      'Udara hari ini sangat baik untuk bersepeda atau berjalan kaki.',
      'Gunakan transportasi umum demi langit biru $_cityName.',
      'Matikan mesin kendaraan saat sedang berhenti lama.',
      'Menanam satu pohon hari ini memberikan napas untuk masa depan.',
    ];
    final day = DateTime.now().day;
    return quotes[day % quotes.length];
  }

  Widget _buildHealthRecommendations() {
    if (_nearestStation == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rekomendasi Aktivitas & Kesehatan',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildHealthItem(
              Icons.child_care_rounded,
              'Anak-anak',
              _nearestStation!.getRecommendation('Anak-anak'),
              _nearestStation!.getRecommendationColor('Anak-anak'),
            ),
            _buildHealthItem(
              Icons.elderly_rounded,
              'Lansia',
              _nearestStation!.getRecommendation('Lansia'),
              _nearestStation!.getRecommendationColor('Lansia'),
            ),
            _buildHealthItem(
              Icons.masks_rounded,
              'Sensitif',
              _nearestStation!.getRecommendation('Sensitif'),
              _nearestStation!.getRecommendationColor('Sensitif'),
            ),
            _buildHealthItem(
              Icons.directions_run_rounded,
              'Olahraga',
              _nearestStation!.getRecommendation('Olahraga'),
              _nearestStation!.getRecommendationColor('Olahraga'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthItem(
    IconData icon,
    String label,
    String status,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          gradient: LinearGradient(
            colors: [Colors.white, color.withValues(alpha: 0.15)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Watermark Icon
            Positioned(
              bottom: -12,
              right: -12,
              child: Transform.rotate(
                angle: -0.2,
                child: Icon(
                  icon,
                  size: 72,
                  color: iconColor.withValues(alpha: 0.08),
                ),
              ),
            ),
            // Card Content
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Row: Icon Badge & Value with Arrow Chevron
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: iconColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, size: 18, color: iconColor),
                      ),
                      Row(
                        children: [
                          Text(
                            value,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFFCBD5E1),
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Bottom Column: Title & Description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        desc,
                        style: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRedesignedReportItem(LaporanModel report) {
    Color statusColor;
    Color gradientEndColor;
    switch (report.status.toLowerCase()) {
      case 'selesai':
        statusColor = const Color(0xFF10B981);
        gradientEndColor = const Color(0xFFECFDF5);
        break;
      case 'ditolak':
        statusColor = const Color(0xFFEF4444);
        gradientEndColor = const Color(0xFFFEF2F2);
        break;
      case 'diproses':
      default:
        statusColor = const Color(0xFFF97316);
        gradientEndColor = const Color(0xFFFFF7ED);
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        gradient: LinearGradient(
          colors: [Colors.white, gradientEndColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 6),
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
          child: Stack(
            children: [
              // Left Accent Color Stripe
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                ),
              ),
              // Main content Row
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  children: [
                    // Styled Image Container with border and shadow
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: report.foto.startsWith('http')
                            ? Image.network(
                                report.foto,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: const Color(0xFFE6F4F1),
                                      child: const Icon(
                                        Icons.image,
                                        color: Color(0xFF0D9488),
                                      ),
                                    ),
                              )
                            : report.foto.startsWith('assets/')
                            ? Image.asset(
                                report.foto,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: const Color(0xFFE6F4F1),
                                      child: const Icon(
                                        Icons.image,
                                        color: Color(0xFF0D9488),
                                      ),
                                    ),
                              )
                            : report.foto.isNotEmpty
                            ? Image.file(
                                File(report.foto),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: const Color(0xFFE6F4F1),
                                      child: const Icon(
                                        Icons.image,
                                        color: Color(0xFF0D9488),
                                      ),
                                    ),
                              )
                            : Container(
                                color: const Color(0xFFE6F4F1),
                                child: const Icon(
                                  Icons.photo_library_outlined,
                                  color: Color(0xFF0D9488),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Details column
                    Expanded(
                      child: SizedBox(
                        height: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Title
                            Text(
                              report.judul,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Location Chip/Tag
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: Color(0xFF64748B),
                                    size: 11,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      report.lokasi,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF64748B),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Date and Status Pill Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  report.tanggal,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF94A3B8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 5,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          color: statusColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        report.status,
                                        style: TextStyle(
                                          color: statusColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Far-right Arrow Chevron Icon
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: Color(0xFFCBD5E1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAktivitasDanTips() {
    final aqi = _nearestStation?.aqi ?? 32;

    // Define Left Card properties based on AQI
    String activityTitle;
    String activitySubtitle;
    String activityImage;
    Color activityBorderColor;
    Color activityBgStartColor;
    Color activityBgEndColor;
    Color activityAccentColor;

    // Define Right Card properties based on AQI
    String tipTitle;
    String tipSubtitle;
    String tipImage;
    Color tipBorderColor;
    Color tipBgStartColor;
    Color tipBgEndColor;
    Color tipAccentColor;

    if (aqi <= 50) {
      // Good AQI
      activityTitle = 'Bersepeda';
      activitySubtitle =
          'Kualitas udara sangat bersih, mari aktif bersepeda di luar ruangan.';
      activityImage = 'assets/images/project_akhir/aktivitas_1.png';
      activityBorderColor = const Color(0xFFDCFCE7);
      activityBgStartColor = const Color(0xFFF0FDF4);
      activityBgEndColor = const Color(0xFFDCFCE7);
      activityAccentColor = const Color(0xFF166534);

      tipTitle = 'Buka Jendela';
      tipSubtitle =
          'Buka ventilasi rumah untuk sirkulasi udara alami yang segar.';
      tipImage = 'assets/images/project_akhir/aktivitas_9.png';
      tipBorderColor = const Color(0xFFCCFBF1);
      tipBgStartColor = const Color(0xFFF0FDFA);
      tipBgEndColor = const Color(0xFFCCFBF1);
      tipAccentColor = const Color(0xFF0F766E);
    } else if (aqi <= 100) {
      // Moderate AQI
      activityTitle = 'Jalan Santai';
      activitySubtitle =
          'Kualitas udara sedang, aman untuk beraktivitas luar ruangan santai.';
      activityImage = 'assets/images/project_akhir/aktivitas_3.png';
      activityBorderColor = const Color(0xFFFEF3C7);
      activityBgStartColor = const Color(0xFFFFFDF2);
      activityBgEndColor = const Color(0xFFFEF3C7);
      activityAccentColor = const Color(0xFF92400E);

      tipTitle = 'Transportasi Umum';
      tipSubtitle =
          'Kurangi emisi polusi dengan menggunakan angkutan umum atau jalan kaki.';
      tipImage = 'assets/images/project_akhir/aktivitas_2.png';
      tipBorderColor = const Color(0xFFCCFBF1);
      tipBgStartColor = const Color(0xFFF0FDFA);
      tipBgEndColor = const Color(0xFFCCFBF1);
      tipAccentColor = const Color(0xFF0F766E);
    } else {
      // Unhealthy / Poor AQI (>100)
      activityTitle = 'Air Purifier';
      activitySubtitle =
          'Kualitas udara kurang baik. Gunakan Air Purifier di dalam rumah.';
      activityImage = 'assets/images/project_akhir/aktivitas_8.png';
      activityBorderColor = const Color(0xFFFEE2E2);
      activityBgStartColor = const Color(0xFFFEF2F2);
      activityBgEndColor = const Color(0xFFFEE2E2);
      activityAccentColor = const Color(0xFF991B1B);

      tipTitle = 'Gunakan Masker';
      tipSubtitle =
          'Paparan polusi udara tinggi. Gunakan masker medis/N95 jika harus keluar ruangan.';
      tipImage = 'assets/images/project_akhir/aktivitas_7.png';
      tipBorderColor = const Color(0xFFFEE2E2);
      tipBgStartColor = const Color(0xFFFEF2F2);
      tipBgEndColor = const Color(0xFFFEE2E2);
      tipAccentColor = const Color(0xFF991B1B);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aktivitas & Tips',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Left Card
              Expanded(
                child: Container(
                  height: 195,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: activityBorderColor),
                    gradient: LinearGradient(
                      colors: [activityBgStartColor, activityBgEndColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Transform.scale(
                          scale: 1.3,
                          child: Image.asset(activityImage, fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.5),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Aktivitas Disarankan',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: activityAccentColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                activityTitle,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                activitySubtitle,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFF475569),
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Right Card
              Expanded(
                child: Container(
                  height: 195,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: tipBorderColor),
                    gradient: LinearGradient(
                      colors: [tipBgStartColor, tipBgEndColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Transform.scale(
                          scale: 1.3,
                          child: Image.asset(tipImage, fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.5),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Tips Hari Ini',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: tipAccentColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tipTitle,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tipSubtitle,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFF475569),
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom Paint AQI Line Chart Widget
class AqiLineChart extends StatelessWidget {
  final List<int> values;
  final List<String> dates;
  final Color chartColor;

  const AqiLineChart({
    super.key,
    required this.values,
    required this.dates,
    required this.chartColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grafik AQI 7 Hari Terakhir',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A2E44),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            width: double.infinity,
            child: CustomPaint(
              painter: _AqiChartPainter(
                values: values,
                dates: dates,
                chartColor: chartColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Legend Row
          Center(
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildLegendItem(const Color(0xFF10B981), 'Baik (0-50)'),
                _buildLegendItem(const Color(0xFFFBBF24), 'Sedang (51-100)'),
                _buildLegendItem(
                  const Color(0xFFF97316),
                  'Sangat Sedang (101-150)',
                ),
                _buildLegendItem(const Color(0xFFEF4444), 'Tidak Sehat (>150)'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _AqiChartPainter extends CustomPainter {
  final List<int> values;
  final List<String> dates;
  final Color chartColor;

  _AqiChartPainter({
    required this.values,
    required this.dates,
    required this.chartColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double leftMargin = 20.0;
    const double rightMargin = 20.0;
    const double topMargin = 25.0;
    const double bottomMargin = 25.0;

    final double width = size.width - leftMargin - rightMargin;
    final double height = size.height - topMargin - bottomMargin;
    final double stepWidth = width / (values.length - 1);

    // Dynamic maximum calculation to prevent clipping when value > 50
    final double maxVal =
        values.fold<double>(
          50.0,
          (max, val) => val > max ? val.toDouble() : max,
        ) *
        1.15;

    final List<Offset> points = [];
    for (int i = 0; i < values.length; i++) {
      final double x = leftMargin + i * stepWidth;
      final double y =
          size.height - bottomMargin - (values[i] / maxVal * height);
      points.add(Offset(x, y));
    }

    // 1. Draw gradient area under the curve
    final Path fillPath = Path();
    fillPath.moveTo(points.first.dx, size.height - bottomMargin);
    fillPath.lineTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      fillPath.lineTo(points[i].dx, points[i].dy);
    }
    fillPath.lineTo(points.last.dx, size.height - bottomMargin);
    fillPath.close();

    final fillPaint = Paint()
      ..shader =
          LinearGradient(
            colors: [
              chartColor.withValues(alpha: 0.25),
              chartColor.withValues(alpha: 0.0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(
            Rect.fromLTRB(
              leftMargin,
              topMargin,
              size.width - rightMargin,
              size.height - bottomMargin,
            ),
          )
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    // 2. Draw line connecting points
    final Path linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }

    final linePaint = Paint()
      ..color = chartColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    canvas.drawPath(linePath, linePaint);

    // 3. Draw dots, value text above dots, and date text below
    final dotPaint = Paint()
      ..color = chartColor
      ..style = PaintingStyle.fill;
    final dotInnerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      final offset = points[i];

      // Draw outer circle
      canvas.drawCircle(offset, 5.0, dotPaint);
      // Draw inner white circle
      canvas.drawCircle(offset, 2.5, dotInnerPaint);

      // Draw value text above node
      final valuePainter = TextPainter(
        text: TextSpan(
          text: '${values[i]}',
          style: const TextStyle(
            color: Color(0xFF1B2E44),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      valuePainter.layout();
      valuePainter.paint(
        canvas,
        Offset(offset.dx - valuePainter.width / 2, offset.dy - 18),
      );

      // Draw date text below
      final datePainter = TextPainter(
        text: TextSpan(
          text: dates[i],
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 9,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      datePainter.layout();
      datePainter.paint(
        canvas,
        Offset(
          offset.dx - datePainter.width / 2,
          size.height - bottomMargin + 6,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AqiChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.dates != dates ||
        oldDelegate.chartColor != chartColor;
  }
}
