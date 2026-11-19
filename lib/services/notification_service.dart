import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/prediction_alert.dart';

typedef NotificationServiceIdCallback = void Function(String serviceId);

class NotificationService {
  NotificationService._();

  static final instance = NotificationService._();

  static const _enabledKey = 'critical_notifications_enabled';
  static const _sentKey = 'critical_notifications_sent';
  static const _channelId = 'territorio_vivo_critical_alerts';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _notificationsEnabled = false;
  NotificationServiceIdCallback? _onServiceIdSelected;

  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> initialize({
    required NotificationServiceIdCallback onServiceIdSelected,
  }) async {
    _onServiceIdSelected = onServiceIdSelected;
    if (kIsWeb) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: androidSettings);
    await _plugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        final serviceId = response.payload;
        if (serviceId != null && serviceId.isNotEmpty) {
          _onServiceIdSelected?.call(serviceId);
        }
      },
    );

    final preferences = await SharedPreferences.getInstance();
    _notificationsEnabled =
        preferences.getBool(_enabledKey) ?? false;
  }

  Future<bool> requestPermission() async {
    if (kIsWeb) return false;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission();
    return granted ?? false;
  }

  Future<void> setEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_enabledKey, enabled);
  }

  Future<void> showCriticalAlerts(List<PredictionAlert> alerts) async {
    if (kIsWeb || !_notificationsEnabled) return;
    final criticalAlerts = alerts
        .where((alert) => alert.severity == AlertSeverity.critical)
        .toList();
    if (criticalAlerts.isEmpty) return;

    final preferences = await SharedPreferences.getInstance();
    final sent = preferences.getStringList(_sentKey) ?? const [];
    final sentIds = sent.toSet();
    var changed = false;

    for (final alert in criticalAlerts) {
      if (sentIds.contains(alert.id)) continue;
      const androidDetails = AndroidNotificationDetails(
        _channelId,
        'Alertas críticos',
        channelDescription:
            'Notificações locais para pressão crítica nos serviços.',
        importance: Importance.high,
        priority: Priority.high,
      );
      await _plugin.show(
        id: alert.id.hashCode & 0x7fffffff,
        title: 'Alerta crítico: ${alert.serviceName}',
        body: alert.title,
        notificationDetails:
            const NotificationDetails(android: androidDetails),
        payload: alert.serviceId,
      );
      sentIds.add(alert.id);
      changed = true;
    }
    if (changed) {
      await preferences.setStringList(_sentKey, sentIds.toList());
    }
  }
}
