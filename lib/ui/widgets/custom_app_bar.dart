// lib/ui/widgets/custom_app_bar.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart'; // Import des styles

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final List<Widget>? actions;
  // Ajout d'une propriété pour déterminer s'il faut afficher le bouton de retour ou le menu
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.actions,
    this.automaticallyImplyLeading = true, // Par défaut, Flutter gère le retour
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Détermination de la couleur de texte en fonction du thème (ici, on suppose que AppColors.primaryDark est utilisé)
    // Nous utilisons un TextTheme pour récupérer les styles définis dans AppTheme
    final textStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
      color: AppColors.textLight, // Garder le texte clair sur la barre sombre
      fontWeight: FontWeight.bold,
      fontFamily: 'Amiri',
    ) ?? AppStyles.headline2.copyWith(color: AppColors.textLight, fontFamily: 'Amiri');

    // Vérifie si un bouton de retour est disponible/nécessaire.
    final bool canPop = Navigator.of(context).canPop();

    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primaryDark,

      // Gestion du widget principal à gauche (Leading)
      leading: automaticallyImplyLeading
          ? (canPop
          ? BackButton(color: AppColors.textLight) // Bouton de retour par défaut
          : IconButton( // Bouton de menu pour les écrans de niveau supérieur
        icon: const Icon(Icons.menu, color: AppColors.textLight),
        onPressed: onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
      ))
          : null, // Aucun widget leading

      title: Text(
        title,
        style: textStyle,
      ),
      centerTitle: true,
      actions: actions,
    );
  }
}