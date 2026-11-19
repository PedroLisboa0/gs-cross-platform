import 'package:material_ui/material_ui.dart';

import '../models/prediction_alert.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_widgets.dart';

class AlertDetailScreen extends StatelessWidget {
  const AlertDetailScreen({super.key, required this.alert});

  final PredictionAlert alert;

  @override
  Widget build(BuildContext context) {
    final severityColor = switch (alert.severity) {
      AlertSeverity.attention => AppTheme.amber,
      AlertSeverity.high => const Color(0xFF9A4A00),
      AlertSeverity.critical => AppTheme.red,
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe do alerta')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AlertSeverityChip(severity: alert.severity),
                      const SizedBox(width: 8),
                      Text(
                        alert.serviceName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    alert.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 18),
                  ContentCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle('Evidências observadas'),
                        const SizedBox(height: 9),
                        Text(alert.evidence),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  ContentCard(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 76,
                          height: 76,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value: alert.confidence / 100,
                                strokeWidth: 7,
                                backgroundColor: const Color(0xFFE8EFEB),
                                color: severityColor,
                              ),
                              Center(
                                child: Text(
                                  '${alert.confidence}%',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Confiança indicativa',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Valor didático da regra aplicada; não é '
                                'uma probabilidade estatística validada.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  ContentCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle('Limitações'),
                        const SizedBox(height: 8),
                        Text(alert.limitation),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF2D8),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE7D09E)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.policy_outlined, color: AppTheme.amber),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Este alerta serve como apoio à análise. A decisão '
                            'final deve ser tomada por uma pessoa responsável, '
                            'considerando o contexto local.',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
