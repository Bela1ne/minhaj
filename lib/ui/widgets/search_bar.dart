// lib/ui/widgets/search_bar.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  const SearchBarWidget({
    super.key,
    required this.hintText,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white70),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              onTap: onTap,
              style: const TextStyle(color: Colors.white, fontFamily: 'Amiri'),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.white70, fontFamily: 'Amiri'),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}