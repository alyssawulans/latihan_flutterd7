import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/project_flutter/database/ruas_db_helper.dart';
import 'package:latihan_flutterd7/project_flutter/models/edukasi_model.dart';
import 'package:latihan_flutterd7/project_flutter/views/edukasi_detail_view.dart';
import 'package:latihan_flutterd7/project_flutter/views/edukasi_form_view.dart';

class DaftarEdukasiView extends StatefulWidget {
  final String initialCategory;
  final String initialSearchQuery;

  const DaftarEdukasiView({
    super.key,
    this.initialCategory = 'Semua',
    this.initialSearchQuery = '',
  });

  @override
  State<DaftarEdukasiView> createState() => _DaftarEdukasiViewState();
}

class _DaftarEdukasiViewState extends State<DaftarEdukasiView> {
  late String _selectedCategory;
  late String _searchQuery;
  final TextEditingController _searchController = TextEditingController();

  List<EdukasiModel> _articles = [];
  bool _isLoading = true;
  bool _isBookmarkedOnly = false; // Mock toggle bookmark

  // Categories aligned with both the mockup and SQLite DB
  final List<Map<String, String>> _categories = [
    {'display': 'Semua', 'db': 'Semua'},
    {'display': 'Polusi Udara', 'db': 'Udara'},
    {'display': 'Lingkungan', 'db': 'Umum'},
    {'display': 'Sampah', 'db': 'Sampah'},
  ];

  final Color primaryTeal = const Color(0xFF0F4C43);
  final Color activeTeal = const Color(0xFF0D9488);
  final Color textDark = const Color(0xFF0F172A);

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _searchQuery = widget.initialSearchQuery;
    _searchController.text = _searchQuery;
    _fetchArticles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchArticles() async {
    setState(() {
      _isLoading = true;
    });

    // Map display category to DB category
    final categoryMapping = _categories.firstWhere(
      (c) => c['display'] == _selectedCategory,
      orElse: () => {'display': 'Semua', 'db': 'Semua'},
    );
    final dbCategory = categoryMapping['db'] == 'Semua' ? null : categoryMapping['db'];

    final results = await RuasDbHelper.instance.getEdukasis(
      category: dbCategory,
    );

    List<EdukasiModel> filtered = results;

    // Apply Search Query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
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

  int _estimateReadTime(String content) {
    final words = content.trim().split(RegExp(r'\s+')).length;
    // Assuming average reading speed of 100 words per minute
    final minutes = (words / 100).ceil();
    return minutes > 0 ? minutes : 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Daftar Edukasi',
          style: TextStyle(
            color: textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarkedOnly ? Icons.bookmark : Icons.bookmark_border_rounded,
              color: _isBookmarkedOnly ? activeTeal : const Color(0xFF0F172A),
            ),
            onPressed: () {
              setState(() {
                _isBookmarkedOnly = !_isBookmarkedOnly;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isBookmarkedOnly
                        ? 'Menampilkan artikel disimpan'
                        : 'Menampilkan semua artikel',
                  ),
                  duration: const Duration(seconds: 1),
                  backgroundColor: activeTeal,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.01),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                    _fetchArticles();
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari artikel...',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: activeTeal, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                              _fetchArticles();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            // 2. Horizontal Category Tabs
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index]['display']!;
                  final isSelected = _selectedCategory == cat;

                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: GestureDetector(
                      onTap: () => _onCategorySelected(cat),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? activeTeal : const Color(0xFFEFF3F6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const TextStyle().color,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 3. Articles List View
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Color(0xFF0D9488)),
                    )
                  : _articles.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.menu_book_rounded,
                                size: 64,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Belum ada artikel edukasi',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchArticles,
                          color: activeTeal,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _articles.length,
                            itemBuilder: (context, index) {
                              final article = _articles[index];
                              return _buildMockupArticleCard(article);
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildMockupArticleCard(EdukasiModel article) {
    final readTime = _estimateReadTime(article.konten);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
                builder: (context) => EdukasiDetailView(article: article),
              ),
            ).then((_) => _fetchArticles());
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Thumbnail image container
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: article.gambar.startsWith('assets/')
                      ? Image.asset(
                          article.gambar,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 80,
                            height: 80,
                            color: const Color(0xFFE2F1ED),
                            child: Icon(Icons.school, color: activeTeal, size: 28),
                          ),
                        )
                      : Container(
                          width: 80,
                          height: 80,
                          color: const Color(0xFFE2F1ED),
                          child: Icon(Icons.school, color: activeTeal, size: 28),
                        ),
                ),
                const SizedBox(width: 16),
                // Title and Read Time details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.judul,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$readTime Menit Membaca',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
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
