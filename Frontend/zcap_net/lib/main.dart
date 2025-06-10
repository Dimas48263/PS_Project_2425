import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_size/window_size.dart';
import 'package:zcap_net_app/core/services/app_config.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/log_service.dart';
import 'package:zcap_net_app/core/services/notifiers.dart';
import 'package:zcap_net_app/core/services/sync_services/sync_service_manager.dart';
import 'package:zcap_net_app/data/notifiers.dart';
import 'package:zcap_net_app/features/home/screens/home_screen.dart';
import 'core/services/session_manager.dart';
import 'features/login/widgets/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    setWindowMinSize(const Size(800, 600)); //Minimum size window
    setWindowTitle('ZCAP Net');
  }

  await _setup();

  final session = SessionManager();

//  syncServiceV3.startListening();
  runApp(MyApp(
    sessionManager: session,
  ));
}

Future<void> _setup() async {
  WidgetsFlutterBinding.ensureInitialized();

  final configString = await rootBundle.loadString('assets/config/config.json');
  final configMap = jsonDecode(configString) as Map<String, dynamic>;

  AppConfig.initFromJson(configMap);

  await DatabaseService.setup();
  SyncServiceManager().setup();

  await LogService.init(AppConfig.instance);

  LogService.log("Aplicação iniciada com API: ${AppConfig.instance.apiUrl}");
}

class MyApp extends StatelessWidget {
  final SessionManager sessionManager;

  const MyApp({
    super.key,
    required this.sessionManager,
  });

  @override
  Widget build(BuildContext context) {
    isOnlineNotifier.value = sessionManager.isOnline;

    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Zcap Net',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
            ),
            useMaterial3: true,
          ),
          home: sessionManager.isLoggedIn
              ? const HomeScreen()
              : const LoginScreen(),
        );
      },
    );
  }
}
