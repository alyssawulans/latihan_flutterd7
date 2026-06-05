import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/project_flutter/widgets/simulated_map_widget.dart';

class MapsView extends StatefulWidget {
  const MapsView({super.key});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  final TextEditingController _searchController = TextEditingController();

  final Color primaryTeal = const Color(0xFF0F4C43);
  final Color activeTeal = const Color(0xFF0D9488);
  final Color textDark = const Color(0xFF0F172A);

  final List<MapMarker> _markers = [
    MapMarker(
      label: 'Cibadak',
      aqi: 32,
      position: const Offset(0.3, 0.35),
      color: Colors.green,
    ),
    MapMarker(
      label: 'Selabintana',
      aqi: 40,
      position: const Offset(0.6, 0.22),
      color: Colors.green,
    ),
    MapMarker(
      label: 'Cisaat',
      aqi: 96,
      position: const Offset(0.45, 0.6),
      color: Colors.orange,
    ),
    MapMarker(
      label: 'Sukabumi Kota',
      aqi: 140,
      position: const Offset(0.75, 0.5),
      color: Colors.red,
    ),
  ];

  final List<Map<String, dynamic>> _locations = [
    {
      'nama': 'Cibadak',
      'aqi': 32,
      'status': 'Good',
      'warna': Colors.green,
      'jarak': '1.2 km',
    },
    {
      'nama': 'Selabintana',
      'aqi': 40,
      'status': 'Good',
      'warna': Colors.green,
      'jarak': '2.5 km',
    },
    {
      'nama': 'Cisaat',
      'aqi': 96,
      'status': 'Moderate',
      'warna': Colors.orange,
      'jarak': '3.1 km',
    },
    {
      'nama': 'Sukabumi Kota',
      'aqi': 140,
      'status': 'Unhealthy',
      'warna': Colors.red,
      'jarak': '4.3 km',
    },
  ];

  MapMarker? _selectedMarker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F8FB),
        elevation: 0,
        title: Text(
          'Peta Kualitas Udara',
          style: TextStyle(color: primaryTeal, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.01),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari lokasi...',
                          prefixIcon: Icon(Icons.search, color: activeTeal),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.01),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.tune, color: activeTeal),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Vector Map Container
              Expanded(
                flex: 3,
                child: SimulatedMapWidget(
                  markers: _markers,
                  onMarkerTap: (marker) {
                    setState(() {
                      _selectedMarker = marker;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lokasi: ${marker.label} (AQI: ${marker.aqi})'),
                        backgroundColor: marker.color,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // List of nearby locations
              Text(
                'Lokasi Terdekat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                flex: 2,
                child: ListView.builder(
                  itemCount: _locations.length,
                  itemBuilder: (context, index) {
                    final loc = _locations[index];
                    final isSelected = _selectedMarker != null && _selectedMarker!.label == loc['nama'];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFF0FDFA) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? activeTeal : const Color(0xFFF1F5F9),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.01),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: loc['warna'].withOpacity(0.1),
                          child: Icon(Icons.location_on, color: loc['warna']),
                        ),
                        title: Text(
                          loc['nama'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              'AQI ${loc['aqi']}',
                              style: TextStyle(color: loc['warna'], fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            const Text(' • ', style: TextStyle(color: Colors.black26)),
                            Text(
                              loc['status'],
                              style: TextStyle(color: loc['warna'], fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: Text(
                          loc['jarak'],
                          style: const TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        onTap: () {
                          // select marker programmatically
                          final matchMarker = _markers.firstWhere((m) => m.label == loc['nama']);
                          setState(() {
                            _selectedMarker = matchMarker;
                          });
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
    );
  }
}
