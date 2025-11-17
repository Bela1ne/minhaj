import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/theme_service.dart';
import '../../../services/language_service.dart';
import '../../../services/notification_service.dart';
import '../../../services/prayer_service.dart';
import '../../../core/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _loading = true;

  Map<String, double> _offsets = {
    'Fajr': 0,
    'Dhuhr': 0,
    'Asr': 0,
    'Maghrib': 0,
    'Isha': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
    _loadOffsets();
  }

  /// 🔄 Charge les préférences utilisateur
  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool('adhan_notifications') ?? true;
    setState(() => _loading = false);
  }

  /// 💾 Sauvegarde la préférence de notification
  Future<void> _saveNotificationPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adhan_notifications', value);
  }

  /// 🔄 Charge les décalages horaires
  Future<void> _loadOffsets() async {
    for (final prayer in _offsets.keys) {
      final offset = await PrayerService.getOffset(prayer);
      _offsets[prayer] = offset.toDouble();
    }
    setState(() {});
  }

  /// 💾 Sauvegarde un décalage horaire
  Future<void> _saveOffset(String prayer, double value) async {
    await PrayerService.saveOffset(prayer, value.toInt());
    setState(() {
      _offsets[prayer] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final langService = Provider.of<LanguageService>(context);
    ThemeMode current = themeService.themeMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات', style: TextStyle(fontFamily: 'Amiri')),
        centerTitle: true,
        backgroundColor: AppColors.primaryDark,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // === SECTION THÈME ===
            const Text(
              '🎨 المظهر (Thème)',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Amiri',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildThemeCard(themeService, current),

            const SizedBox(height: 30),

            // === SECTION LANGUE ===
            const Text(
              '🌐 اللغة (Langue)',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Amiri',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildLanguageCard(langService),

            const SizedBox(height: 30),

            // === SECTION NOTIFICATIONS ===
            const Text(
              '🔔 التنبيهات (Notifications de prière)',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Amiri',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildNotificationsCard(),

            const SizedBox(height: 30),

            // === SECTION AJUSTEMENT DES HORAIRES ===
            const Text(
              '🕰️ تصحيح أوقات الصلاة (Correction horaires)',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Amiri',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildOffsetSliders(),

            const SizedBox(height: 30),

            // === TEST ADHAN ===
            ElevatedButton.icon(
              onPressed: () async {
                await NotificationService.showTestAdhan();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("🕒 Test Adhan dans 5 secondes."),
                  ),
                );
              },
              icon: const Icon(Icons.volume_up),
              label: const Text(
                "Tester l’Adhan maintenant",
                style: TextStyle(fontFamily: 'Amiri'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// === WIDGETS ===

  Widget _buildThemeCard(ThemeService themeService, ThemeMode current) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          RadioListTile<ThemeMode>(
            title: const Text('☀️ الوضع الفاتح (Clair)',
                style: TextStyle(fontFamily: 'Amiri')),
            value: ThemeMode.light,
            groupValue: current,
            onChanged: (mode) => themeService.setTheme(mode!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('🌙 الوضع الداكن (Sombre)',
                style: TextStyle(fontFamily: 'Amiri')),
            value: ThemeMode.dark,
            groupValue: current,
            onChanged: (mode) => themeService.setTheme(mode!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('🔄 تلقائي (Système)',
                style: TextStyle(fontFamily: 'Amiri')),
            value: ThemeMode.system,
            groupValue: current,
            onChanged: (mode) => themeService.setTheme(mode!),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(LanguageService langService) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          RadioListTile<String>(
            title:
            const Text('🇫🇷 Français', style: TextStyle(fontFamily: 'Amiri')),
            value: 'fr',
            groupValue: langService.locale.languageCode,
            onChanged: (lang) => langService.setLanguage(lang!),
          ),
          RadioListTile<String>(
            title:
            const Text('🇸🇦 العربية', style: TextStyle(fontFamily: 'Amiri')),
            value: 'ar',
            groupValue: langService.locale.languageCode,
            onChanged: (lang) => langService.setLanguage(lang!),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsCard() {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SwitchListTile(
        title: const Text(
          'تفعيل تنبيهات الأذان (Activer le rappel Adhan)',
          style: TextStyle(fontFamily: 'Amiri'),
        ),
        value: _notificationsEnabled,
        onChanged: (value) async {
          setState(() => _notificationsEnabled = value);
          await _saveNotificationPreference(value);

          if (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('🔔 Notifications Adhan activées.',
                    style: TextStyle(fontFamily: 'Amiri')),
              ),
            );
          } else {
            await NotificationService.cancelAllNotifications();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('🔕 Notifications Adhan désactivées.',
                    style: TextStyle(fontFamily: 'Amiri')),
              ),
            );
          }
        },
        secondary: Icon(
          _notificationsEnabled
              ? Icons.notifications_active
              : Icons.notifications_off,
          color: AppColors.accent,
        ),
      ),
    );
  }

  /// 🎚️ Correction horaires (Sliders)
  Widget _buildOffsetSliders() {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: _offsets.keys.map((prayer) {
            final value = _offsets[prayer] ?? 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${_getPrayerLabel(prayer)} : ${value > 0 ? '+' : ''}${value.toInt()} min",
                  style: const TextStyle(fontFamily: 'Amiri', fontSize: 16),
                ),
                Slider(
                  value: value,
                  min: -10,
                  max: 10,
                  divisions: 20,
                  activeColor: Colors.teal,
                  label: "${value.toInt()} min",
                  onChanged: (v) => _saveOffset(prayer, v),
                ),
                const Divider(thickness: 0.5),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getPrayerLabel(String key) {
    switch (key) {
      case 'Fajr':
        return 'الفجر';
      case 'Dhuhr':
        return 'الظهر';
      case 'Asr':
        return 'العصر';
      case 'Maghrib':
        return 'المغرب';
      case 'Isha':
        return 'العشاء';
      default:
        return key;
    }
  }
}
