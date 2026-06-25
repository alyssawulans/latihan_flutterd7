import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
} // RickmortyScreen

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
    const neonGreen = Color(0xFF62FF8F);

    return Scaffold(
      backgroundColor: const Color(0xFF10131A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF10131A),
        elevation: 0,
        title: Text(
          widget.filterTitle ?? 'Rick & Morty',
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ), // TextStyle
        ), // Text
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
          ), // IconButton
        ], // actions
      ), // AppBar
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
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: neonGreen.withOpacity(0.15),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: neonGreen.withOpacity(0.04),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ), // BoxDecoration
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
                    horizontal: 16,
                    vertical: 14,
                  ),
                ), // InputDecoration
              ), // TextField
            ), // Container
          ), // Padding
          // Filters Horizontal Scroll Row
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
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 2,
                    ),
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
                        color: isSelected
                            ? const Color(0xFF10131A)
                            : Colors.white,
                      ), // TextStyle
                    ), // Text
                  ), // Container
                ); // GestureDetector
              },
            ), // ListView.builder
          ), // Container
          // Character List View builder with FutureBuilder
          Expanded(
            child: FutureBuilder<RickmortyModels>(
              future: _rickmortyFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildSkeletonList();
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
                            crossAxisCount: 2,
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
                                  // Removed Favorite Button overlay
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

                return RefreshIndicator(
                  color: neonGreen,
                  backgroundColor: cardBgColor,
                  onRefresh: () async {
                    _loadCharacters();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
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
                                      Row(
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
                                      ), // Row
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

  // Skeleton Loader Widget (Loading State)
  Widget _buildSkeletonList() {
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
  } // _buildSkeletonList

  // Empty Search Screen Widget with Lottie
  Widget _buildEmptySearchState() {
    const neonGreen = Color(0xFF62FF8F);
    const mutedTextColor = Color(0xFF8B92CC);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              'https://lottie.host/d19391e4-3990-4822-b5e0-631d87e0b5f1/S6lX8p9J2v.json',
              width: 200,
              height: 200,
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
            const SizedBox(height: 24),
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
            ), // Text
          ], // children
        ), // Column
      ), // Padding
    ); // Center
  } // _buildEmptySearchState

  // No Internet Widget with Lottie
  Widget _buildNoInternetState() {
    const neonGreen = Color(0xFF62FF8F);
    const mutedTextColor = Color(0xFF8B92CC);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              'https://lottie.host/b0429f5f-9e79-45e3-8557-de65796245ec/UoR5Zc68w1.json',
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
                      color: Colors.redAccent.withOpacity(0.2),
                      width: 2,
                    ),
                  ), // BoxDecoration
                  child: const Icon(
                    Icons.wifi_off_outlined,
                    size: 80,
                    color: Colors.redAccent,
                  ), // Icon
                ); // Container
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
            ), // ElevatedButton.icon
          ], // children
        ), // Column
      ), // Padding
    ); // Center
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
            Lottie.network(
              'https://lottie.host/626d2e61-a5bf-41c3-8884-bb9a184e900c/2i6oU5x8iY.json',
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
                  ), // Icon
                ); // Container
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
            ), // ElevatedButton.icon
          ], // children
        ), // Column
      ), // Padding
    ); // Center
  } // _buildApiErrorState
} // _RickmortyHomeTabState

// ==================== PROFILE TAB ====================
class RickmortyProfileTab extends StatelessWidget {
  const RickmortyProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    const cardBgColor = Color(0xFF1C2333);
    const mutedTextColor = Color(0xFF8B92CC);
    const neonGreen = Color(0xFF62FF8F);

