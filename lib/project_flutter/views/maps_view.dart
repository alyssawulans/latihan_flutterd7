import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;

class AqiStation {
  final String name;
  final String region;
  int aqi;
  final LatLng position;
  final String distance;

  AqiStation({
    required this.name,
    required this.region,
    required this.aqi,
    required this.position,
    required this.distance,
  });

  Color get color {
    if (aqi <= 50) return const Color(0xFF10B981); // Baik (Green)
    if (aqi <= 100) return const Color(0xFFFBBF24); // Sedang (Yellow)
    if (aqi <= 150) return const Color(0xFFF97316); // Sangat Sedang (Orange)
    return const Color(0xFFEF4444); // Tidak Sehat (Red)
  }

  String get status {
    if (aqi <= 50) return 'Baik';
    if (aqi <= 100) return 'Sedang';
    if (aqi <= 150) return 'Sangat Sedang';
    return 'Tidak Sehat';
  }

  String get statusIconText {
    if (aqi <= 50) return '😊';
    if (aqi <= 100) return '😐';
    if (aqi <= 150) return '😷';
    return '🚨';
  }
}

class MapsView extends StatefulWidget {
  const MapsView({super.key});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();

  final Color primaryTeal = const Color(0xFF0F4C43);
  final Color activeTeal = const Color(0xFF0D9488);
  final Color textDark = const Color(0xFF0F172A);

  bool _isSyncing = false;
  DateTime _lastUpdated = DateTime.now();
  String _selectedFilter = 'Semua';
  AqiStation? _selectedStation;

