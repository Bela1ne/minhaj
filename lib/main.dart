import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'localization/localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/theme_service.dart';
import 'services/language_service.dart';
import 'services/notification_service.dart';
import 'ui/navigation/route_manager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser les services
  final themeService = ThemeService();
  final languageService = LanguageService();

  await themeService.loadTheme();
  await languageService.loadLanguage();

  // Initialiser la timezone avant les notifications
  tz.initializeTimeZones();
  final localLocation = tz.getLocation('Africa/Algiers'); // 🔁 à ajuster selon ton fuseau
  await NotificationService.initialize(localLocation);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeService),
        ChangeNotifierProvider(create: (_) => languageService),
      ],
      child: const MinhajApp(),
    ),
  );
}

class MinhajApp extends StatelessWidget {
  const MinhajApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final langService = Provider.of<LanguageService>(context);

    return MaterialApp(
      title: 'Minhaj App',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      navigatorObservers: [routeObserver],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeService.themeMode,
      locale: langService.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: '/',
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}
