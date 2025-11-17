import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:al_minhaj/core/constants/app_colors.dart';

class AdhanScreen extends StatefulWidget {
  final String prayerName;

  const AdhanScreen({super.key, required this.prayerName});

  @override
  State<AdhanScreen> createState() => _AdhanScreenState();
}

class _AdhanScreenState extends State<AdhanScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _playAdhan();
  }

  Future<void> _playAdhan() async {
    try {
      await _audioPlayer.play(AssetSource('audio/adhan.mp3'));
    } catch (e) {
      debugPrint("Erreur audio : $e");
    }
  }

  Future<void> _stopAdhan() async {
    await _audioPlayer.stop();
    setState(() => _isPlaying = false);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/mosque_background.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.5)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.mosque, color: Colors.white, size: 80),
                const SizedBox(height: 20),
                Text(
                  "🕋 ${widget.prayerName}",
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "C'est l’heure de la prière",
                  style: TextStyle(
                      fontFamily: 'Amiri', fontSize: 20, color: Colors.white70),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () async {
                    await _stopAdhan();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.stop, color: Colors.white),
                  label: const Text(
                    "Arrêter l’Adhan",
                    style: TextStyle(fontFamily: 'Amiri', color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 20),
                if (_isPlaying)
                  const Text("🔊 Lecture en cours...",
                      style: TextStyle(color: Colors.white70))
                else
                  const Text("🔕 Adhan arrêté",
                      style: TextStyle(color: Colors.redAccent)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