  final List<AqiStation> _stations = [
    AqiStation(
      name: 'Jakarta Pusat',
      region: 'DKI Jakarta',
      aqi: 154,
      position: const LatLng(-6.1818, 106.8223),
      distance: 'Wilayah Barat',
    ),
    AqiStation(
      name: 'Jakarta Selatan',
      region: 'DKI Jakarta',
      aqi: 115,
      position: const LatLng(-6.2615, 106.8106),
      distance: 'Wilayah Barat',
    ),
    AqiStation(
      name: 'Bandung',
      region: 'Jawa Barat',
      aqi: 84,
      position: const LatLng(-6.9175, 107.6191),
      distance: 'Wilayah Barat',
    ),
    AqiStation(
      name: 'Surabaya',
      region: 'Jawa Timur',
      aqi: 128,
      position: const LatLng(-7.2575, 112.7521),
      distance: 'Wilayah Timur',
    ),
    AqiStation(
      name: 'Yogyakarta',
      region: 'DI Yogyakarta',
      aqi: 42,
      position: const LatLng(-7.7956, 110.3695),
      distance: 'Wilayah Tengah',
    ),
    AqiStation(
      name: 'Medan',
      region: 'Sumatera Utara',
      aqi: 68,
      position: const LatLng(3.5952, 98.6722),
      distance: 'Wilayah Utara',
    ),
    AqiStation(
      name: 'Denpasar',
      region: 'Bali',
      aqi: 32,
      position: const LatLng(-8.6705, 115.2126),
      distance: 'Wilayah Selatan',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _simulateSync() async {
    setState(() {
      _isSyncing = true;
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    final random = Random();
    for (var station in _stations) {
      int delta = random.nextInt(31) - 15;
      station.aqi = (station.aqi + delta).clamp(15, 195);
    }

    if (mounted) {
      setState(() {
        _lastUpdated = DateTime.now();
        _isSyncing = false;
        if (_selectedStation != null) {
          _selectedStation = _stations.firstWhere(
            (s) => s.name == _selectedStation!.name,
          );
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle_outline_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text('Data AQI Nasional Berhasil Diperbarui'),
            ],
          ),
          backgroundColor: activeTeal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  List<AqiStation> get _filteredStations {
    final query = _searchController.text.toLowerCase();
    return _stations.where((station) {
      final matchesQuery =
          station.name.toLowerCase().contains(query) ||
          station.region.toLowerCase().contains(query);

      bool matchesFilter = true;
      if (_selectedFilter == 'Baik') {
        matchesFilter = station.aqi <= 50;
      } else if (_selectedFilter == 'Sedang') {
        matchesFilter = station.aqi > 50 && station.aqi <= 100;
      } else if (_selectedFilter == 'Tidak Sehat') {
        matchesFilter = station.aqi > 100;
      }

      return matchesQuery && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredStations;

    final List<Marker> mapMarkers = filtered.map((s) {
      final isSelected =
          _selectedStation != null && _selectedStation!.name == s.name;
      return Marker(
        point: s.position,
        width: 140.0,
        height: 64.0,
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedStation = s;
            });
            _mapController.move(s.position, 10.5);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: s.color,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 2.0)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: s.color.withOpacity(0.4),
                      blurRadius: isSelected ? 12 : 6,
                      spreadRadius: isSelected ? 3 : 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${s.aqi}',
                        style: TextStyle(
                          color: s.color,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      s.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              CustomPaint(
                size: const Size(8, 4),
                painter: PinPointerPainter(color: s.color),
              ),
              const SizedBox(height: 2),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: s.color.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Peta Kualitas Udara',
              style: TextStyle(
                color: primaryTeal,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Terakhir Diperbarui: ${_formatTime(_lastUpdated)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: _isSyncing
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(activeTeal),
                    ),
                  )
                : Icon(Icons.sync_rounded, color: activeTeal),
            tooltip: 'Sinkronisasi API',
            onPressed: _isSyncing ? null : _simulateSync,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar & Filters Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: TextStyle(
                              fontSize: 14,
                              color: textDark,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Cari kota atau provinsi...',
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: activeTeal,
                                size: 20,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear_rounded,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                      onPressed: () =>
                                          _searchController.clear(),
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Horizontal filter tags
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _buildFilterChip('Semua'),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Baik',
                          color: const Color(0xFF10B981),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Sedang',
                          color: const Color(0xFFFBBF24),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Tidak Sehat',
                          color: const Color(0xFFEF4444),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Map and Info Panel Section
            Expanded(
              child: Stack(
                children: [
                  // Real Interactive Map
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: const LatLng(
                              -2.5,
                              118.0,
                            ), // Center on Indonesia
                            initialZoom: 4.8,
                            minZoom: 3.0,
                            maxZoom: 18.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.ruas.id',
                            ),
                            MarkerLayer(markers: mapMarkers),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Floating Station Details Card (at the bottom)
                  if (_selectedStation != null)
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: 24,
                      child: _buildStationDetailsCard(_selectedStation!),
                    ),
                ],
              ),
            ),

            // Drawer/List of stations
            if (_selectedStation == null)
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 16,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 4,
                        ),
                        child: Text(
                          'Stasiun Pemantau AQI (${filtered.length})',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: textDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: filtered.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_off_rounded,
                                      size: 48,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Tidak ada stasiun ditemukan',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final station = filtered[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: const Color(0xFFF1F5F9),
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: station.color.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          station.statusIconText,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      title: Text(
                                        station.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: textDark,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${station.region} • ${station.distance}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      trailing: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: station.color,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          'AQI ${station.aqi}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _selectedStation = station;
                                        });
                                        _mapController.move(
                                          station.position,
                                          10.5,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, {Color? color}) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? (color ?? activeTeal) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? (color ?? activeTeal) : const Color(0xFFE2E8F0),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (color ?? activeTeal).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            if (color != null && !isSelected)
              Container(
                margin: const EdgeInsets.only(right: 6),
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF64748B),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStationDetailsCard(AqiStation station) {
    final pm25 = (station.aqi * 0.35).round();
    final pm10 = (station.aqi * 0.65).round();
    final co = (station.aqi * 0.08).toStringAsFixed(1);
    final so2 = (station.aqi * 0.12).toStringAsFixed(1);
    final o3 = (station.aqi * 0.4).round();

    final bool isUnhealthy = station.aqi > 100;
    final bool isModerate = station.aqi > 50 && station.aqi <= 100;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          station.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'LIVE API',
                            style: TextStyle(
                              color: Color(0xFF10B981),
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      station.region,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _selectedStation = null;
                  });
                },
              ),
            ],
          ),
          const Divider(height: 24, color: Color(0xFFF1F5F9)),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: station.color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: station.color.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'AQI',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${station.aqi}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status: ${station.status}',
                      style: TextStyle(
                        color: station.color,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isUnhealthy
                          ? 'Kualitas udara tidak sehat bagi kelompok sensitif atau umum. Harap waspada.'
                          : (isModerate
                                ? 'Kualitas udara sedang. Orang yang sensitif disarankan mengurangi aktivitas luar.'
                                : 'Kualitas udara sangat baik. Aman untuk beraktivitas di luar ruangan.'),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const Text(
            'Kandungan Partikulat (Polutan)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildPollutantMeter('PM2.5', '$pm25', pm25 / 150),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPollutantMeter('PM10', '$pm10', pm10 / 150),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPollutantMeter('CO', co, double.parse(co) / 15),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildPollutantMeter('SO2', so2, double.parse(so2) / 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildPollutantMeter('O3', '$o3', o3 / 120)),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CUACA',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: const [
                          Icon(
                            Icons.thermostat_rounded,
                            size: 12,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 2),
                          Text(
                            '29°C',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const Text(
            'Rekomendasi Kesehatan',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRecommendationItem(
                Icons.masks_rounded,
                'Masker',
                isUnhealthy ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                isUnhealthy ? 'Wajib' : 'Opsional',
              ),
              _buildRecommendationItem(
                Icons.sensor_window_rounded,
                'Tutup Jendela',
                isUnhealthy ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                isUnhealthy ? 'Ya' : 'Tidak',
              ),
              _buildRecommendationItem(
                Icons.directions_run_rounded,
                'Luar Ruangan',
                isUnhealthy ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                isUnhealthy ? 'Hindari' : 'Aman',
              ),
              _buildRecommendationItem(
                Icons.air,
                'Purifier',
                isUnhealthy || isModerate
                    ? const Color(0xFF10B981)
                    : const Color(0xFF64748B),
                isUnhealthy || isModerate ? 'Nyalakan' : 'Tidak Perlu',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPollutantMeter(String label, String value, double progressVal) {
    final clampedProgress = progressVal.clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: clampedProgress,
              minHeight: 3,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(
                clampedProgress > 0.7
                    ? const Color(0xFFEF4444)
                    : (clampedProgress > 0.4
                          ? const Color(0xFFFBBF24)
                          : const Color(0xFF10B981)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(
    IconData icon,
    String label,
    Color color,
    String action,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          action,
          style: TextStyle(
            fontSize: 9,
            color: color,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }
}

class PinPointerPainter extends CustomPainter {
  final Color color;

  PinPointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
