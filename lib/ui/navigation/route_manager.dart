import 'package:flutter/material.dart';

import '../screens/home/home_screen.dart';
import '../screens/quran/quran_screen.dart';
import '../screens/adhkar/adhkar_screen.dart';
import '../screens/tasbih/tasbih_screen.dart';
import '../screens/prophets/prophets_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/books/books_screen.dart';   // ⬅️ IMPORTANT
import 'package:al_minhaj/ui/screens/prayers/prayer_screen.dart';
import 'package:al_minhaj/ui/screens/prayers/prayer_times_screen.dart';
import '../screens/qibla/qibla_screen.dart';

class RouteManager {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case '/quran':
        return MaterialPageRoute(builder: (_) => const QuranScreen());

      case '/qibla':
        return MaterialPageRoute(builder: (_) => const QiblaScreen());

      case '/prayers':
        return MaterialPageRoute(builder: (_) => const PrayerScreen());

      case '/prayer-times':
        return MaterialPageRoute(builder: (_) => const PrayerTimesScreen());

      case '/books':
        return MaterialPageRoute(builder: (_) => BooksScreen());

      case '/adhkar':
        return MaterialPageRoute(builder: (_) => const AdhkarScreen());

      case '/tasbih':
        return MaterialPageRoute(builder: (_) => const TasbihScreen());

      case '/prophets':
        return MaterialPageRoute(builder: (_) => const ProphetsScreen());

      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page non trouvée')),
          ),
        );
    }
  }
}
