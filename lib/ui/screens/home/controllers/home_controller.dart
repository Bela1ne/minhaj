import 'package:flutter/foundation.dart';

class HomeController extends ChangeNotifier {
  bool _isEditMode = false;

  bool get isEditMode => _isEditMode;

  // Vous devez définir ces listes pour que _openWidgetSelector fonctionne
  final List<String> availableWidgets = ['Date', 'Localisation', 'Prières', 'Adhkar'];
  final List<String> selectedWidgets = ['Date', 'Localisation', 'Prières'];

  void toggleEditMode() {
    _isEditMode = !_isEditMode;
    notifyListeners();
  }

  void updateSelectedWidgets(List<String> newSelection) {
    // Logique de mise à jour des widgets sélectionnés
    // ...
    notifyListeners();
  }
}