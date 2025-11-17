import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
// Les imports doivent pointer vers vos fichiers (vérifiez les chemins ../../../)
import '../../../data/adhkar_data.dart';
import '../../../models/adhkar_model.dart';
import '../../../core/constants/app_colors.dart';

class AdhkarDetailScreen extends StatelessWidget {
  // L'écran de détail DOIT recevoir l'ID du chapitre à afficher
  final int chapterId;

  const AdhkarDetailScreen({super.key, required this.chapterId});

  // Méthode de construction d'un DhikrItem (inchangée, car elle est correcte)
  Widget _buildDhikrItem(BuildContext context, DhikrItem dhikr) {
    // ... (Code de _buildDhikrItem tel que vous l'avez fourni précédemment)
    // J'omets le corps ici pour la concision, mais il reste le même.
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            dhikr.arabicText,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Amiri',
              height: 1.8,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divider(height: 20, thickness: 0.5, color: Colors.grey),
          // ... (Suite du widget)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (dhikr.repetitionText.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    dhikr.repetitionText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              const Spacer(),
              Text(
                dhikr.source,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fade(duration: 400.ms).slideX(
      begin: -0.1,
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Récupérer le chapitre unique en utilisant l'ID
    final AdhkarModel? chapter = AdhkarData.getAllAdhkar()
        .firstWhere((c) => c.id == chapterId, orElse: () => null as AdhkarModel);

    // Gérer le cas où l'ID n'est pas trouvé
    if (chapter == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('خطأ')),
        body: const Center(child: Text('عفوا، لم يتم العثور على هذا الباب. (Chapter not found)')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryDark,
        // Le titre de l'AppBar affiche le nom du chapitre
        title: Text(
          chapter.title,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Amiri',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Afficher le titre du chapitre (Répétition si nécessaire, ou on peut le laisser dans l'AppBar)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                chapter.title,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Amiri',
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            const Divider(thickness: 2, height: 10, color: AppColors.primaryDark),
            const SizedBox(height: 8),

            // Afficher uniquement les invocations (DhikrItem) de CE chapitre
            ...chapter.items.map((dhikr) => _buildDhikrItem(context, dhikr)).toList(),
          ],
        ),
      ),
    );
  }
}