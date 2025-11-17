import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:al_minhaj/ui/screens/adhan/adhan_screen.dart';
import 'package:al_minhaj/main.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;
  static tz.Location? _localLocation;

  // ------------------------------------------------------------
  // INITIALISATION
  // ------------------------------------------------------------
  static Future<void> initialize(tz.Location localLocation) async {
    if (_isInitialized) return;

    _localLocation = localLocation;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null &&
            response.payload!.startsWith('prayer_time_')) {
          final prayerName = response.payload!.replaceFirst('prayer_time_', '');
          navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (_) => AdhanScreen(prayerName: prayerName),
          ));
        }
      },
    );

    _isInitialized = true;
    print('✅ NotificationService initialisé');
  }

  // ------------------------------------------------------------
  // DÉTAILS DES NOTIFICATIONS
  // ------------------------------------------------------------

  // 📖 Adhkar - son système
  static NotificationDetails get adhkarNotificationDetails {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'adhkar_channel',
        'Adhkar',
        channelDescription: 'Rappels matin et soir',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(
        sound: 'default',
      ),
    );
  }

  // 🔔 Rappel pré-adhan (5 min avant)
  static NotificationDetails get preAdhanNotificationDetails {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'prayer_reminder_channel',
        'Rappels Prières',
        channelDescription: 'Rappels 5 minutes avant les prières',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(
        sound: 'default',
      ),
    );
  }

  // 🕌 Adhan avec son personnalisé
  static NotificationDetails get adhanNotificationDetails {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'adhan_channel',
        'Adhan',
        channelDescription: 'Notifications Adhan pour les prières',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        sound: RawResourceAndroidNotificationSound('adhan'),
      ),
      iOS: DarwinNotificationDetails(
        sound: 'adhan.caf', // Assurez-vous d'avoir ce fichier dans iOS
      ),
    );
  }

  // ------------------------------------------------------------
  // ADHKAR (matin et soir) - Version corrigée
  // ------------------------------------------------------------
  static Future<void> scheduleAdhkarNotifications() async {
    if (!_isInitialized || _localLocation == null) {
      print('❌ NotificationService non initialisé pour Adhkar');
      return;
    }

    final now = tz.TZDateTime.now(_localLocation!);

    // --- 🌅 Adhkar du Matin (6h00) ---
    tz.TZDateTime morningTime = tz.TZDateTime(_localLocation!, now.year, now.month, now.day, 6, 0);

    // Si 6h00 est déjà passé aujourd'hui, planifier pour le lendemain
    if (morningTime.isBefore(now)) {
      morningTime = morningTime.add(const Duration(days: 1));
    }

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        50, // ID unique pour l'Adhkar du matin
        '🌅 Adhkar du matin',
        'N\'oubliez pas vos adhkar du matin',
        morningTime,
        adhkarNotificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // Répétition journalière
        payload: 'adhkar_morning',
      );
      print('✅ Adhkar du matin planifié pour ${morningTime.toString()} (récurrent)');
    } catch (e) {
      print('❌ Erreur planification Adhkar matin: $e');
    }

    // --- 🌙 Adhkar du Soir (18h00) ---
    tz.TZDateTime eveningTime = tz.TZDateTime(_localLocation!, now.year, now.month, now.day, 18, 0);

    // Si 18h00 est déjà passé aujourd'hui, planifier pour le lendemain
    if (eveningTime.isBefore(now)) {
      eveningTime = eveningTime.add(const Duration(days: 1));
    }

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        51, // ID unique pour l'Adhkar du soir
        '🌙 Adhkar du soir',
        'N\'oubliez pas vos adhkar du soir',
        eveningTime,
        adhkarNotificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // Répétition journalière
        payload: 'adhkar_evening',
      );
      print('✅ Adhkar du soir planifié pour ${eveningTime.toString()} (récurrent)');
    } catch (e) {
      print('❌ Erreur planification Adhkar soir: $e');
    }
  }

  // ------------------------------------------------------------
  // PLANIFICATION D'UNE PRIÈRE
  // ------------------------------------------------------------
  static Future<void> schedulePrayerNotifications({
    required String prayerName,
    required DateTime prayerTime,
  }) async {
    if (!_isInitialized || _localLocation == null) {
      print('❌ NotificationService non initialisé pour prières');
      return;
    }

    final tzNow = tz.TZDateTime.now(_localLocation!);
    final tzPrayerTime = tz.TZDateTime.from(prayerTime, _localLocation!);
    final reminderTime = tzPrayerTime.subtract(const Duration(minutes: 5));

    final prayerId = _getPrayerId(prayerName);
    final reminderId = prayerId + 10;

    try {
      // 🔔 Notification de rappel (5 min avant)
      if (reminderTime.isAfter(tzNow)) {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          reminderId,
          '⏰ Rappel $prayerName',
          'L\'adhan de $prayerName est dans 5 minutes',
          reminderTime,
          preAdhanNotificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: 'prayer_reminder_$prayerName',
        );
        print('✅ Rappel $prayerName planifié pour ${reminderTime.toString()}');
      }

      // 🕌 Notification Adhan avec son personnalisé
      if (tzPrayerTime.isAfter(tzNow)) {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          prayerId,
          '🕌 $prayerName',
          'C\'est l\'heure de la prière de $prayerName',
          tzPrayerTime,
          adhanNotificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: 'prayer_time_$prayerName',
        );
        print('✅ Adhan $prayerName planifié pour ${tzPrayerTime.toString()}');
      }
    } catch (e) {
      print('❌ Erreur planification $prayerName: $e');
    }
  }

  // ------------------------------------------------------------
  // PLANIFICATION DE TOUTES LES PRIÈRES
  // ------------------------------------------------------------
  static Future<void> scheduleAllPrayerNotifications(Map<String, DateTime> prayerTimes) async {
    if (!_isInitialized) {
      print('❌ NotificationService non initialisé');
      return;
    }

    print('🕌 Planification des notifications pour toutes les prières...');

    for (final entry in prayerTimes.entries) {
      await schedulePrayerNotifications(
        prayerName: entry.key,
        prayerTime: entry.value,
      );
    }

    print('✅ Toutes les prières planifiées');
  }

  // ------------------------------------------------------------
  // OUTILS
  // ------------------------------------------------------------
  static int _getPrayerId(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr': return 1;
      case 'dhuhr': return 2;
      case 'asr': return 3;
      case 'maghrib': return 4;
      case 'isha': return 5;
      default: return 0;
    }
  }

  static Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    print('🧹 Toutes les notifications annulées');
  }

  static Future<void> showTestAdhan() async {
    try {
      await _flutterLocalNotificationsPlugin.show(
        999,
        '🕌 Test Adhan',
        'Vous devriez entendre le son Adhan maintenant',
        adhanNotificationDetails,
        payload: 'test_adhan',
      );
      print('✅ Test Adhan lancé');
    } catch (e) {
      print('❌ Erreur test Adhan: $e');
    }
  }

  static Future<void> showTestNotification() async {
    try {
      await _flutterLocalNotificationsPlugin.show(
        998,
        '🔔 Test Notification',
        'Ceci est une notification système simple',
        preAdhanNotificationDetails,
        payload: 'test_notif',
      );
      print('✅ Test notification lancé');
    } catch (e) {
      print('❌ Erreur test notification: $e');
    }
  }

  // ------------------------------------------------------------
  // RÉINITIALISATION
  // ------------------------------------------------------------
  static Future<void> reinitialize(tz.Location localLocation) async {
    _isInitialized = false;
    _localLocation = null;
    await initialize(localLocation);
  }

  // ------------------------------------------------------------
  // ÉTAT DU SERVICE
  // ------------------------------------------------------------
  static bool get isInitialized => _isInitialized;
  static tz.Location? get localLocation => _localLocation;

  // ------------------------------------------------------------
  // VÉRIFICATION DES CANAUX
  // ------------------------------------------------------------
  static Future<void> createNotificationChannels() async {
    // Canal pour Adhkar
    const AndroidNotificationChannel adhkarChannel = AndroidNotificationChannel(
      'adhkar_channel',
      'Adhkar',
      description: 'Rappels matin et soir',
      importance: Importance.high,
    );

    // Canal pour rappels de prières
    const AndroidNotificationChannel reminderChannel = AndroidNotificationChannel(
      'prayer_reminder_channel',
      'Rappels Prières',
      description: 'Rappels 5 minutes avant les prières',
      importance: Importance.high,
    );

    // Canal pour Adhan
    const AndroidNotificationChannel adhanChannel = AndroidNotificationChannel(
      'adhan_channel',
      'Adhan',
      description: 'Notifications Adhan pour les prières',
      importance: Importance.high,
    );

    // Créer les canaux
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(adhkarChannel);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(reminderChannel);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(adhanChannel);

    print('✅ Canaux de notification créés');
  }
}