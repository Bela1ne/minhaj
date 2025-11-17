// lib/ui/widgets/date_widget.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hijri_calendar/hijri_calendar.dart';
import '../../core/constants/app_colors.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({super.key});

  // Récupère la date Grégorienne formatée en français
  String _getGregorianDate() {
    return DateFormat('EEEE d MMMM y', 'fr').format(DateTime.now());
  }

  // Récupère la date Hijri formatée en Arabe
  String _getHijriDate() {
    try {
      final hijriDate = HijriCalendar.now();
      // Le format doit être 'dd MMMM yyyy' pour afficher le nom du mois en arabe si possible.
      // Si la librairie Hijri ne supporte pas nativement l'arabe, nous affichons le format par défaut.
      return '${hijriDate.hDay} ${hijriDate.hMonth} ${hijriDate.hYear} هـ';
    } catch (e) {
      debugPrint("Erreur Hijri: $e");
      return 'Date Islamique';
    }
  }

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Date Grégorienne (Miladi)
          Expanded(
            child: _buildDateSection(
              icon: Icons.calendar_today,
              date: _getGregorianDate(),
              color: Colors.tealAccent,
            ),
          ),

          // Séparateur vertical
          Container(
            height: 30,
            width: 1,
            color: Colors.white.withOpacity(0.3),
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),

          // Date Hijri (Islamique)
          Expanded(
            child: _buildDateSection(
              icon: Icons.mosque,
              date: _getHijriDate(),
              color: Colors.white70,
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection({
    required IconData icon,
    required String date,
    required Color color,
    TextDirection? textDirection,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            date,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontFamily: 'Amiri',
            ),
            textAlign: TextAlign.center,
            textDirection: textDirection,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}