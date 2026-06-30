import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/day_36/models/profile_response.dart';
import 'package:intl/intl.dart';

class DetailUserView extends StatelessWidget {
  final Data profileData;

  const DetailUserView({Key? key, required this.profileData}) : super(key: key);

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd MMMM yyyy').format(date);
  }

  String? _getSanitizedImageUrl(String? url) {
    if (url == null) return null;
    String cleaned = url;
    cleaned = cleaned.replaceAll('http://127.0.0.1:8000', 'https://appabsensi.mobileprojp.com');
    cleaned = cleaned.replaceAll('http://localhost:8000', 'https://appabsensi.mobileprojp.com');
    cleaned = cleaned.replaceAll('http://localhost', 'https://appabsensi.mobileprojp.com');
    return cleaned;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF4F8FB);
    final Color cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF1A2E44);
    final Color subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Detail Informasi',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: cardColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
        child: Column(
          children: [
            // User Brief Overview Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : Colors.white.withOpacity(0.9),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Row(
                children: [
                  Hero(
                    tag: 'profile_photo_${profileData.id}',
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF4F8FB),
                      backgroundImage: _getSanitizedImageUrl(profileData.profilePhotoUrl) != null
                          ? NetworkImage("${_getSanitizedImageUrl(profileData.profilePhotoUrl!)}?v=${DateTime.now().millisecondsSinceEpoch}")
                          : null,
                      child: profileData.profilePhotoUrl == null
                          ? Icon(Icons.person, size: 36, color: Colors.grey.shade400)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profileData.name ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profileData.email ?? '-',
                          style: TextStyle(
                            fontSize: 13,
                            color: subTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              title: "Informasi Personal",
              icon: Icons.assignment_ind_outlined,
              cardColor: cardColor,
              textColor: textColor,
              subTextColor: subTextColor,
              isDark: isDark,
              children: [
                _buildRow("User ID", profileData.id?.toString() ?? '-', textColor, subTextColor),
                _buildDivider(isDark),
                _buildRow(
                  "Jenis Kelamin",
                  profileData.jenisKelamin == 'L'
                      ? 'Laki-Laki'
                      : (profileData.jenisKelamin == 'P' ? 'Perempuan' : '-'),
                  textColor,
                  subTextColor,
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            _buildSection(
              title: "Informasi Batch",
              icon: Icons.layers_outlined,
              cardColor: cardColor,
              textColor: textColor,
              subTextColor: subTextColor,
              isDark: isDark,
              children: [
                _buildRow("Batch Ke", profileData.batch?.batchKe ?? '-', textColor, subTextColor),
                _buildDivider(isDark),
                _buildRow("Tanggal Mulai", _formatDate(profileData.batch?.startDate), textColor, subTextColor),
                _buildDivider(isDark),
                _buildRow("Tanggal Selesai", _formatDate(profileData.batch?.endDate), textColor, subTextColor),
              ],
            ),
            
            const SizedBox(height: 20),
            _buildSection(
              title: "Informasi Pelatihan",
              icon: Icons.menu_book_rounded,
              cardColor: cardColor,
              textColor: textColor,
              subTextColor: subTextColor,
              isDark: isDark,
              children: [
                _buildRow("Nama Pelatihan", profileData.training?.title ?? '-', textColor, subTextColor),
                _buildDivider(isDark),
                _buildRow(
                  "Durasi",
                  profileData.training?.duration != null
                      ? "${profileData.training?.duration} Jam"
                      : '-',
                  textColor,
                  subTextColor,
                ),
                _buildDivider(isDark),
                _buildRow(
                  "Jumlah Peserta",
                  profileData.training?.participantCount != null
                      ? "${profileData.training?.participantCount} Orang"
                      : '-',
                  textColor,
                  subTextColor,
                ),
                _buildDivider(isDark),
                _buildRow("Deskripsi", profileData.training?.description ?? '-', textColor, subTextColor),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color cardColor,
    required Color textColor,
    required Color subTextColor,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF0D9488)),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : Colors.white.withOpacity(0.9),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value, Color textColor, Color subTextColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: subTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
                height: 1.4,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        height: 1,
        thickness: 1,
        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
      ),
    );
  }
}
