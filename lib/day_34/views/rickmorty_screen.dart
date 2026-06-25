import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/day_34/models/rickmorty_models.dart';
import 'package:latihan_flutterd7/day_34/services/api_rickmorty_services.dart';
import 'package:latihan_flutterd7/day_34/services/dio_client.dart';
import 'package:latihan_flutterd7/day_34/views/rickmorty_detail_screen.dart';
import 'package:lottie/lottie.dart';

class RickmortyScreen extends StatefulWidget {
  final String? filterStatus;
  final String? filterSpecies;
  final String? filterTitle;

  const RickmortyScreen({
    super.key,
    this.filterStatus,
    this.filterSpecies,
    this.filterTitle,
  });

  @override
  State<RickmortyScreen> createState() => _RickmortyScreenState();
}

class _RickmortyScreenState extends State<RickmortyScreen> {
  late final ApiRickmortyService _apiRickmortyService;
  late final Dio _dio;
  Future<RickmortyModels>? _rickmortyFuture;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isGridView = false;

  final List<String> _filters = [
    'All',
    'Alive',
    'Dead',
    'Unknown',
    'Human',
    'Alien',
  ];

  @override
  void initState() {
    super.initState();
    _dio = createDioClient();
    _apiRickmortyService = ApiRickmortyService(_dio);

    if (widget.filterStatus != null) {
      if (widget.filterStatus == 'alive') _selectedFilter = 'Alive';
      if (widget.filterStatus == 'dead') _selectedFilter = 'Dead';
      if (widget.filterStatus == 'unknown') _selectedFilter = 'Unknown';
    } else if (widget.filterSpecies != null) {
      if (widget.filterSpecies == 'human') _selectedFilter = 'Human';
      if (widget.filterSpecies == 'alien') _selectedFilter = 'Alien';
    }

    _loadCharacters();
  } // initState

  void _loadCharacters() {
    final statusQuery = _getStatusFilter();
    final speciesQuery = _getSpeciesFilter();

    setState(() {
      _rickmortyFuture = _apiRickmortyService.getCharacters(
        name: _searchQuery.isEmpty ? null : _searchQuery,
        status: statusQuery,
        species: speciesQuery,
      );
    });
  } // _loadCharacters

  String? _getStatusFilter() {
    if (_selectedFilter == 'Alive' ||
        _selectedFilter == 'Dead' ||
        _selectedFilter == 'Unknown') {
      return _selectedFilter.toLowerCase();
    }
    return null;
  } // _getStatusFilter

