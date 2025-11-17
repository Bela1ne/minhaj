import 'package:flutter/material.dart';

class WidgetSelectorDialog extends StatelessWidget {
  final List<String> availableWidgets;
  final List<String> selectedWidgets;
  final Function(List<String>) onWidgetsUpdated;

  const WidgetSelectorDialog({
    super.key,
    required this.availableWidgets,
    required this.selectedWidgets,
    required this.onWidgetsUpdated,
  });

  @override
  Widget build(BuildContext context) {
    // Ce widget gère l'état interne des sélections avant d'appeler onWidgetsUpdated
    // Un StatefulBuilder ou un StatefulWidget serait plus approprié ici pour gérer la sélection

    // Pour l'instant, c'est un placeholder simple pour résoudre l'erreur
    return AlertDialog(
      title: const Text('Sélectionner les widgets'),
      content: const Text('Ici, vous aurez une liste de cases à cocher.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fermer'),
        ),
      ],
    );
  }
}