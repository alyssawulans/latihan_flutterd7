import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:latihan_flutterd7/project_flutter/database/ruas_db_helper.dart';
import 'package:latihan_flutterd7/project_flutter/models/laporan_model.dart';
import 'package:latihan_flutterd7/project_flutter/widgets/dashed_border_painter.dart';

class LaporanAddView extends StatefulWidget {
  const LaporanAddView({super.key});

  @override
  State<LaporanAddView> createState() => _LaporanAddViewState();
}

class _LaporanAddViewState extends State<LaporanAddView> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _deskripsiController = TextEditingController();

  String _selectedKategori = 'Sampah';
  String _koordinat = '-6.8894, 106.7914';
  String? _pickedImagePath;
  bool _isGettingLocation = false;
  bool _isSaving = false;

  final List<String> _kategoriList = [
    'Sampah',
    'Udara',
    'Limbah Cair',
    'Polusi Udara',
    'Kebisingan',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _lokasiController.text = 'Cibadak, Sukabumi';
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 5),
        );
        setState(() {
          _koordinat = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
          _lokasiController.text = 'Sukabumi (GPS Terdeteksi)';
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lokasi berhasil diambil dari GPS HP!'),
              backgroundColor: Color(0xFF0D9488),
            ),
          );
        }
      } else {
        throw Exception('Izin lokasi ditolak');
      }
    } catch (e) {
      // Fail gracefully, use simulation
      setState(() {
        _koordinat = '-6.9184, 106.8924';
        _lokasiController.text = 'Cisaat, Sukabumi (Simulasi)';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Menggunakan simulasi lokasi: $e'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGettingLocation = false;
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 800,
      );

      if (image != null) {
        setState(() {
          _pickedImagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil gambar: $e')),
        );
      }
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF0D9488)),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF0D9488)),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image, color: Colors.blue),
              title: const Text('Gunakan Dummy Asset'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _pickedImagePath = 'assets/images/kota_4.jpeg';
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveLaporan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('current_user_id') ?? 1;

    final now = DateTime.now();
    final formattedDate = DateFormat('d MMM yyyy', 'id_ID').format(now);

    final newReport = LaporanModel(
      judul: _judulController.text.trim(),
      kategori: _selectedKategori,
      lokasi: _lokasiController.text.trim(),
      koordinat: _koordinat,
      deskripsi: _deskripsiController.text.trim(),
      status: 'Diproses',
      tanggal: formattedDate,
      userId: userId,
      foto: _pickedImagePath ?? 'assets/images/kota_1.jpg',
    );

    await RuasDbHelper.instance.createLaporan(newReport);

    setState(() {
      _isSaving = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Laporan berhasil disimpan!'),
          backgroundColor: Color(0xFF0D9488),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _lokasiController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Buat Laporan Baru',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info header banner
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDFA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFCCFBF1)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: Color(0xFF0D9488)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Laporkan pencemaran udara, tumpukan sampah, atau masalah lingkungan untuk ditindaklanjuti.',
                          style: TextStyle(fontSize: 12, color: Color(0xFF0F766E), height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Judul Laporan
                const Text('Judul Laporan *', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _judulController,
                  decoration: InputDecoration(
                    hintText: 'Contoh: Pembuangan sampah sembarangan',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF0D9488), width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Judul laporan wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Kategori
                const Text('Kategori *', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedKategori,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: _kategoriList.map((kat) {
                    return DropdownMenuItem(
                      value: kat,
                      child: Text(kat),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedKategori = val!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Lokasi
                const Text('Lokasi Kejadian *', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _lokasiController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan alamat lokasi kejadian',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    suffixIcon: _isGettingLocation
                        ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0D9488)),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.my_location, color: Color(0xFF0D9488)),
                            onPressed: _getCurrentLocation,
                          ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Lokasi wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Koordinat Terpilih: $_koordinat',
                  style: const TextStyle(fontSize: 11, color: Colors.black45, fontFamily: 'monospace'),
                ),
                const SizedBox(height: 16),

                // Deskripsi
                const Text('Deskripsi Detail *', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _deskripsiController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Jelaskan kondisi laporan secara detail agar mudah ditindaklanjuti...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Deskripsi wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Foto Bukti
                const Text('Foto Bukti (Opsional)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _showImageSourcePicker,
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CustomPaint(
                      painter: DashedBorderPainter(
                        color: const Color(0xFF0D9488),
                        borderRadius: 10,
                      ),
                      child: _pickedImagePath == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt_outlined, size: 40, color: Color(0xFF0D9488)),
                                SizedBox(height: 8),
                                Text(
                                  'Ambil Foto Bukti Kejadian',
                                  style: TextStyle(fontSize: 12, color: Color(0xFF0D9488), fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Klik untuk membuka Kamera / Galeri',
                                  style: TextStyle(fontSize: 10, color: Colors.black38),
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: _pickedImagePath!.startsWith('assets/')
                                  ? Image.asset(
                                      _pickedImagePath!,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(_pickedImagePath!),
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                    ),
                  ),
                ),
                if (_pickedImagePath != null) ...[
                  const SizedBox(height: 6),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _pickedImagePath = null;
                      });
                    },
                    icon: const Icon(Icons.delete, size: 14, color: Colors.red),
                    label: const Text('Hapus Foto', style: TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                ],
                const SizedBox(height: 32),

                // Submit button
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveLaporan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Simpan Laporan',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
