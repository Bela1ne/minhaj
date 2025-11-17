import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CustomFAB extends StatelessWidget {
  final VoidCallback onEditPressed;
  final bool isEditMode;

  const CustomFAB({
    super.key,
    required this.onEditPressed,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onEditPressed,
      backgroundColor: isEditMode ? Colors.redAccent : AppColors.primaryDark,
      child: Icon(
        isEditMode ? Icons.check : Icons.edit,
        color: AppColors.textLight,
      ),
    );
  }
}