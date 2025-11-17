// lib/ui/screens/prayers/prayer_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:al_minhaj/main.dart';
import 'package:al_minhaj/services/notification_service.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:al_minhaj/services/prayer_service.dart';
import 'package:al_minhaj/services/location_service.dart';
import 'package:al_minhaj/core/constants/app_colors.dart';
import '../../../../../main.dart'; // pour routeObserver si nécessaire

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> with RouteAware {
  final PrayerService _prayerService = PrayerService();
  Map<String, DateTime> _prayerTimes = {};
  bool _loading = true;
  HijriCalendar _hijriDate = HijriCalendar.now();
  DateTime _selectedDate = DateTime.now();
  late Position _position;

  // 📍 Localisation
  String _locationName = "Localisation inconnue";

  // 🕋 Compteur
  String _nextPrayerName = "";
  Duration _timeUntilNext = Duration.zero;
  Timer? _timer;

  // 🔔 Switch individuels
  Map<String, bool> _adhanEnabled = {
    'Fajr': true,
    'Dhuhr': true,
    'Asr': true,
    'Maghrib': true,
    'Isha': true,
  };

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  // RouteAware: s'abonner
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  // RouteAware: quand on revient sur cet écran depuis un autre
  @override
  void didPopNext() {
    // recharger les horaires (utile après modification des offsets dans Settings)
    _loadPrayerTimes();
  }

  @override
  void dispose() {
    _timer?.cancel();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<void> _initPage() async {
    final prefs = await SharedPreferences.getInstance();
    for (var name in _adhanEnabled.keys) {
      _adhanEnabled[name] = prefs.getBool('adhan_$name') ?? true;
    }

    try {
      _position = await LocationService.getCurrentPosition();
      await _getLocationName();
      await _loadPrayerTimes();
      _startCountdownTimer();
    } catch (e) {
      debugPrint("Erreur localisation : $e");
      setState(() => _loading = false);
    }
  }

  Future<void> _getLocationName() async {
    try {
      final placemarks =
      await placemarkFromCoordinates(_position.latitude, _position.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _locationName = "${place.locality ?? ''}, ${place.country ?? ''}".trim();
        });
      }
    } catch (e) {
      debugPrint("Erreur géocodage : $e");
    }
  }

  // IMPORTANT : utilise PrayerService.getPrayerTimes qui applique les offsets
  Future<void> _loadPrayerTimes() async {
    setState(() => _loading = true);

    final prayers = await _prayerService.getPrayerTimes(_position, forDate: _selectedDate);

    setState(() {
      _prayerTimes = prayers;
      _hijriDate = HijriCalendar.fromDate(_selectedDate);
      _updateNextPrayerFromMap(prayers);
      _loading = false;
    });
  }

  // Trouve la prochaine prière dans la map (du jour sélectionné)
  void _updateNextPrayerFromMap(Map<String, DateTime> prayers) {
    final now = DateTime.now();
    String? nextKey;
    DateTime? nextTime;

    // ordre d'apparition : Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha
    final order = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    for (final k in order) {
      final t = prayers[k];
      if (t != null && t.isAfter(now)) {
        nextKey = k;
        nextTime = t;
        break;
      }
    }

    // si aucune prière restante -> utiliser Fajr du lendemain
    if (nextKey == null) {
      final tomorrow = now.add(const Duration(days: 1));
      // calcule Fajr du lendemain en appliquant offsets
      _prayerService.getPrayerTimes(_position, forDate: tomorrow).then((tomorrowMap) {
        final fajrTomorrow = tomorrowMap['Fajr'];
        if (fajrTomorrow != null) {
          setState(() {
            _nextPrayerName = _getPrayerLabel('Fajr');
            _timeUntilNext = fajrTomorrow.difference(now);
          });
        }
      });
      return;
    }

    setState(() {
      _nextPrayerName = _getPrayerLabel(nextKey!);
      _timeUntilNext = nextTime!.difference(now);
    });
  }

  void _startCountdownTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeUntilNext.inSeconds > 0) {
        setState(() => _timeUntilNext -= const Duration(seconds: 1));
      } else {
        // la prière est arrivée => recharger pour passer à la suivante
        _loadPrayerTimes();
      }
    });
  }

  Future<void> _togglePrayerAdhan(String prayer, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _adhanEnabled[prayer] = value;
    });
    await prefs.setBool('adhan_$prayer', value);

    if (value) {
      final dt = _prayerTimes[prayer];
      if (dt != null) {
        await NotificationService.schedulePrayerNotifications(
          prayerName: prayer,
          prayerTime: dt,
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🔔 Adhan activé pour ${_getPrayerLabel(prayer)}")),
      );
    } else {
      await NotificationService.cancelAllNotifications();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🔕 Adhan désactivé pour ${_getPrayerLabel(prayer)}")),
      );
    }
  }

  void _nextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
      _loadPrayerTimes();
    });
  }

  void _previousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
      _loadPrayerTimes();
    });
  }

  bool _isFriday() => _selectedDate.weekday == DateTime.friday;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("🕌 أوقات الصلاة", style: TextStyle(fontFamily: 'Amiri')),
        centerTitle: true,
        backgroundColor: AppColors.primaryDark,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : Column(
        children: [
          // header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.tealAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Text('📍 $_locationName',
                    style: const TextStyle(fontSize: 16, color: Colors.white70)),
                const SizedBox(height: 10),
                Text('الصلاة القادمة : $_nextPrayerName',
                    style: const TextStyle(
                        fontSize: 22, color: Colors.white, fontFamily: 'Amiri')),
                const SizedBox(height: 6),
                Text('⏳ ${_formatDuration(_timeUntilNext)}',
                    style: const TextStyle(fontSize: 18, color: Colors.white70)),
              ],
            ),
          ),

          // hijri + navigation
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: _previousDay,
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
                Column(
                  children: [
                    Text(
                      DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(_selectedDate),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text("${_hijriDate.toFormat('dd MMMM yyyy')} هـ",
                        style: const TextStyle(color: Colors.white70)),
                  ],
                ),
                IconButton(
                    onPressed: _nextDay,
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white)),
              ],
            ),
          ),

          // liste prières
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: _prayerTimes.entries.map((entry) {
                final time = DateFormat('HH:mm').format(entry.value);
                final name = entry.key;

                return Card(
                  color: AppColors.primaryDark.withOpacity(0.85),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.white70),
                    title: Text(
                      _getPrayerLabel(name),
                      style: const TextStyle(fontFamily: 'Amiri', color: Colors.white, fontSize: 18),
                    ),
                    subtitle: Text(time, style: const TextStyle(color: Colors.white70)),
                    trailing: Switch(
                      value: _adhanEnabled[name] ?? true,
                      activeColor: Colors.tealAccent,
                      onChanged: (v) => _togglePrayerAdhan(name, v),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // test adhan
          ElevatedButton.icon(
            onPressed: () async {
              await NotificationService.showTestAdhan();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("🕒 Test Adhan dans 5 secondes")),
              );
            },
            icon: const Icon(Icons.volume_up),
            label: const Text("Tester l’Adhan", style: TextStyle(fontFamily: 'Amiri')),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) return '$h h $m min $s s';
    if (m > 0) return '$m min $s s';
    return '$s s';
  }

  String _getPrayerLabel(String key) {
    if (_isFriday() && key == 'Dhuhr') return 'الجمعة';
    switch (key) {
      case 'Fajr':
        return 'الفجر';
      case 'Sunrise':
        return 'الشروق';
      case 'Dhuhr':
        return 'الظهر';
      case 'Asr':
        return 'العصر';
      case 'Maghrib':
        return 'المغرب';
      case 'Isha':
        return 'العشاء';
      default:
        return key;
    }
  }
}
