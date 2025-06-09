import 'dart:io';

class AppConfig {
  final String appDataPath;
  final String apiUrl;
  final int apiSyncIntervalSeconds;
  final bool logToFile;
  final String logFileName;

  static late AppConfig _instance;

  AppConfig._internal({
    required this.appDataPath,
    required this.apiUrl,
    required this.apiSyncIntervalSeconds,
    required this.logToFile,
    required this.logFileName,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig._internal(
      appDataPath: json['appDataPath'] as String? ?? getDefaultAppDataPath(),
      apiUrl: json['apiUrl'] as String,
      apiSyncIntervalSeconds:
          json['apiSyncIntervalSeconds'] as int? ?? 600, //default value
      logToFile: json['logToFile'] as bool,
      logFileName: json['logFileName'] as String,
    );
  }

  static void initFromJson(Map<String, dynamic> json) {
    _instance = AppConfig.fromJson(json);
  }

  static AppConfig get instance => _instance;

  static String getDefaultAppDataPath() {
    if (Platform.isWindows) {
      return r'C:\ZcapNet';
    } else if (Platform.isLinux || Platform.isMacOS) {
      return '/opt/zcapnet';
    } else {
      throw UnsupportedError("S.O. não suportado.");
    }
  }
}
