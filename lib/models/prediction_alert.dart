import 'service_metric.dart';

enum AlertSeverity { attention, high, critical }

class PredictionAlert {
  const PredictionAlert({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.severity,
    required this.title,
    required this.evidence,
    required this.confidence,
    required this.limitation,
  });

  final String id;
  final String serviceId;
  final String serviceName;
  final AlertSeverity severity;
  final String title;
  final String evidence;
  final int confidence;
  final String limitation;

  static List<PredictionAlert> fromMetrics(List<ServiceMetric> metrics) {
    final alerts = <PredictionAlert>[];
    for (final metric in metrics) {
      final severity = metric.demandRatio >= 1
          ? AlertSeverity.critical
          : metric.demandRatio >= 0.9 || metric.averageWaitHours >= 24
          ? AlertSeverity.high
          : metric.trend >= 0.15
          ? AlertSeverity.attention
          : null;
      if (severity == null) continue;

      final evidence =
          '${metric.demand} solicitações para capacidade de ${metric.capacity} '
          '(${(metric.demandRatio * 100).round()}%); espera média de '
          '${metric.averageWaitHours}h. Variação frente ao período anterior: '
          '${metric.trend >= 0 ? '+' : ''}${(metric.trend * 100).round()}%.';
      alerts.add(
        PredictionAlert(
          id: 'alert-${metric.id}',
          serviceId: metric.id,
          serviceName: metric.name,
          severity: severity,
          title: switch (severity) {
            AlertSeverity.critical => 'Demanda acima da capacidade',
            AlertSeverity.high => 'Pressão elevada no atendimento',
            AlertSeverity.attention => 'Demanda em aceleração',
          },
          evidence: evidence,
          confidence: severity == AlertSeverity.critical ? 91 : 84,
          limitation:
              'Estimativa demonstrativa baseada em dados sintéticos e regras '
              'simples. Não considera eventos locais, sazonalidade nem '
              'diferenças de registro entre bairros.',
        ),
      );
    }
    return alerts;
  }
}
