import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import '../models/prediction_alert.dart';
import '../providers/preferences_provider.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import 'alert_screens.dart';
import 'alert_detail_screen.dart';
import 'dashboard_screens.dart';
import 'occurrence_screens.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  static const _routes = [
    '/',
    '/services',
    '/impact',
    '/alerts',
    '/occurrences',
  ];

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Widget page;
    switch (settings.name) {
      case '/':
        page = const AppShell();
        break;
      case '/services':
        page = const AppShell(initialIndex: 1);
        break;
      case '/impact':
        page = const AppShell(initialIndex: 2);
        break;
      case '/alerts':
        page = const AppShell(initialIndex: 3);
        break;
      case '/occurrences':
        page = const AppShell(initialIndex: 4);
        break;
      case '/alert-detail':
        final alert = settings.arguments;
        if (alert is! PredictionAlert) {
          return _unknownRoute(settings.name);
        }
        page = AlertDetailScreen(alert: alert);
        break;
      case '/occurrence/new':
        page = const OccurrenceFormScreen();
        break;
      default:
        return _unknownRoute(settings.name);
    }
    return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
  }

  static Route<void> _unknownRoute(String? routeName) {
    return MaterialPageRoute<void>(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Página não encontrada')),
        body: Center(child: Text('Rota inválida: ${routeName ?? ''}')),
      ),
    );
  }

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _selectedIndex;

  static const _destinations = [
    _Destination('Visão geral', 'Visão', Icons.space_dashboard_outlined),
    _Destination('Serviços', 'Serviços', Icons.apartment_rounded),
    _Destination(
      'Impacto social',
      'Impacto',
      Icons.volunteer_activism_outlined,
    ),
    _Destination('Alertas', 'Alertas', Icons.notifications_active_outlined),
    _Destination('Ocorrências', 'Registros', Icons.assignment_outlined),
  ];

  static const _pages = [
    OverviewDashboard(),
    ServicesDashboard(),
    SocialImpactDashboard(),
    AlertsScreen(),
    OccurrencesScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _selectDestination(int index) {
    if (index == _selectedIndex) return;
    Navigator.pushReplacementNamed(context, AppShell._routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.mint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.eco_rounded,
                    color: AppTheme.forest,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 11),
                const Text(
                  'Território Vivo',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                const Icon(Icons.location_on_outlined, size: 19),
                const SizedBox(width: 4),
                Text(
                  'São Paulo, SP',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Aparência e notificações',
                  icon: const Icon(Icons.tune_rounded),
                  onPressed: () => _openPreferences(context),
                ),
              ],
            ),
          ),
          body: Row(
            children: [
              if (wide)
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _selectDestination,
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  destinations: [
                    for (final destination in _destinations)
                      NavigationRailDestination(
                        icon: Icon(destination.icon),
                        label: Text(destination.label),
                      ),
                  ],
                ),
              Expanded(
                child: IndexedStack(index: _selectedIndex, children: _pages),
              ),
            ],
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _selectDestination,
                  destinations: [
                    for (final destination in _destinations)
                      NavigationDestination(
                        icon: Icon(destination.icon),
                        label: destination.shortLabel,
                      ),
                  ],
                ),
        );
      },
    );
  }

  Future<void> _openPreferences(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Consumer<PreferencesProvider>(
          builder: (context, preferences, _) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preferências',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 18),
                    const Text('Aparência'),
                    const SizedBox(height: 8),
                    SegmentedButton<AppearanceMode>(
                      segments: const [
                        ButtonSegment(
                          value: AppearanceMode.light,
                          label: Text('Claro'),
                          icon: Icon(Icons.light_mode_outlined),
                        ),
                        ButtonSegment(
                          value: AppearanceMode.dark,
                          label: Text('Escuro'),
                          icon: Icon(Icons.dark_mode_outlined),
                        ),
                        ButtonSegment(
                          value: AppearanceMode.highContrast,
                          label: Text('Alto contraste'),
                          icon: Icon(Icons.contrast_rounded),
                        ),
                      ],
                      selected: {preferences.appearanceMode},
                      onSelectionChanged: (selected) {
                        preferences.setAppearanceMode(selected.first);
                      },
                    ),
                    const SizedBox(height: 18),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Alertas críticos'),
                      subtitle: const Text(
                        'Notificações locais para sinais críticos.',
                      ),
                      value: preferences.notificationsEnabled,
                      onChanged: kIsWeb
                          ? null
                          : (enabled) async {
                              final granted =
                                  await preferences.setNotificationsEnabled(
                                enabled,
                              );
                              if (!granted && enabled && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Permissão de notificações não concedida.',
                                    ),
                                  ),
                                );
                              }
                            },
                    ),
                    if (kIsWeb)
                      const Text(
                        'Notificações locais estão disponíveis no Android.',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _Destination {
  const _Destination(this.label, this.shortLabel, this.icon);

  final String label;
  final String shortLabel;
  final IconData icon;
}
