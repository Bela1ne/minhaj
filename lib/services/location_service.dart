import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {

  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérification du service
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Le service de localisation est désactivé. Veuillez l\'activer dans les paramètres de votre téléphone.');
    }

    // Demande et vérification de la permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('La permission de localisation est refusée. L\'application ne peut pas obtenir les horaires.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('La permission de localisation est définitivement refusée. Veuillez l\'activer dans les paramètres de l\'application.');
    }

    // Obtenir la position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 15),
    );
  }

  // 🎯 C'EST LE NOM DE LA MÉTHODE CORRECTE !
  static Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        final city = place.locality ?? place.administrativeArea;
        final country = place.country;

        if (city != null && country != null) {
          return '$city, $country';
        }
        return city ?? country ?? 'Adresse inconnue';
      }
      return 'Adresse non disponible';
    } catch (e) {
      // Échec du géocodage
      return 'Localisation introuvable';
    }
  }
}