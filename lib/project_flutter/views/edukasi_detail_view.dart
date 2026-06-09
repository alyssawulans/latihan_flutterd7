import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/project_flutter/database/ruas_db_helper.dart';
import 'package:latihan_flutterd7/project_flutter/models/edukasi_model.dart';
import 'package:latihan_flutterd7/project_flutter/views/edukasi_form_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EdukasiDetailView extends StatefulWidget {
  final EdukasiModel article;
  const EdukasiDetailView({super.key, required this.article});

  @override
  State<EdukasiDetailView> createState() => _EdukasiDetailViewState();
}

class _EdukasiDetailViewState extends State<EdukasiDetailView> {
  late EdukasiModel _currentArticle;

  @override
  void initState() {
    super.initState();
    _currentArticle = widget.article;
    _markArticleAsRead();
  }

  Future<void> _markArticleAsRead() async {
    if (_currentArticle.id == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('current_user_id') ?? 1;
      final readKey = 'read_articles_$userId';
      final readList = prefs.getStringList(readKey) ?? [];
      final articleIdStr = _currentArticle.id.toString();
      if (!readList.contains(articleIdStr)) {
        readList.add(articleIdStr);
        await prefs.setStringList(readKey, readList);
      }
    } catch (_) {}
  }

  Future<void> _deleteArticle() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Artikel'),
        content: const Text('Apakah Anda yakin ingin menghapus artikel edukasi ini secara permanen dari database?'),
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
      await RuasDbHelper.instance.deleteEdukasi(_currentArticle.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Artikel berhasil dihapus'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context); // Go back to list
      }
    }
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
          'Detail Edukasi',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF0D9488)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EdukasiFormView(article: _currentArticle),
                ),
              ).then((updatedArticle) {
                if (updatedArticle != null && updatedArticle is EdukasiModel) {
                  setState(() {
                    _currentArticle = updatedArticle;
                  });
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _deleteArticle,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Image
            Container(
              height: 240,
              width: double.infinity,
              color: Colors.grey.shade100,
              child: _currentArticle.gambar.startsWith('assets/')
                  ? Image.asset(
                      _currentArticle.gambar,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.menu_book, size: 60, color: Colors.black26),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta tags row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2F1ED),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _currentArticle.kategori,
                          style: const TextStyle(
                            color: Color(0xFF0D9488),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.calendar_today_outlined, size: 14, color: Colors.black38),
                      const SizedBox(width: 6),
                      Text(
                        _currentArticle.tanggal,
                        style: const TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    _currentArticle.judul,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Content
                  Text(
                    _currentArticle.konten,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
