import '../models/adhkar_model.dart';
import '../data/adhkar_data.dart';

class AdhkarService {

  // 🎯 MÉTHODE REQUISE PAR ADHKARSCREEN : Récupère tous les chapitres (AdhkarModel)
  List<AdhkarModel> getAllChapters() {
    return AdhkarData.getAllAdhkar();
  }

  // Méthode utilitaire pour obtenir TOUTES les invocations (utilisée pour la recherche)
  List<DhikrItem> getAllDhikrItems() {
    return getAllChapters().expand((chapter) => chapter.items).toList();
  }

  // Méthode de recherche : cherche DANS toutes les invocations (DhikrItem)
  List<DhikrItem> searchDhikr(String query) {
    // ... (Logique de recherche des DhikrItem)
    final allDhikr = getAllDhikrItems();
    if (query.isEmpty) return allDhikr;

    final lowerQuery = query.toLowerCase();

    return allDhikr.where((dhikr) {
      if (dhikr.arabicText.contains(query)) return true;
      if (dhikr.source.toLowerCase().contains(lowerQuery)) return true;

      return false;
    }).toList();
  }
}