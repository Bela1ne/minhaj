class AdhkarModel {
  // Correction: Ajout d'un ID pour pouvoir utiliser getDhikrById si nécessaire
  final int id;
  final String title;       // Le titre du chapitre (ex: أذكار الصباح والمساء)
  final List<DhikrItem> items; // La liste des invocations spécifiques dans ce chapitre

  const AdhkarModel({
    required this.id, // Ajout de l'ID ici
    required this.title,
    required this.items,
  });
}

class DhikrItem {
  final int number;          // Le numéro de l'invocation (ex: 1-)
  final String arabicText;   // Le texte de l'invocation
  final String source;       // Le rapporteur et le degré d'authenticité (ex: رواه البخاري)
  final int? repetition;     // Le nombre de répétitions (null si une fois)
  // Vous pourriez ajouter ici une traduction si vous voulez la chercher

  const DhikrItem({
    required this.number,
    required this.arabicText,
    required this.source,
    this.repetition,
  });

  String get repetitionText {
    // ... (Logique non modifiée)
    if (repetition == null || repetition! <= 1) {
      return '';
    } else if (repetition == 100) {
      return 'مائة مرة';
    } else if (repetition == 3) {
      return 'ثلاث مرات';
    } else if (repetition == 4) {
      return 'أربع مرات';
    } else if (repetition == 7) {
      return 'سبع مرات';
    } else if (repetition == 33) {
      return 'ثلاثاً وثلاثين';
    }
    return '$repetition مرات';
  }
}