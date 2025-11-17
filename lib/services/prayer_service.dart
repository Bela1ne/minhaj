// lib/services/prayer_service.dart
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';


class PrayerService {
  /// 🕌 Calcule les horaires de prière avec offsets personnalisés
  Future<Map<String, DateTime>> getPrayerTimes(Position position, {DateTime? forDate}) async {
    final prefs = await SharedPreferences.getInstance();

    // 🔧 Offsets personnalisés (en minutes)
    final fajrOffset = prefs.getInt('offset_Fajr') ?? 0;
    final dhuhrOffset = prefs.getInt('offset_Dhuhr') ?? 0;
    final asrOffset = prefs.getInt('offset_Asr') ?? 0;
    final maghribOffset = prefs.getInt('offset_Maghrib') ?? 0;
    final ishaOffset = prefs.getInt('offset_Isha') ?? 0;

    final coordinates = Coordinates(position.latitude, position.longitude);
    final params = CalculationMethod.umm_al_qura.getParameters();
    params.madhab = Madhab.shafi;

    final date = forDate ?? DateTime.now();
    final prayerTimes = PrayerTimes(coordinates, DateComponents.from(date), params);

    return {
      'Fajr': prayerTimes.fajr.add(Duration(minutes: fajrOffset)),
      'Sunrise': prayerTimes.sunrise,
      'Dhuhr': prayerTimes.dhuhr.add(Duration(minutes: dhuhrOffset)),
      'Asr': prayerTimes.asr.add(Duration(minutes: asrOffset)),
      'Maghrib': prayerTimes.maghrib.add(Duration(minutes: maghribOffset)),
      'Isha': prayerTimes.isha.add(Duration(minutes: ishaOffset)),
    };
  }

  /// 💾 Sauvegarde un offset manuel pour une prière
  static Future<void> saveOffset(String prayerName, int offset) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('offset_$prayerName', offset);
  }

  /// 🔁 Récupère un offset manuel
  static Future<int> getOffset(String prayerName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('offset_$prayerName') ?? 0;
  }

  /// 🔔 Planifie les notifications Adhan pour les prières du jour (utilise NotificationService)
  Future<void> scheduleDailyAdhanNotifications(Position position) async {
    final prayers = await getPrayerTimes(position);

    // Supprimer anciennes notifications
    await NotificationService.cancelAllNotifications();
    for (final entry in prayers.entries) {
      final name = entry.key;
      final time = entry.value;
      if (name == 'Sunrise') continue;
      await NotificationService.schedulePrayerNotifications(
        prayerName: entry.key,
        prayerTime: entry.value,
      );

    }
  }

  /// ❌ Annule toutes les notifications Adhan
  static Future<void> cancelAllAdhanNotifications() async {
    await NotificationService.cancelAllNotifications();
  }
}
