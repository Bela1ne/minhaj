import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../services/location_service.dart';

class LocationWidget extends StatefulWidget {
  // 💡 Laissez-le gérer son propre état pour l'actualisation manuelle
  const LocationWidget({super.key});

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  // 🗺️ Texte par défaut en Arabe
  String _locationName = 'جاري التحديد...';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 🚀 Chargement initial
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      // Optionnel : Réinitialiser le texte de localisation pendant le chargement
      _locationName = 'جاري التحديد...';
    });

    try {
      // 1. Obtenir la position
      final position = await LocationService.getCurrentPosition();

      // 2. Obtenir l'adresse (on suppose que getLocationName est l'équivalent)
      // J'utilise le nom de la méthode que vous aviez probablement l'intention d'utiliser
      // (Si elle n'existe pas, elle devrait être dans lib/services/location_service.dart)
      final address = await LocationService.getLocationName(position);

      setState(() {
        _locationName = address;
      });

    } catch (e) {
      debugPrint('Erreur de localisation: $e'); // Utilisation de debugPrint pour le log

      setState(() {
        _locationName = 'غير متوفر - انقر للتحديث';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🖱️ Utiliser le bouton d'actualisation pour le onTap, ou l'ensemble du Container
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryDark.withOpacity(0.85), // Utilisé AppColors.primaryDark pour plus de cohérence
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        // Utiliser MainAxisAlignment.start si l'arabe est RTL (Right To Left)
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5, // Légèrement plus épais
              color: Colors.tealAccent,
            ),
          )
              : const Icon(Icons.location_on, color: Colors.tealAccent, size: 20),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // RTL
              children: [
                const Text(
                  'موقعك الحالي',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontFamily: 'Amiri',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _locationName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16, // Légèrement plus grand
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Amiri',
                  ),
                  maxLines: 1, // Une seule ligne est souvent mieux pour les titres
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl, // ➡️ Définir la direction pour l'arabe
                ),
              ],
            ),
          ),

          // Bouton d'actualisation
          IconButton(
            icon: _isLoading
                ? const Icon(Icons.refresh, color: Colors.white54, size: 18) // Icone grisée si loading
                : const Icon(Icons.refresh, color: Colors.teal, size: 18),
            onPressed: _isLoading ? null : _getCurrentLocation,
          ),
        ],
      ),
    );
  }
}