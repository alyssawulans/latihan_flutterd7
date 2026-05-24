import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const AppDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryTeal = Color(0xFF0F4C43);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: primaryTeal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.blur_on_rounded, color: Colors.white, size: 40),
                SizedBox(height: 10),
                Text(
                  "RUAS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Katalog Kualitas Udara",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          AppDrawerTile(
            title: "Input Dashboard",
            icon: Icons.dashboard_outlined,
            isSelected: selectedIndex == 0,
            onTap: () {
              onItemTapped(0);
              Navigator.pop(context); // Mengganti context.pop() bawaan GoRouter
            },
          ),
          AppDrawerTile(
            title: "L1: List Parameter",
            icon: Icons.analytics_outlined,
            isSelected: selectedIndex == 1,
            onTap: () {
              onItemTapped(1);
              Navigator.pop(context);
            },
          ),
          AppDrawerTile(
            title: "L2: Map Stasiun",
            icon: Icons.location_on_outlined,
            isSelected: selectedIndex == 2,
            onTap: () {
              onItemTapped(2);
              Navigator.pop(context);
            },
          ),
          AppDrawerTile(
            title: "L3: Model Alat IoT",
            icon: Icons.developer_board_outlined,
            isSelected: selectedIndex == 3,
            onTap: () {
              onItemTapped(3);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

// --- WIDGET PENDUKUNG UNTUK ITEM MENU DRAWER ---
class AppDrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const AppDrawerTile({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryTeal = Color(0xFF0F4C43);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE0F2F1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? primaryTeal : Colors.black54),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? primaryTeal : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
