

class AppConfig {
  final String apiUrl;
  final int apiSyncIntervalSeconds;
  final bool logToFile;
  final String logPath;
  final String logFile;

  static late AppConfig _instance;

  AppConfig._internal({
    required this.apiUrl,
    required this.apiSyncIntervalSeconds,
    required this.logToFile,
    required this.logPath,
    required this.logFile,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig._internal(
      apiUrl: json['apiUrl'] as String,
      apiSyncIntervalSeconds: json['apiSyncIntervalSeconds'] as int? ?? 600, //default value
      logToFile: json['logToFile'] as bool,
      logPath: json['logPath'] as String,
      logFile: json['logFile'] as String,
    );
  }

  static void initFromJson(Map<String, dynamic> json) {
    _instance = AppConfig.fromJson(json);
  }

  static AppConfig get instance => _instance;
}
