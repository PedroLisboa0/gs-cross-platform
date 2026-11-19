import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'providers/city_provider.dart';
import 'providers/occurrence_provider.dart';
import 'providers/preferences_provider.dart';
import 'models/prediction_alert.dart';
import 'screens/app_shell.dart';
import 'services/local_database.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  await NotificationService.instance.initialize(
    onServiceIdSelected: _openAlertByServiceId,
  );
  runApp(const AppBootstrap());
}

final _navigatorKey = GlobalKey<NavigatorState>();

void _openAlertByServiceId(String serviceId) {
  final context = _navigatorKey.currentContext;
  if (context == null) return;
  final city = context.read<CityProvider>();
  PredictionAlert? alert;
  for (final candidate in city.alerts) {
    if (candidate.serviceId == serviceId) {
      alert = candidate;
      break;
    }
  }
  if (alert == null) {
    _navigatorKey.currentState?.pushNamed('/alerts');
  } else {
    _navigatorKey.currentState?.pushNamed('/alert-detail', arguments: alert);
  }
}

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  late Future<LocalDatabase> _database;

  @override
  void initState() {
    super.initState();
    _database = LocalDatabase.open();
  }

  void _retry() {
    setState(() => _database = LocalDatabase.open());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocalDatabase>(
      future: _database,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.storage_rounded, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'Não foi possível abrir o banco local.',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text('${snapshot.error}', textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: _retry,
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        if (!snapshot.hasData) {
          return MaterialApp(
            theme: AppTheme.light,
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        final database = snapshot.data!;
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => CityProvider()..load()),
            ChangeNotifierProvider(
              create: (_) => OccurrenceProvider(database)..load(),
            ),
            ChangeNotifierProvider(
              create: (_) => PreferencesProvider()..load(),
            ),
          ],
          child: const TerritorioVivoApp(),
        );
      },
    );
  }
}

class TerritorioVivoApp extends StatelessWidget {
  const TerritorioVivoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final preferences = context.watch<PreferencesProvider>();
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Território Vivo',
      debugShowCheckedModeBanner: false,
      theme: preferences.appearanceMode == AppearanceMode.highContrast
          ? AppTheme.highContrast
          : AppTheme.light,
      darkTheme: AppTheme.dark,
      highContrastTheme: AppTheme.highContrast,
      themeMode: preferences.themeMode,
      initialRoute: '/',
      onGenerateRoute: AppShell.onGenerateRoute,
    );
  }
}
