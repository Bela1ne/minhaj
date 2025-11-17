import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/prayers/prayer_screen.dart';
import '../screens/qibla/qibla_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../../core/constants/app_colors.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const PrayerScreen(),
    const QiblaScreen(),
    const SettingsScreen(),
  ];

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          border: const Border(top: BorderSide(color: Colors.white12)),
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            currentIndex: _selectedIndex,
            onTap: _onTap,
            selectedItemColor: AppColors.accent,
            unselectedItemColor: Colors.white54,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
              BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Prière'),
              BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Qibla'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
            ],
          ),
        ),
      ),
    );
  }
}
