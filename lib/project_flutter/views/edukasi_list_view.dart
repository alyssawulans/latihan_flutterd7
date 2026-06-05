import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/project_flutter/database/ruas_db_helper.dart';
import 'package:latihan_flutterd7/project_flutter/models/edukasi_model.dart';
import 'package:latihan_flutterd7/project_flutter/views/edukasi_detail_view.dart';
import 'package:latihan_flutterd7/project_flutter/views/edukasi_form_view.dart';

class EdukasiListView extends StatefulWidget {
  const EdukasiListView({super.key});

  @override
  State<EdukasiListView> createState() => _EdukasiListViewState();
}

class _EdukasiListViewState extends State<EdukasiListView> {
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  List<EdukasiModel> _articles = [];
  bool _isLoading = true;

  final List<String> _categories = ['Semua', 'Udara', 'Sampah', 'Kesehatan', 'Umum'];

  final Color primaryTeal = const Color(0xFF0F4C43);
  final Color activeTeal = const Color(0xFF0D9488);
  final Color textDark = const Color(0xFF0F172A);

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    setState(() {
      _isLoading = true;
    });

    final results = await RuasDbHelper.instance.getEdukasis(
      category: _selectedCategory == 'Semua' ? null : _selectedCategory,
    );

    List<EdukasiModel> filtered = results;
    if (_searchQuery.isNotEmpty) {
      filtered = results
          .where((a) =>
              a.judul.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              a.konten.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              a.kategori.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (mounted) {
      setState(() {
        _articles = filtered;
        _isLoading = false;
      });
    }
  }

  void _onCategorySelected(String cat) {
    setState(() {
      _selectedCategory = cat;
    });
    _fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F8FB),
        elevation: 0,
        title: Text(
          'Edukasi Lingkungan',
          style: TextStyle(color: primaryTeal, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: activeTeal),
            onPressed: _fetchArticles,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                    _fetchArticles();
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari artikel edukasi...',
                    prefixIcon: Icon(Icons.search, color: activeTeal),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // Horizontal categories tags
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: activeTeal,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : textDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? Colors.transparent : const Color(0xFFF1F5F9),
                        ),
                      ),
                      onSelected: (_) => _onCategorySelected(cat),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Articles ListView
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF0D9488)))
                  : _articles.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.menu_book, size: 64, color: Colors.grey.shade300),
                              const SizedBox(height: 16),
                              Text(
                                'Belum ada artikel edukasi',
                                style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchArticles,
                          color: const Color(0xFF0D9488),
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _articles.length,
                            itemBuilder: (context, index) {
                              final article = _articles[index];
                              return _buildArticleCard(article);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EdukasiFormView()),
          ).then((_) => _fetchArticles());
        },
        backgroundColor: activeTeal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildArticleCard(EdukasiModel article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
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
                builder: (context) => EdukasiDetailView(article: article),
              ),
            ).then((_) => _fetchArticles());
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image container
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: article.gambar.startsWith('assets/')
                      ? Image.asset(
                          article.gambar,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 90,
                            height: 90,
                            color: Colors.teal.shade50,
                            child: Icon(Icons.menu_book, color: activeTeal),
                          ),
                        )
                      : Container(
                          width: 90,
                          height: 90,
                          color: Colors.teal.shade50,
                          child: Icon(Icons.menu_book, color: activeTeal),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDFA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          article.kategori,
                          style: TextStyle(
                            color: activeTeal,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        article.judul,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        article.konten,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        article.tanggal,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF94A3B8),
                        ),
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
