// lib/ui/widgets/prayer_times_widget.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../components/prayer_time_card.dart'; // Assurez-vous d'avoir ce composant

// Définition du composant PrayerTimesWidget
class PrayerTimesWidget extends StatelessWidget {
  // Données reçues du HomeController
  final Map<String, DateTime> prayerTimes;
  final String? currentPrayer;
  final bool isLoading;
  final bool isRefreshing;

  // Fonctions de logique reçues du HomeController
  final bool Function(String name) isCurrentPrayer;
  final bool Function(String name, DateTime time) isNextPrayer;
  final String Function() getNextPrayerName;
  final String Function() getTimeUntilNextPrayer;

  const PrayerTimesWidget({
    super.key,
    required this.prayerTimes,
    required this.currentPrayer,
    required this.isLoading,
    required this.isRefreshing,
    required this.isCurrentPrayer,
    required this.isNextPrayer,
    required this.getNextPrayerName,
    required this.getTimeUntilNextPrayer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryDark.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(), // En-tête (prière actuelle et temps restant)
          const SizedBox(height: 16),
          _buildPrayerList(), // Liste horizontale des prières
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final timeUntilNext = getTimeUntilNextPrayer();

    return Column(
      children: [
        // Ligne Titre + Indicateur de rafraîchissement
        Row(
          children: [
            const Icon(Icons.access_time, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            const Text(
              'أوقات الصلاة اليوم',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Amiri',
              ),
            ),
            const Spacer(),
            // Indicateur de chargement
            if (isRefreshing)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
          ],
        ),

        // Temps jusqu'à la prochaine prière
        if (currentPrayer != null && timeUntilNext.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer, color: Colors.tealAccent, size: 14),
                const SizedBox(width: 4),
                Text(
                  'متبقي حتى ${getNextPrayerName()}: $timeUntilNext',
                  style: const TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 12,
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPrayerList() {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(color: Colors.teal),
        ),
      );
    }

    if (prayerTimes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'لا توجد بيانات للعرض',
          style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Amiri'),
        ),
      );
    }

    // Affichage des cartes de prière en défilement horizontal
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: prayerTimes.entries.map((entry) {
          // Utilisation du PrayerTimeCard qui doit être défini séparément
          return PrayerTimeCard(
            prayerName: entry.key,
            prayerTime: entry.value,
            isCurrentPrayer: isCurrentPrayer(entry.key),
            isNextPrayer: isNextPrayer(entry.key, entry.value),
          );
        }).toList(),
      ),
    );
  }
}