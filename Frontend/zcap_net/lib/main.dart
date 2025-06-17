import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_size/window_size.dart';
import 'package:zcap_net_app/core/services/app_config.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/notifiers.dart';
import 'package:zcap_net_app/data/notifiers.dart';
import 'package:zcap_net_app/features/home/screens/home_screen.dart';
import 'package:zcap_net_app/features/login/view_model/language_model.dart';
import 'core/services/session_manager.dart';
import 'features/login/widgets/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final supportedLanguages = await Language.loadFromAsset();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    setWindowMinSize(const Size(800, 600)); //Minimum size window
    setWindowTitle('ZCAP Net');
  }

  await _setup();

  final session = SessionManager();

  syncServiceV3.startListening();

  runApp(
    EasyLocalization(
      supportedLocales: supportedLanguages.map((e) => Locale(e.code)).toList(),
      path: 'assets/translations',
      fallbackLocale: const Locale('pt'),
      child: MyApp(sessionManager: session, supportedLanguages: supportedLanguages),
    ),
  );
}

Future<void> _setup() async {
  WidgetsFlutterBinding.ensureInitialized();

  final configString = await rootBundle.loadString('assets/config/config.json');
  final configMap = jsonDecode(configString) as Map<String, dynamic>;

  AppConfig.initFromJson(configMap);

  await DatabaseService.setup();
  //SyncServiceManager().setup(); //Sync2 suspendend

  await LogService.init(AppConfig.instance);

  LogService.log(
    'log_app_started'.tr(namedArgs: {
      'api': AppConfig.instance.apiUrl,
    }),
  );
}

class MyApp extends StatelessWidget {
  final SessionManager sessionManager;
  final List<Language> supportedLanguages;

  const MyApp({
    super.key,
    required this.sessionManager,
    required this.supportedLanguages,
  });

  @override
  Widget build(BuildContext context) {
    isOnlineNotifier.value = sessionManager.isOnline;

    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ZCAP Net',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
            ),
            useMaterial3: true,
          ),
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          home: sessionManager.isLoggedIn
              ? HomeScreen(supportedLanguages: supportedLanguages)
              : LoginScreen(supportedLanguages: supportedLanguages),
        );
      },
    );
  }
}
//TODO: implement all translations
