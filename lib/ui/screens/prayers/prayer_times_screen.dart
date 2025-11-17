import 'package:flutter/material.dart';
import 'package:al_minhaj/services/prayer_service.dart';
import 'package:al_minhaj/services/location_service.dart';
import 'package:al_minhaj/services/notification_service.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:al_minhaj/services/location_service.dart';


class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  final _prayerService = PrayerService();

  @override
  void initState() {
    super.initState();
    _initializeAdhanNotifications();
  }

  Future<void> _initializeAdhanNotifications() async {
    final position = await LocationService.getCurrentPosition();
    await _prayerService.scheduleDailyAdhanNotifications(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heures de prière'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text(
          'Notifications Adhan automatiques activées 🕌',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF0E0E16),
    );
  }
}