  String? _getSpeciesFilter() {
    if (_selectedFilter == 'Human') {
      return 'human';
    }
    if (_selectedFilter == 'Alien') {
      return 'alien';
    }
    return null;
  } // _getSpeciesFilter

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query.trim();
      });
      _loadCharacters();
    });
  } // _onSearchChanged

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    _loadCharacters();
  } // _clearSearch

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  } // dispose

  @override
  Widget build(BuildContext context) {
    const cardBgColor = Color(0xFF1C2333);
    const mutedTextColor = Color(0xFF8B92CC);
    const neonGreen = Color(0xFFc4d849);

    return Scaffold(
      backgroundColor: const Color(0xFF000503),
      appBar: AppBar(
        flexibleSpace: Image.asset(
          "assets/images/appbag.png",
          fit: BoxFit.cover,
        ),

        backgroundColor: const Color(0xFF10131A),
        elevation: 0,

        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ), // IconButton
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.view_list : Icons.grid_view,
              color: neonGreen,
            ), // Icon
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ], // actions
      ),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: cardBgColor,

                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: neonGreen.withOpacity(0.15),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: neonGreen.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
                decoration: InputDecoration(
                  hintText: 'Search Character...',
                  hintStyle: TextStyle(
                    color: mutedTextColor.withOpacity(0.6),
                    fontFamily: 'Poppins',
                    fontSize: 13,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: neonGreen.withOpacity(0.7),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: mutedTextColor),
                          onPressed: _clearSearch,
                        ) // IconButton
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),

          // Pencarian ke samping
          Container(
            height: 48,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filterName = _filters[index];
                final isSelected = _selectedFilter == filterName;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = filterName;
                    });
                    _loadCharacters();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? neonGreen : cardBgColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: neonGreen.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ), // BoxShadow
                            ]
                          : null,
                    ), // BoxDecoration
                    child: Text(
                      filterName,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: isSelected ? Color(0xFF10131A) : Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Buat List Karakter ke bawah
          Expanded(
            child: FutureBuilder<RickmortyModels>(
              future: _rickmortyFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadList();
                }

                if (snapshot.hasError) {
                  final err = snapshot.error;
                  if (err is DioException) {
                    if (err.response?.statusCode == 404) {
                      return _buildEmptySearchState();
                    }
                    if (err.type == DioExceptionType.connectionTimeout ||
                        err.type == DioExceptionType.connectionError ||
                        err.message != null &&
                            err.message!.contains('SocketException')) {
                      return _buildNoInternetState();
                    }
                  }
                  return _buildApiErrorState();
                }

                if (!snapshot.hasData || snapshot.data!.results.isEmpty) {
                  return _buildEmptySearchState();
                }

                final characters = snapshot.data!.results;

                //BUAT GRID BUILDER

                if (_isGridView) {
                  return RefreshIndicator(
                    color: neonGreen,
                    backgroundColor: cardBgColor,
                    onRefresh: () async {
                      _loadCharacters();
                    },
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                      itemCount: characters.length,
                      itemBuilder: (context, index) {
                        final char = characters[index];
                        final isAlive = char.status.toLowerCase() == 'alive';
                        final isDead = char.status.toLowerCase() == 'dead';
                        final statusColor = isAlive
                            ? const Color(0xFF62FF8F)
                            : (isDead ? const Color(0xFFFF5A5A) : Colors.amber);

                        return Container(
                          decoration: BoxDecoration(
                            color: cardBgColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.04),
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RickmortyDetailScreen(character: char),
                                  ),
                                );
                              },
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    char.image,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Container(
                                        color: Colors.white.withOpacity(0.05),
                                        child: const Center(
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white24,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Positioned.fill(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.3),
                                            Colors.black.withOpacity(0.85),
                                          ],
                                          stops: const [0.0, 0.5, 1.0],
                                        ),
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    top: 6,
                                    left: 6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: statusColor.withOpacity(0.4),
                                          width: 0.5,
                                        ),
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
                                          const SizedBox(width: 4),
                                          Text(
                                            char.status,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: statusColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 8,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    right: 8,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          char.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${char.species} • ${char.gender}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colors.white.withOpacity(
                                              0.7,
                                            ),
                                            fontSize: 9,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                //BUAT LIST VIEW BUILDER

                return RefreshIndicator(
                  color: neonGreen,
                  backgroundColor: cardBgColor,
                  onRefresh: () async {
                    _loadCharacters();
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      final char = characters[index];
                      final isAlive = char.status.toLowerCase() == 'alive';
                      final isDead = char.status.toLowerCase() == 'dead';
                      final statusColor = isAlive
                          ? const Color(0xFF62FF8F)
                          : (isDead ? const Color(0xFFFF5A5A) : Colors.amber);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),

                        decoration: BoxDecoration(
                          color: cardBgColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.04),
                            width: 1,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RickmortyDetailScreen(character: char),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                // Character Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    char.image,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,

                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.white.withOpacity(0.05),
                                        child: const Center(
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white24,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Character details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        char.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ), // TextStyle
                                      ), // Text
                                      const SizedBox(height: 4),

                                      // Status row
                                      Container(
                                        height: 20,
                                        width: 85,
                                        padding: EdgeInsets.only(),

                                        decoration: BoxDecoration(
                                          border: BoxBorder.all(),
                                          color: statusColor.withOpacity(0.4),

                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                        ),

                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: statusColor,
                                                shape: BoxShape.circle,
                                              ), // BoxDecoration
                                            ), // Container
                                            const SizedBox(width: 6),
                                            Text(
                                              char.status,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: statusColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                              ), // TextStyle
                                            ), // Text
                                          ], // children
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      // Species & Gender
                                      Text(
                                        '${char.species} • ${char.gender}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: mutedTextColor.withOpacity(
                                            0.8,
                                          ),
                                          fontSize: 11,
                                        ), // TextStyle
                                      ), // Text
                                      const SizedBox(height: 2),

                                      // Location
                                      Text(
                                        char.location.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: mutedTextColor.withOpacity(
                                            0.5,
                                          ),
                                          fontSize: 10,
                                        ),
                                      ),
                                    ], // children
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_right,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ], // children
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ], // children
      ),
    );
  } // build

  // Loading Tunggu
  Widget _buildLoadList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color(0xFF1C2333),
            borderRadius: BorderRadius.circular(16),
          ), // BoxDecoration
          child: Row(
            children: [
              // Avatar box
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12),
                ), // BoxDecoration
              ), // Container
              const SizedBox(width: 16),

              // Lines box
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 140,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(4),
                      ), // BoxDecoration
                    ), // Container
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            shape: BoxShape.circle,
                          ), // BoxDecoration
                        ), // Container
                        const SizedBox(width: 6),
                        Container(
                          width: 60,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(4),
                          ), // BoxDecoration
                        ), // Container
                      ], // children
                    ), // Row
                    const SizedBox(height: 8),
                    Container(
                      width: 100,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(4),
                      ), // BoxDecoration
                    ), // Container
                  ], // children
                ), // Column
              ), // Expanded
            ], // children
          ), // Row
        ); // Container
      },
    ); // ListView.builder
  } // _buildLoadList

  // Ketika di Search Kosong
  Widget _buildEmptySearchState() {
    const neonGreen = Color(0xFF62FF8F);
    const mutedTextColor = Color(0xFF8B92CC);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/animations/lottie_2.json",

              width: 400,
              height: 400,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C2333),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: neonGreen.withOpacity(0.2),
                      width: 2,
                    ),
                  ), // BoxDecoration
                  child: const Icon(
                    Icons.search_off,
                    size: 80,
                    color: neonGreen,
                  ), // Icon
                ); // Container
              },
            ), // Lottie.network

            const Text(
              'Character not found',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ), // TextStyle
            ), // Text
            const SizedBox(height: 10),
            const Text(
              'Try another keyword or check your spelling.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: mutedTextColor,
              ), // TextStyle
            ),
          ],
        ),
      ),
    );
  }

  // Ketika Tidak Ada Internet
  Widget _buildNoInternetState() {
    const neonGreen = Color(0xFF62FF8F);
    const mutedTextColor = Color(0xFF8B92CC);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/animations/lottie_1.json",
              width: 300,
              height: 300,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C2333),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.redAccent.withOpacity(0.2),
                      width: 2,
                    ),
                  ), // BoxDecoration
                  child: const Icon(
                    Icons.wifi_off_outlined,
                    size: 80,
                    color: Colors.redAccent,
                  ),
                );
              },
            ), // Lottie.network
            const SizedBox(height: 24),
            const Text(
              'No Internet Connection',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ), // TextStyle
            ), // Text
            const SizedBox(height: 10),
            const Text(
              'Please check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: mutedTextColor,
              ), // TextStyle
            ), // Text
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadCharacters,
              style: ElevatedButton.styleFrom(
                backgroundColor: neonGreen,
                foregroundColor: const Color(0xFF10131A),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ), // styleFrom
              icon: const Icon(Icons.replay),
              label: const Text(
                'Retry',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ], // children
        ),
      ),
    );
  } // _buildNoInternetState

  // API / Server Error Widget with Lottie
  Widget _buildApiErrorState() {
    const neonGreen = Color(0xFF62FF8F);
    const mutedTextColor = Color(0xFF8B92CC);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/animations/lottie_2.json",
              width: 220,
              height: 220,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C2333),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.2),
                      width: 2,
                    ),
                  ), // BoxDecoration
                  child: const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.amber,
                  ),
                );
              },
            ), // Lottie.network
            const SizedBox(height: 24),
            const Text(
              'Oops!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ), // TextStyle
            ), // Text
            const SizedBox(height: 10),
            const Text(
              'Something went wrong while fetching data from the server.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: mutedTextColor,
              ), // TextStyle
            ), // Text
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadCharacters,
              style: ElevatedButton.styleFrom(
                backgroundColor: neonGreen,
                foregroundColor: const Color(0xFF10131A),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ), // styleFrom
              icon: const Icon(Icons.replay),
              label: const Text(
                'Retry',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
