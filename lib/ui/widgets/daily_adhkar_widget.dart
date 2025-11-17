// lib/ui/widgets/daily_adhkar_widget.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class DailyAdhkarWidget extends StatelessWidget {
  const DailyAdhkarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryDark.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.pinkAccent, size: 20),
              const SizedBox(width: 8),
              const Text(
                'أذكار اليوم',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Amiri',
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.pinkAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'اليوم',
                  style: TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 12,
                    fontFamily: 'Amiri',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Amiri',
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'التكرار: ',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontFamily: 'Amiri',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.pinkAccent.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '٣ مرات',
                  style: TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Amiri',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}