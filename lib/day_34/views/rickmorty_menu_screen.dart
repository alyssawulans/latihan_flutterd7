import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';
import 'package:latihan_flutterd7/day_34/models/rickmorty_models.dart';
import 'package:latihan_flutterd7/day_34/views/rickmorty_screen.dart';
import 'package:latihan_flutterd7/day_34/views/rickmorty_detail_screen.dart';

class RickmortyMenuScreen extends StatelessWidget {
  const RickmortyMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF10131A);
    const cardBgColor = Color(0xFF1C2333);
    const neonGreen = Color(0xFF62FF8F);
    const mutedTextColor = Color(0xFF8B92CC);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Lottie & Title Banner
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: Lottie.network(
                        'https://lottie.host/9e414c12-32b0-466d-96e0-264fb9b5a837/97b3R8Wcph.json',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.blur_circular,
                            size: 80,
                            color: neonGreen,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Rick & Morty',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: neonGreen,
                        letterSpacing: 1.0,
                        shadows: [Shadow(color: neonGreen, blurRadius: 15)],
                      ),
                    ),
                    Text(
                      'PORTAL DATABASE',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.6),
                        letterSpacing: 4.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Section: Explore Categories
              const Text(
                'Explore Dimensions',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Button: All Characters (Big Card)
              _buildCategoryCard(
                context: context,
                title: 'All Characters',
                subtitle: 'Browse all entities in the universe',
                icon: Icons.grid_view_rounded,
                color: neonGreen,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RickmortyScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Grid: Status Categories (Alive, Dead, Unknown)
              Row(
                children: [
                  Expanded(
                    child: _buildCategoryItem(
                      context: context,
                      title: 'Alive',
                      icon: Icons.check_circle_outline,
                      color: const Color(0xFF62FF8F),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RickmortyScreen(
                              filterStatus: 'alive',
                              filterTitle: 'Alive Characters',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildCategoryItem(
                      context: context,
                      title: 'Dead',
                      icon: Icons.cancel_outlined,
                      color: const Color(0xFFFF5A5A),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RickmortyScreen(
                              filterStatus: 'dead',
                              filterTitle: 'Dead Characters',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildCategoryItem(
                      context: context,
                      title: 'Humans',
                      icon: Icons.face_retouching_natural,
                      color: const Color(0xFF38BDF8),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RickmortyScreen(
                              filterSpecies: 'human',
                              filterTitle: 'Humans Only',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildCategoryItem(
                      context: context,
                      title: 'Aliens',
                      icon: Icons.rocket_launch_outlined,
                      color: const Color(0xFFC77DFF),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RickmortyScreen(
                              filterSpecies: 'alien',
                              filterTitle: 'Aliens Only',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Button: Random Teleport (Interactive Portal Gun)
              _buildCategoryCard(
                context: context,
                title: 'Dimensional Teleport',
                subtitle: 'Warp to a random character detail',
                icon: Icons.vpn_key_outlined,
                color: Colors.amber,
                onTap: () => _triggerTeleport(context, neonGreen),
              ),

              const SizedBox(height: 40),

              // Section: Developer Profile
              const Text(
                'Developer Profile',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // Developer Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.04),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: neonGreen.withOpacity(0.1),
                          child: const Icon(
                            Icons.person,
                            color: neonGreen,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Alyssa Wulan Sari',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Mobile App Developer',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: neonGreen.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 10),
                    _buildProfileItem(
                      Icons.school_outlined,
                      'Program',
                      'Pelatihan App Developer (Flutter)',
                    ),
                    const SizedBox(height: 8),
                    _buildProfileItem(
                      Icons.code_rounded,
                      'Academy',
                      'Latihan Flutter B6',
                    ),
                    const SizedBox(height: 8),
                    _buildProfileItem(
                      Icons.assignment_outlined,
                      'Assignment',
                      'Tugas 14: Integrasi Public API',
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildSkillTag('Flutter', neonGreen),
                        _buildSkillTag('Dart', neonGreen),
                        _buildSkillTag('REST API', neonGreen),
                        _buildSkillTag('Retrofit', neonGreen),
                        _buildSkillTag('Dio', neonGreen),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1C2333),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.04),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF10131A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.2), width: 1),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Color(0xFF8B92CC),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white54,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C2333),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF8B92CC), size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label: $value',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Color(0xFF8B92CC),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillTag(String skill, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Text(
        skill,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
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
}

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
