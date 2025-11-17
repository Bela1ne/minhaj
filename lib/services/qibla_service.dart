import 'dart:math' show atan2, sin, cos, tan, pi;
import 'package:geolocator/geolocator.dart';

class QiblaService {
  static const _kaabaLat = 21.4225;  // Latitude de la Kaaba
  static const _kaabaLon = 39.8262;  // Longitude de la Kaaba

  /// 🔹 Calcule la direction de la Qibla (en degrés)
  static double calculateQiblaDirection(double lat, double lon) {
    final phi1 = lat * pi / 180;
    final phi2 = _kaabaLat * pi / 180;
    final deltaLon = (_kaabaLon - lon) * pi / 180;

    final y = sin(deltaLon);
    final x = cos(phi1) * tan(phi2) - sin(phi1) * cos(deltaLon);

    final qibla = atan2(y, x);
    final bearing = (qibla * 180 / pi + 360) % 360;

    return bearing;
  }

  /// 🌍 Récupère la position GPS actuelle avec vérification des permissions
  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  /// 🔁 Fournit un angle corrigé (compense les dépassements 0–360°)
  static double normalizeAngle(double angle) {
    return (angle + 360) % 360;
  }
}
