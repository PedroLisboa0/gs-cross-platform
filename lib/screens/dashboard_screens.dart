import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../models/service_metric.dart';
import '../providers/city_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_widgets.dart';

class OverviewDashboard extends StatelessWidget {
  const OverviewDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CityProvider>(
      builder: (context, city, _) {
        if (city.isLoading && city.snapshot == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (city.error != null && city.snapshot == null) {
          return StatusPanel(
            icon: Icons.cloud_off_rounded,
            title: 'Indicadores indisponíveis',
            message:
                'Não foi possível carregar o conjunto de dados local: '
                '${city.error}',
            action: FilledButton.icon(
              onPressed: city.load,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          );
        }
        if (city.services.isEmpty) {
          return const StatusPanel(
            icon: Icons.inbox_outlined,
            title: 'Nenhum indicador disponível',
            message: 'Não há dados para montar o painel neste momento.',
          );
        }

        return _DashboardFrame(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth > 820 ? 4 : 2;
              final gap = 12.0;
              final cardWidth =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeading(
                    title: 'Visão geral',
                    subtitle: 'Sinais de demanda por serviços públicos',
                    trailing: IconButton(
                      tooltip: 'Atualizar indicadores',
                      onPressed: city.load,
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ),
                  const SyntheticDataNotice(),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: MetricCard(
                          label: 'Solicitações',
                          value: _formatNumber(city.totalDemand),
                          caption: 'nos serviços acompanhados',
                          icon: Icons.inbox_rounded,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: MetricCard(
                          label: 'Em atenção',
                          value: '${city.alerts.length}',
                          caption: 'regras de alerta acionadas',
                          icon: Icons.notifications_active_outlined,
                          tint: const Color(0xFFFFF2D8),
                          valueColor: AppTheme.amber,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: MetricCard(
                          label: 'Resolvidas',
                          value: '${(city.resolutionRate * 100).round()}%',
                          caption: 'taxa ponderada simulada',
                          icon: Icons.task_alt_rounded,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: MetricCard(
                          label: 'Serviços',
                          value: '${city.services.length}',
                          caption: 'áreas monitoradas',
                          icon: Icons.domain_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ContentCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle('Demanda por serviço'),
                        const SizedBox(height: 5),
                        Text(
                          'Período anterior e período atual · solicitações',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 14),
                        HistoryBars(services: city.services),
                        const SizedBox(height: 10),
                        const Wrap(
                          spacing: 18,
                          children: [
                            _LegendDot(
                              color: Color(0xFFC9D8D1),
                              label: 'Período anterior',
                            ),
                            _LegendDot(
                              color: AppTheme.forest,
                              label: 'Período atual',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  ContentCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle('Capacidade em destaque'),
                        const SizedBox(height: 10),
                        for (final metric in city.services)
                          CapacityBar(
                            label: metric.name,
                            value: metric.demand,
                            capacity: metric.capacity,
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class ServicesDashboard extends StatelessWidget {
  const ServicesDashboard({super.key});

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
            title: 'Não foi possível carregar os serviços',
            message: '${city.error}',
            action: FilledButton(
              onPressed: city.load,
              child: const Text('Tentar novamente'),
            ),
          );
        }
        if (city.services.isEmpty) {
          return const StatusPanel(
            icon: Icons.inbox_outlined,
            title: 'Sem dados de serviços',
            message: 'Ainda não há serviços para exibir.',
          );
        }
        return _DashboardFrame(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeading(
                title: 'Painel de serviços',
                subtitle: 'Demanda, espera e capacidade de atendimento',
              ),
              const SyntheticDataNotice(),
              const SizedBox(height: 18),
              for (final metric in city.services) ...[
                _ServiceCard(metric: metric),
                const SizedBox(height: 12),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.metric});

  final ServiceMetric metric;

  @override
  Widget build(BuildContext context) {
    final trend = metric.trend;
    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metric.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 3),
                    Text(metric.category),
                  ],
                ),
              ),
              Icon(
                trend > 0 ? Icons.trending_up : Icons.trending_down,
                color: trend > 0 ? AppTheme.amber : AppTheme.forest,
              ),
              const SizedBox(width: 4),
              Text(
                '${trend >= 0 ? '+' : ''}${(trend * 100).round()}%',
                style: TextStyle(
                  color: trend > 0 ? AppTheme.amber : AppTheme.forest,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          CapacityBar(
            label: 'Uso da capacidade',
            value: metric.demand,
            capacity: metric.capacity,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 24,
            runSpacing: 10,
            children: [
              _DetailValue(
                label: 'Espera média',
                value: '${metric.averageWaitHours}h',
              ),
              _DetailValue(
                label: 'Resolução',
                value: '${(metric.resolutionRate * 100).round()}%',
              ),
              _DetailValue(label: 'Atual', value: '${metric.demand}'),
              _DetailValue(
                label: 'Anterior',
                value: '${metric.previousDemand}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SocialImpactDashboard extends StatelessWidget {
  const SocialImpactDashboard({super.key});

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
            title: 'Indicadores sociais indisponíveis',
            message: '${city.error}',
            action: FilledButton(
              onPressed: city.load,
              child: const Text('Tentar novamente'),
            ),
          );
        }
        if (city.services.isEmpty) {
          return const StatusPanel(
            icon: Icons.inbox_outlined,
            title: 'Sem dados territoriais',
            message: 'Não há dados para comparar regiões.',
          );
        }
        final neighborhoods = <String, List<NeighborhoodMetric>>{};
        for (final service in city.services) {
          for (final neighborhood in service.neighborhoods) {
            neighborhoods
                .putIfAbsent(neighborhood.name, () => [])
                .add(neighborhood);
          }
        }
        return _DashboardFrame(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeading(
                title: 'Impacto social',
                subtitle: 'Acompanhamento territorial de atendimento',
              ),
              const SyntheticDataNotice(),
              const SizedBox(height: 18),
              ContentCard(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.mint,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.volunteer_activism_rounded,
                        color: AppTheme.forest,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Taxa estimada de resolução',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(city.resolutionRate * 100).round()}% das '
                            'solicitações acompanhadas',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              ContentCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle('Pressão por região'),
                    const SizedBox(height: 6),
                    Text(
                      'Solicitações somadas nos serviços monitorados.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    for (final entry in neighborhoods.entries)
                      _NeighborhoodCard(name: entry.key, metrics: entry.value),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const ContentCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.forest),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Este indicador é uma aproximação demonstrativa. '
                        'Diferenças de acesso, subnotificação e critérios de '
                        'registro podem afetar a comparação entre regiões.',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NeighborhoodCard extends StatelessWidget {
  const _NeighborhoodCard({required this.name, required this.metrics});

  final String name;
  final List<NeighborhoodMetric> metrics;

  @override
  Widget build(BuildContext context) {
    final demand = metrics.fold<int>(0, (total, item) => total + item.demand);
    final capacity = metrics.fold<int>(
      0,
      (total, item) => total + item.capacity,
    );
    return CapacityBar(label: name, value: demand, capacity: capacity);
  }
}

class _DetailValue extends StatelessWidget {
  const _DetailValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _DashboardFrame extends StatelessWidget {
  const _DashboardFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: child,
          ),
        ),
      ),
    );
  }
}

String _formatNumber(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < text.length; index++) {
    if (index > 0 && (text.length - index) % 3 == 0) buffer.write('.');
    buffer.write(text[index]);
  }
  return buffer.toString();
}
