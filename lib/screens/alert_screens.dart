import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../models/prediction_alert.dart';
import '../providers/city_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_widgets.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CityProvider>(
      builder: (context, city, _) {
        if (city.isLoading && city.snapshot == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (city.error != null && city.snapshot == null) {
          return StatusPanel(
            icon: Icons.error_outline,
            title: 'Alertas indisponíveis',
            message: '${city.error}',
            action: FilledButton(
              onPressed: city.load,
              child: const Text('Tentar novamente'),
            ),
          );
        }
        if (city.alerts.isEmpty) {
          return const StatusPanel(
            icon: Icons.notifications_none_rounded,
            title: 'Nenhum alerta neste momento',
            message:
                'As regras atuais não identificaram pressão elevada nos '
                'serviços acompanhados.',
          );
        }
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeading(
                      title: 'Alertas preditivos',
                      subtitle: 'Sinais identificados por regras transparentes',
                    ),
                    const SyntheticDataNotice(),
                    const SizedBox(height: 16),
                    for (final alert in city.alerts) ...[
                      _AlertListCard(alert: alert),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 4),
                    const Text(
                      'Os alertas não substituem a avaliação humana.',
                      style: TextStyle(
                        color: AppTheme.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AlertListCard extends StatelessWidget {
  const _AlertListCard({required this.alert});

  final PredictionAlert alert;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label:
          '${alert.title}, serviço ${alert.serviceName}, '
          'confiança ${alert.confidence} por cento. Abrir detalhes.',
      child: ContentCard(
        padding: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () =>
              Navigator.pushNamed(context, '/alert-detail', arguments: alert),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: alert.severity == AlertSeverity.critical
                        ? const Color(0xFFFCE8E6)
                        : const Color(0xFFFFF2D8),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    alert.severity == AlertSeverity.critical
                        ? Icons.priority_high_rounded
                        : Icons.trending_up_rounded,
                    color: alert.severity == AlertSeverity.critical
                        ? AppTheme.red
                        : AppTheme.amber,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              alert.serviceName,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          AlertSeverityChip(severity: alert.severity),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        alert.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 7),
                      Text(
                        alert.evidence,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Confiança indicativa: ${alert.confidence}% · Ver justificativa',
                        style: const TextStyle(
                          color: AppTheme.forest,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
