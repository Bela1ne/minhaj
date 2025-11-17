// lib/ui/widgets/prayer_times_widget.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../components/prayer_time_card.dart'; // Assurez-vous d'avoir ce composant

class PrayerTimesWidget extends StatelessWidget {
  final Map<String, DateTime> prayerTimes;
  final String? currentPrayer;
  final bool isLoading;
  final bool isRefreshing;

  // Fonctions pour la logique des prières (peuvent être extraites du controller si complexes)
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
        // ... (Style de boîte)
      ),
      child: Column(
        children: [
          // En-tête (prière actuelle et temps restant)
          _buildHeader(),

          const SizedBox(height: 16),

          // Liste horizontale des prières
          _buildPrayerList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    // Le code pour afficher le nom de la prière actuelle et le décompte
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
            if (isRefreshing)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
          ],
        ),

        // Temps jusqu'à la prochaine prière (si disponible)
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