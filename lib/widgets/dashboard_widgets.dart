import 'package:material_ui/material_ui.dart';

import '../models/prediction_alert.dart';
import '../models/service_metric.dart';
import '../theme/app_theme.dart';

class PageHeading extends StatelessWidget {
  const PageHeading({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 5),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          if (trailing case final trailingWidget?) ...[
            const SizedBox(width: 12),
            trailingWidget,
          ],
        ],
      ),
    );
  }
}

class ContentCard extends StatelessWidget {
  const ContentCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: padding, child: child),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        ?trailing,
      ],
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.caption,
    required this.icon,
    this.tint = AppTheme.mint,
    this.valueColor = AppTheme.ink,
  });

  final String label;
  final String value;
  final String caption;
  final IconData icon;
  final Color tint;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 150;
          final iconWidget = Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: valueColor),
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (compact) ...[
                Row(children: [iconWidget, const Spacer()]),
                const SizedBox(height: 8),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ] else
                Row(
                  children: [
                    iconWidget,
                    const Spacer(),
                    Flexible(
                      child: Text(
                        label,
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 15),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: valueColor,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 4),
              Text(caption, style: Theme.of(context).textTheme.bodySmall),
            ],
          );
        },
      ),
    );
  }
}

class StatusPanel extends StatelessWidget {
  const StatusPanel({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ContentCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 40, color: AppTheme.forest),
                const SizedBox(height: 12),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(message, textAlign: TextAlign.center),
                if (action != null) ...[const SizedBox(height: 16), action!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SyntheticDataNotice extends StatelessWidget {
  const SyntheticDataNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFF214B82)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Demonstração com dados sintéticos. Os indicadores não representam '
              'medições oficiais da Prefeitura de São Paulo.',
              style: TextStyle(color: Color(0xFF173B66)),
            ),
          ),
        ],
      ),
    );
  }
}

class CapacityBar extends StatelessWidget {
  const CapacityBar({
    super.key,
    required this.label,
    required this.value,
    required this.capacity,
    this.showValues = true,
  });

  final String label;
  final int value;
  final int capacity;
  final bool showValues;

  @override
  Widget build(BuildContext context) {
    final ratio = capacity == 0 ? 0.0 : value / capacity;
    final color = ratio >= 1
        ? AppTheme.red
        : ratio >= 0.9
        ? AppTheme.amber
        : AppTheme.forest;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              if (showValues)
                Text(
                  '$value / $capacity',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Semantics(
            label:
                '$label: ${(ratio * 100).round()} por cento da capacidade utilizada',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: ratio.clamp(0, 1).toDouble(),
                minHeight: 9,
                color: color,
                backgroundColor: const Color(0xFFE8EFEB),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryBars extends StatelessWidget {
  const HistoryBars({super.key, required this.services});

  final List<ServiceMetric> services;

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) return const SizedBox.shrink();
    final maximum = services
        .map(
          (metric) => metric.demand > metric.previousDemand
              ? metric.demand
              : metric.previousDemand,
        )
        .reduce((a, b) => a > b ? a : b);
    return SizedBox(
      height: 190,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final service in services)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Semantics(
                  label:
                      '${service.name}, demanda atual ${service.demand}, período anterior ${service.previousDemand}',
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _compact(service.demand),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 7),
                      SizedBox(
                        height: 118,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _bar(
                              service.previousDemand / maximum,
                              const Color(0xFFC9D8D1),
                            ),
                            const SizedBox(width: 4),
                            _bar(service.demand / maximum, AppTheme.forest),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        service.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _bar(double ratio, Color color) {
    return Flexible(
      child: FractionallySizedBox(
        heightFactor: ratio.clamp(0.05, 1).toDouble(),
        child: Container(
          width: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ),
      ),
    );
  }

  String _compact(int value) => value >= 1000
      ? '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}k'
      : '$value';
}

class AlertSeverityChip extends StatelessWidget {
  const AlertSeverityChip({super.key, required this.severity});

  final AlertSeverity severity;

  @override
  Widget build(BuildContext context) {
    final (label, color, background) = switch (severity) {
      AlertSeverity.attention => (
        'Atenção',
        AppTheme.amber,
        const Color(0xFFFFF2D8),
      ),
      AlertSeverity.high => (
        'Alta',
        const Color(0xFF9A4A00),
        const Color(0xFFFFE9D4),
      ),
      AlertSeverity.critical => (
        'Crítica',
        AppTheme.red,
        const Color(0xFFFCE8E6),
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
