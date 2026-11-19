import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/notification_service.dart';

enum AppearanceMode { light, dark, highContrast }

class PreferencesProvider extends ChangeNotifier {
  PreferencesProvider({NotificationService? notifications})
    : _notifications = notifications ?? NotificationService.instance;

  static const _themeKey = 'appearance_mode';
  static const _notificationsKey = 'critical_notifications_enabled';

  final NotificationService _notifications;
  AppearanceMode _appearanceMode = AppearanceMode.light;
  bool _notificationsEnabled = false;

  AppearanceMode get appearanceMode => _appearanceMode;
  bool get notificationsEnabled => _notificationsEnabled;

  ThemeMode get themeMode => switch (_appearanceMode) {
    AppearanceMode.light => ThemeMode.light,
    AppearanceMode.dark => ThemeMode.dark,
    AppearanceMode.highContrast => ThemeMode.light,
  };

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final storedTheme = preferences.getString(_themeKey);
    _appearanceMode = AppearanceMode.values.firstWhere(
      (mode) => mode.name == storedTheme,
      orElse: () => AppearanceMode.light,
    );
    _notificationsEnabled =
        preferences.getBool(_notificationsKey) ??
        _notifications.notificationsEnabled;
    notifyListeners();
  }

  Future<void> setAppearanceMode(AppearanceMode mode) async {
    _appearanceMode = mode;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_themeKey, mode.name);
  }

  Future<bool> setNotificationsEnabled(bool enabled) async {
    if (enabled && !kIsWeb) {
      enabled = await _notifications.requestPermission();
    } else if (kIsWeb) {
      enabled = false;
    }
    _notificationsEnabled = enabled;
    await _notifications.setEnabled(enabled);
    notifyListeners();
    return enabled;
  }
}
