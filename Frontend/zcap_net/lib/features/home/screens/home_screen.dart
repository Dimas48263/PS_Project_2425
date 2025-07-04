import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/data/notifiers.dart';
import 'package:zcap_net_app/features/about/about_screen.dart';
import 'package:zcap_net_app/features/home/screens/help_screen.dart';
import 'package:zcap_net_app/features/login/view_model/language_model.dart';
import 'package:zcap_net_app/features/settings/screens/zcaps/zcaps/zcaps_screen.dart';
import 'package:zcap_net_app/widgets/status_bar.dart';
import '../../../core/services/session_manager.dart';
import '../../login/widgets/login_screen.dart';
import 'package:zcap_net_app/features/settings/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<Language> supportedLanguages;
  const HomeScreen({super.key, required this.supportedLanguages});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userName = SessionManager().userName;
    final allowances = context.watch<UserAllowancesProvider>();
//    LogService.log(
//        'Allowances: ${allowances.accessMap.entries.map((entry) => '${entry.key}: ${entry.value}').join(', ')}');

    return Scaffold(
      appBar: AppBar(
        title: Text('screen_main_menu'.tr()),
        actions: [
          IconButton(
            onPressed: () {
              isDarkModeNotifier.value = !isDarkModeNotifier.value;
            },
            icon: ValueListenableBuilder(
              valueListenable: isDarkModeNotifier,
              builder: (context, isDarkMode, child) {
                return Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode);
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(userName ?? 'user'.tr()),
              accountEmail: Text(""), //no email info
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 40.0,
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.maps_home_work_outlined),
              title: Text('screen_main_menu'.tr()),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                          supportedLanguages: widget.supportedLanguages)),
                );
              },
            ),
            if (allowances.canRead('user_access_screen_zcaps'))
              ListTile(
                leading: const Icon(Icons.maps_home_work_outlined),
                title: Text('screen_zcaps'.tr()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ZcapsScreen(userName: userName)),
                  );
                },
              ),
            if (allowances.canRead('user_access_screen_incidents'))
              ListTile(
                leading: const Icon(Icons.report_problem_outlined),
                title: Text('screen_incidents'.tr()),
                onTap: () {
                  // TODO: Navegar para o ecrã de Incidents
                },
              ),
            if (allowances.canRead('user_access_screen_settings'))
              ListTile(
                leading: const Icon(Icons.settings),
                title: Text('screen_settings_configs'.tr()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help),
              title: Text('help'.tr()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text('about'.tr()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: Text('logout'.tr()),
              onTap: _confirmLogout,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('welcome_message'.tr(), style: TextStyle(fontSize: 24)),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: StatusBar(userName: userName),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('confirm_logout'.tr()),
        content: Text('confirm_logout_message'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('logout'.tr()),
          ),
        ],
      ),
    );

    if (confirm == true) {
      SessionManager().clearSession();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) =>
                LoginScreen(supportedLanguages: widget.supportedLanguages)),
      );
    }
  }
}
