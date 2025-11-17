import 'dart:async';
import 'dart:math' show atan2, sin, cos, tan, pi;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen>
    with SingleTickerProviderStateMixin {
  double? qiblaDirection;
  double? heading;
  bool loading = true;
  String cityName = "Localisation...";
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  double _previousAngle = 0.0;

  StreamSubscription<CompassEvent>? _compassSubscription;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _getLocation();
    _listenToCompass();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _compassSubscription?.cancel();
    super.dispose();
  }

  /// 🌍 Récupération position + nom de la ville
  Future<void> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => loading = false);
        return;
      }

      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => loading = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      qiblaDirection = _calculateQiblaDirection(
        position.latitude,
        position.longitude,
      );

      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      String? city = placemarks.isNotEmpty
          ? (placemarks.first.locality?.isNotEmpty == true
          ? placemarks.first.locality
          : placemarks.first.subAdministrativeArea)
          : null;

      if (!mounted) return;

      setState(() {
        cityName = city ?? "Position inconnue";
        loading = false;
      });
    } catch (e) {
      debugPrint("Erreur GPS: $e");
      if (!mounted) return;
      setState(() {
        cityName = "Erreur de localisation";
        loading = false;
      });
    }
  }

  /// 🧭 Suivi du capteur de boussole
  void _listenToCompass() {
    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (event.heading != null && mounted) {
        setState(() {
          heading = event.heading;
        });
      }
    });
  }

  /// 🕋 Calcul direction Qibla
  double _calculateQiblaDirection(double lat, double lon) {
    const kaabaLat = 21.4225;
    const kaabaLon = 39.8262;

    final phi1 = lat * pi / 180;
    final phi2 = kaabaLat * pi / 180;
    final deltaLon = (kaabaLon - lon) * pi / 180;

    final y = sin(deltaLon);
    final x = cos(phi1) * tan(phi2) - sin(phi1) * cos(deltaLon);
    final qibla = atan2(y, x);
    return (qibla * 180 / pi + 360) % 360;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E16),
      appBar: AppBar(
        title: const Text(
          '🕋 اتجاه القبلة',
          style: TextStyle(fontFamily: 'Amiri'),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // ✅ Bouton retour
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : qiblaDirection == null
          ? const Center(
        child: Text(
          "Impossible de déterminer la direction",
          style: TextStyle(color: Colors.white),
        ),
      )
          : _buildCompass(context),
    );
  }

  Widget _buildCompass(BuildContext context) {
    if (heading == null) {
      return const Center(
        child: Text(
          "Détermination en cours...",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final rotationAngle =
        ((qiblaDirection ?? 0) - (heading ?? 0)) * (pi / 180);

    _rotationAnimation = Tween<double>(
      begin: _previousAngle,
      end: rotationAngle,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward(from: 0);
    _previousAngle = rotationAngle;

    final size = MediaQuery.of(context).size.width * 0.85;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 20),
          Column(
            children: [
              Text(
                cityName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Amiri',
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.circle, size: 10, color: Colors.greenAccent),
                  SizedBox(width: 6),
                  Text(
                    "Bonne précision",
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                ],
              ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value,
                    alignment: Alignment.center,
                    child: child,
                  );
                },
                child: Image.asset(
                  'assets/images/compass_full.png',
                  width: size,
                  fit: BoxFit.contain,
                ),
              ),
              Image.asset(
                'assets/images/kaaba_icon.png',
                height: 60,
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/kaaba_bottom.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              const Text(
                "Direction de la Qibla",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}
