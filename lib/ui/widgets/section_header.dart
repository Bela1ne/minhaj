// lib/ui/widgets/section_header.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final Color? iconColor;

  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.trailing,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Amiri',
            ),
          ),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}