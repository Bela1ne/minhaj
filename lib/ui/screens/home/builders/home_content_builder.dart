import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
// Importez ici tous les widgets que vous voulez afficher dynamiquement (DateWidget, LocalisationWidget, etc.)

class HomeContentBuilder {
  static Widget buildContent(HomeController controller) {
    // 1. Si le mode édition est actif, vous voulez peut-être un conteneur Draggable
    if (controller.isEditMode) {
      // Retourner un DraggableWidgetContainer qui utilise controller.selectedWidgets
      // ...
    }

    // 2. En mode affichage normal, retournez une liste simple
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: controller.selectedWidgets.map((widgetName) {
        // Logique pour mapper le nom du widget à la classe réelle
        return _mapWidgetNameToComponent(widgetName);
      }).toList(),
    );
  }

  // Exemple simple de mappage
  static Widget _mapWidgetNameToComponent(String name) {
    // IMPORTANT : Vous devez remplacer ceci par vos vrais widgets
    switch (name) {
      case 'Date':
        return const Text('Date Widget Placeholder', style: TextStyle(color: Colors.white));
      case 'Localisation':
        return const Text('Localisation Widget Placeholder', style: TextStyle(color: Colors.white));
      case 'Prières':
        return const Text('Prières Widget Placeholder', style: TextStyle(color: Colors.white));
      default:
        return const SizedBox.shrink();
    }
  }
}