    return Scaffold(
      backgroundColor: const Color(0xFF10131A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF10131A),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ), // TextStyle
        ), // Text
        centerTitle: true,
      ), // AppBar
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Glowing Profile Avatar
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: neonGreen.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ), // BoxShadow
                      ], // boxShadow
                      border: Border.all(color: neonGreen, width: 2),
                    ), // BoxDecoration
                  ), // Container
                  ClipRRect(
                    borderRadius: BorderRadius.circular(65),
                    child: Image.asset(
                      'assets/images/profile.webp',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 120,
                          height: 120,
                          color: cardBgColor,
                          child: const Icon(
                            Icons.person,
                            color: neonGreen,
                            size: 60,
                          ), // Icon
                        ); // Container
                      },
                    ), // Image.asset
                  ), // ClipRRect
                ], // children
              ), // Stack
            ), // Center
            const SizedBox(height: 24),

            // Profile Info
            const Text(
              'Alyssa Wulan Sari',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ), // TextStyle
            ), // Text
            const SizedBox(height: 6),
            const Text(
              'Mobile App Developer',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: neonGreen,
                letterSpacing: 0.8,
              ), // TextStyle
            ), // Text
            const SizedBox(height: 24),

            // Teleport portal gun button
            _buildTeleportButton(context, neonGreen, cardBgColor),
            const SizedBox(height: 24),

            // Profile Detail Cards
            _buildProfileInfoCard(
              icon: Icons.school,
              title: 'Class / Program',
              subtitle: 'Pelatihan App Developer (Flutter)',
              cardBg: cardBgColor,
              accentColor: neonGreen,
              mutedColor: mutedTextColor,
            ), // _buildProfileInfoCard
            const SizedBox(height: 12),
            _buildProfileInfoCard(
              icon: Icons.code,
              title: 'Academy',
              subtitle: 'RUAS Academy - Latihan Flutter D7',
              cardBg: cardBgColor,
              accentColor: neonGreen,
              mutedColor: mutedTextColor,
            ), // _buildProfileInfoCard
            const SizedBox(height: 12),
            _buildProfileInfoCard(
              icon: Icons.assignment_outlined,
              title: 'Assignment',
              subtitle: 'Tugas 14: Integrasi Public API',
              cardBg: cardBgColor,
              accentColor: neonGreen,
              mutedColor: mutedTextColor,
            ), // _buildProfileInfoCard
            const SizedBox(height: 24),

            // Skills Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Key Skills Used',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                ), // TextStyle
              ), // Text
            ), // Align
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSkillTag('Flutter', neonGreen),
                _buildSkillTag('Dart', neonGreen),
                _buildSkillTag('REST API', neonGreen),
                _buildSkillTag('Retrofit', neonGreen),
                _buildSkillTag('Dio Client', neonGreen),
                _buildSkillTag('JSON Mapping', neonGreen),
                _buildSkillTag('Local Storage', neonGreen),
              ], // children
            ), // Wrap
            const SizedBox(height: 40),
          ], // children
        ), // Column
      ), // SingleChildScrollView
    ); // Scaffold
  } // build

  Widget _buildTeleportButton(
    BuildContext context,
    Color neonGreen,
    Color cardBgColor,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [neonGreen.withOpacity(0.15), neonGreen.withOpacity(0.02)],
        ),
        border: Border.all(color: neonGreen.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: neonGreen.withOpacity(0.05),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _triggerTeleport(context, neonGreen),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.vpn_key_outlined, color: neonGreen, size: 22),
              const SizedBox(width: 12),
              const Text(
                'Dimensional Teleport (Random)',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _triggerTeleport(BuildContext context, Color neonGreen) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xFF10131A).withOpacity(0.95),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return _PortalWarpDialog(neonGreen: neonGreen);
      },
    );
  }

  Widget _buildProfileInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color cardBg,
    required Color accentColor,
    required Color mutedColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.02), width: 1),
      ), // BoxDecoration
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF10131A),
              shape: BoxShape.circle,
            ), // BoxDecoration
            child: Icon(icon, color: accentColor, size: 20),
          ), // Container
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: mutedColor,
                  ), // TextStyle
                ), // Text
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ), // TextStyle
                ), // Text
              ], // children
            ), // Column
          ), // Expanded
        ], // children
      ), // Row
    ); // Container
  } // _buildProfileInfoCard

  Widget _buildSkillTag(String skill, Color tagColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: tagColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: tagColor.withOpacity(0.3), width: 1),
      ), // BoxDecoration
      child: Text(
        skill,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: tagColor,
        ), // TextStyle
      ), // Text
    ); // Container
  } // _buildSkillTag
} // RickmortyProfileTab

class _PortalWarpDialog extends StatefulWidget {
  final Color neonGreen;
  const _PortalWarpDialog({required this.neonGreen});

  @override
  State<_PortalWarpDialog> createState() => _PortalWarpDialogState();
}

class _PortalWarpDialogState extends State<_PortalWarpDialog> {
  String _warpText = 'WARPING DIMENSIONS...';

  @override
  void initState() {
    super.initState();
    _startWarp();
  }

  Future<void> _startWarp() async {
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 600));
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 600));
    HapticFeedback.heavyImpact();

    final randomId = (DateTime.now().microsecondsSinceEpoch % 826) + 1;

    try {
      final dio = Dio();
      final response = await dio.get(
        'https://rickandmortyapi.com/api/character/$randomId',
      );
      if (response.statusCode == 200 && response.data != null) {
        final character = Result.fromJson(response.data);
        if (mounted) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RickmortyDetailScreen(character: character),
            ),
          );
        }
      } else {
        throw Exception('Failed to load character');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _warpText = 'PORTAL STABILIZER FAILED!\nRETRYING...';
        });
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Portal warp failed. Please check your internet connection.',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                height: 250,
                child: Lottie.network(
                  'https://lottie.host/9e414c12-32b0-466d-96e0-264fb9b5a837/97b3R8Wcph.json',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: widget.neonGreen,
                        strokeWidth: 4,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              Text(
                _warpText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: widget.neonGreen,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: widget.neonGreen.withOpacity(0.5),
                      blurRadius: 10,
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
}
