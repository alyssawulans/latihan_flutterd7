import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:latihan_flutterd7/day_34/models/rickmorty_models.dart';

class RickmortyDetailScreen extends StatefulWidget {
  final Result character;

  const RickmortyDetailScreen({super.key, required this.character});

  @override
  State<RickmortyDetailScreen> createState() => _RickmortyDetailScreenState();
} // RickmortyDetailScreen

class _RickmortyDetailScreenState extends State<RickmortyDetailScreen> {
  final Dio _dio = Dio();
  List<Map<String, String>> _episodes = [];
  bool _isLoadingEpisodes = true;

  @override
  void initState() {
    super.initState();
    _fetchEpisodesData();
  } // initState

  Future<void> _fetchEpisodesData() async {
    final episodeUrls = widget.character.episode;
    if (episodeUrls.isEmpty) {
      setState(() {
        _isLoadingEpisodes = false;
        _episodes = [];
      });
      return;
    } // if

    final ids = <int>[];
    for (final url in episodeUrls) {
      final parts = url.split('/');
      final idStr = parts.last;
      final id = int.tryParse(idStr);
      if (id != null) {
        ids.add(id);
      } // if
    } // for

    if (ids.isEmpty) {
      setState(() {
        _isLoadingEpisodes = false;
      });
      return;
    } // if

    try {
      final endpoint = 'https://rickandmortyapi.com/api/episode/${ids.join(",")}';
      final response = await _dio.get(endpoint);

      List<Map<String, String>> fetchedEpisodes = [];
      if (response.data is List) {
        for (final item in response.data) {
          fetchedEpisodes.add({
            'name': item['name']?.toString() ?? 'Unknown Episode',
            'code': item['episode']?.toString() ?? '',
            'id': item['id']?.toString() ?? '',
          });
        } // for
      } else if (response.data is Map) {
        final item = response.data;
        fetchedEpisodes.add({
          'name': item['name']?.toString() ?? 'Unknown Episode',
          'code': item['episode']?.toString() ?? '',
          'id': item['id']?.toString() ?? '',
        });
      } // else if

      if (mounted) {
        setState(() {
          _episodes = fetchedEpisodes;
          _isLoadingEpisodes = false;
        });
      } // if
    } catch (e) {
      debugPrint('Error fetching episode names: $e');
      if (mounted) {
        setState(() {
          _isLoadingEpisodes = false;
          // Fallback to URL numbering if API call fails
          _episodes = ids.map((id) => {
            'name': 'Episode $id',
            'code': 'EP $id',
            'id': id.toString(),
          }).toList();
        });
      } // if
    } // try-catch
  } // _fetchEpisodesData

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF10131A);
    const cardBgColor = Color(0xFF1C2333);
    const mutedTextColor = Color(0xFF8B92CC);

    final isAlive = widget.character.status.toLowerCase() == 'alive';
    final isDead = widget.character.status.toLowerCase() == 'dead';

    const neonGreen = Color(0xFF62FF8F);
    final statusColor = isAlive
        ? const Color(0xFF62FF8F)
        : (isDead ? const Color(0xFFFF5A5A) : Colors.amber);

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // Hero Banner Header
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: bgColor,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                  onPressed: () => Navigator.pop(context),
                ), // IconButton
              ), // CircleAvatar
            ), // Padding
            actions: const [
              SizedBox(width: 8),
            ], // actions
                flexibleSpace: FlexibleSpaceBar(
                  background: ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black,
                          Colors.black,
                          Colors.transparent,
                        ], // colors
                        stops: [0.0, 0.65, 1.0],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.network(
                      widget.character.image,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: cardBgColor,
                          child: const Center(
                            child: CircularProgressIndicator(color: Colors.white24),
                          ), // Center
                        ); // Container
                      },
                    ), // Image.network
                  ), // ShaderMask
                ), // FlexibleSpaceBar
              ), // SliverAppBar

              // Detail Content Body
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.character.name,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ), // TextStyle
                            ), // Text
                          ), // Expanded
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: statusColor.withOpacity(0.4), width: 1),
                            ), // BoxDecoration
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
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
                                  widget.character.status,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ), // TextStyle
                                ), // Text
                              ], // children
                            ), // Row
                          ), // Container
                        ], // children
                      ), // Row
                      const SizedBox(height: 20),

                      // Metrics Grid (4 Main boxes)
                      // Metrics Row (4 Main boxes side-by-side)
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricBox(
                              icon: Icons.face_retouching_natural,
                              label: 'Species',
                              value: widget.character.species,
                              color: neonGreen,
                              cardBg: cardBgColor,
                              labelColor: mutedTextColor,
                            ), // _buildMetricBox
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: _buildMetricBox(
                              icon: widget.character.gender.toLowerCase() == 'female'
                                  ? Icons.female
                                  : (widget.character.gender.toLowerCase() == 'male'
                                      ? Icons.male
                                      : Icons.help_outline),
                              label: 'Gender',
                              value: widget.character.gender,
                              color: neonGreen,
                              cardBg: cardBgColor,
                              labelColor: mutedTextColor,
                            ), // _buildMetricBox
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: _buildMetricBox(
                              icon: Icons.tv,
                              label: 'Episodes',
                              value: '${widget.character.episode.length}',
                              color: neonGreen,
                              cardBg: cardBgColor,
                              labelColor: mutedTextColor,
                            ), // _buildMetricBox
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: _buildMetricBox(
                              icon: Icons.check_circle_outline,
                              label: 'Status',
                              value: widget.character.status,
                              color: neonGreen,
                              cardBg: cardBgColor,
                              labelColor: mutedTextColor,
                            ), // _buildMetricBox
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Origin card
                      _buildLocationCard(
                        title: 'Origin',
                        locationName: widget.character.origin.name,
                        icon: Icons.public,
                        cardBg: cardBgColor,
                        accentColor: neonGreen,
                        mutedColor: mutedTextColor,
                      ), // _buildLocationCard
                      const SizedBox(height: 12),

                      // Location card
                      _buildLocationCard(
                        title: 'Current Location',
                        locationName: widget.character.location.name,
                        icon: Icons.location_on,
                        cardBg: cardBgColor,
                        accentColor: neonGreen,
                        mutedColor: mutedTextColor,
                      ), // _buildLocationCard
                      const SizedBox(height: 28),

                      // Appears in header
                      const Text(
                        'Galactic Journey (Episodes)',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ), // TextStyle
                      ), // Text
                      const SizedBox(height: 16),

                      // Appears in list
                      if (_isLoadingEpisodes)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: CircularProgressIndicator(color: Colors.white24),
                          ), // Padding
                        ) // Center
                      else if (_episodes.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'No episode data available.',
                            style: TextStyle(color: mutedTextColor, fontFamily: 'Poppins'),
                          ), // Text
                        ) // Padding
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _episodes.length,
                          itemBuilder: (context, index) {
                            final ep = _episodes[index];
                            final isLast = index == _episodes.length - 1;
                            return IntrinsicHeight(
                              child: Row(
                                children: [
                                  // Timeline axis line
                                  Column(
                                    children: [
                                      Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10131A),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: neonGreen, width: 3),
                                          boxShadow: [
                                            BoxShadow(
                                              color: neonGreen.withOpacity(0.4),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (!isLast)
                                        Expanded(
                                          child: Container(
                                            width: 2,
                                            color: neonGreen.withOpacity(0.25),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  // Card content
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: cardBgColor,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: Colors.white.withOpacity(0.04), width: 1),
                                        ), // BoxDecoration
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: neonGreen.withOpacity(0.08),
                                                      borderRadius: BorderRadius.circular(6),
                                                      border: Border.all(color: neonGreen.withOpacity(0.3), width: 0.5),
                                                    ),
                                                    child: Text(
                                                      ep['code'] ?? 'Episode ${index + 1}',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                        color: neonGreen,
                                                      ), // TextStyle
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    ep['name'] ?? '',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.white,
                                                    ), // TextStyle
                                                  ), // Text
                                                ], // children
                                              ), // Column
                                            ), // Expanded
                                            Icon(
                                              Icons.play_arrow,
                                              color: neonGreen,
                                              size: 18,
                                            ), // Icon
                                          ], // children
                                        ), // Row
                                      ), // Container
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 32),
                    ], // children
                  ), // Column
                ), // Padding
              ), // SliverToBoxAdapter
        ], // slivers
      ), // CustomScrollView
    ); // Scaffold
  } // build

  Widget _buildMetricBox({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color cardBg,
    required Color labelColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.04), width: 1),
      ), // BoxDecoration
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: labelColor.withOpacity(0.6),
            ), // TextStyle
          ), // Text
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ), // TextStyle
          ), // Text
        ], // children
      ), // Column
    ); // Container
  } // _buildMetricBox

  Widget _buildLocationCard({
    required String title,
    required String locationName,
    required IconData icon,
    required Color cardBg,
    required Color accentColor,
    required Color mutedColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04), width: 1),
      ), // BoxDecoration
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF10131A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accentColor.withOpacity(0.15), width: 1),
            ), // BoxDecoration
            child: Icon(icon, color: accentColor, size: 20),
          ), // Container
          const SizedBox(width: 14),
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
                    color: mutedColor.withOpacity(0.7),
                  ), // TextStyle
                ), // Text
                const SizedBox(height: 4),
                Text(
                  locationName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ), // TextStyle
                ), // Text
              ], // children
            ), // Column
          ), // Expanded
          Icon(
            Icons.arrow_forward_ios,
            color: mutedColor,
            size: 14,
          ), // Icon
        ], // children
      ), // Row
    ); // Container
  } // _buildLocationCard
} // _RickmortyDetailScreenState
