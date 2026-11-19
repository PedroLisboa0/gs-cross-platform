import 'package:flutter/foundation.dart';

import '../models/prediction_alert.dart';
import '../models/service_metric.dart';
import '../services/mock_city_service.dart';
import '../services/notification_service.dart';

class CityProvider extends ChangeNotifier {
  CityProvider({MockCityService? service})
    : _service = service ?? MockCityService();

  final MockCityService _service;
  CitySnapshot? _snapshot;
  bool _isLoading = false;
  Object? _error;

  CitySnapshot? get snapshot => _snapshot;
  bool get isLoading => _isLoading;
  Object? get error => _error;
  List<ServiceMetric> get services => _snapshot?.services ?? const [];
  List<PredictionAlert> get alerts => PredictionAlert.fromMetrics(services);

  int get totalDemand =>
      services.fold(0, (total, metric) => total + metric.demand);
  double get resolutionRate {
    if (services.isEmpty) return 0;
    final weighted = services.fold<double>(
      0,
      (total, metric) => total + metric.demand * metric.resolutionRate,
    );
    return weighted / totalDemand;
  }

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _snapshot = await _service.fetchSnapshot();
      await NotificationService.instance.showCriticalAlerts(alerts);
    } catch (error) {
      _error = error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
