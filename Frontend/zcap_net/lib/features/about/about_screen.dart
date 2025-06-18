import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zcap_net_app/core/services/globals.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = '${info.version} (${info.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final logoWidth = screenWidth * 0.5;

    return Scaffold(
      appBar: AppBar(
        title: Text('about'.tr()),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'ZCAP Net',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Text(
                  'app_description'.tr(),
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 12),
                Image.asset(
                  'assets/images/logo_ISEL.png',
                  width: logoWidth,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Text(
                  'isel_course'.tr(),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'isel_module'.tr(),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                Text(
                  'authors'.tr(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 60,
                  runSpacing: 50,
                  children: [
                    authorCard(
                      imagePath: 'assets/images/hacker.png',
                      name: 'Luis Alves',
                      number: '46974',
                    ),
                    authorCard(
                      imagePath: 'assets/images/hacker.png',
                      name: 'Gonçalo Dimas',
                      number: '48263',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${'version'.tr()} $_version',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget authorCard({
  required String imagePath,
  required String name,
  required String number,
}) {
  return Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imagePath,
          width: 77,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(height: 8),
      Text(name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      Text(number, style: const TextStyle(fontSize: 20, color: Colors.grey)),
    ],
  );
}
