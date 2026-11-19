import 'package:flutter_test/flutter_test.dart';
import 'package:territorio_vivo/models/prediction_alert.dart';
import 'package:territorio_vivo/models/service_metric.dart';

void main() {
  ServiceMetric metric({
    required int demand,
    required int capacity,
    required int waitHours,
    required int previousDemand,
  }) {
    return ServiceMetric(
      id: 'servico',
      name: 'Serviço de teste',
      category: 'Teste',
      demand: demand,
      previousDemand: previousDemand,
      capacity: capacity,
      averageWaitHours: waitHours,
      resolutionRate: 0.8,
      neighborhoods: const [],
    );
  }

  test('marca como crítico quando a demanda excede a capacidade', () {
    final alerts = PredictionAlert.fromMetrics([
      metric(demand: 105, capacity: 100, waitHours: 12, previousDemand: 90),
    ]);

    expect(alerts, hasLength(1));
    expect(alerts.single.severity, AlertSeverity.critical);
    expect(alerts.single.evidence, contains('105 solicitações'));
  });

  test('marca como atenção quando a demanda cresce pelo menos 15%', () {
    final alerts = PredictionAlert.fromMetrics([
      metric(demand: 120, capacity: 200, waitHours: 8, previousDemand: 100),
    ]);

    expect(alerts.single.severity, AlertSeverity.attention);
  });

  test('não gera alerta quando nenhuma regra é acionada', () {
    final alerts = PredictionAlert.fromMetrics([
      metric(demand: 70, capacity: 100, waitHours: 10, previousDemand: 75),
    ]);

    expect(alerts, isEmpty);
  });
}
