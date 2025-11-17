import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notifications_enabled') ?? false;
  }

  static Future<void> setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
  }

  static Future<void> saveNotificationTime(String time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notification_time', time);
  }

  static Future<String> getNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('notification_time') ?? '06:00';
  }

  static Future<void> disableNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', false);
  }
}
