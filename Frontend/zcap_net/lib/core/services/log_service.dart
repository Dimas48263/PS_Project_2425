import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:zcap_net_app/core/services/app_config.dart';

class LogService {
  static late AppConfig _config;
  static File? _logFile;
  static final _logQueue = <String>[];
  static bool _isWriting = false;

  static Future<void> init(AppConfig config) async {
    _config = config;

    if (_config.logToFile) {
      final dir = await getApplicationDocumentsDirectory();
      final now = DateTime.now();
      final dateStr = "${now.year}${_pad2(now.month)}${_pad2(now.day)}";

      final logPath = p.join(_config.appDataPath, 'logs');
      final logFile = _config.logFileName;
      final baseName = p.basenameWithoutExtension(logFile);
      final extension = p.extension(logFile);

      final fileName =
          "${baseName}_$dateStr$extension"; //ex: app_log_20250609.txt
      final fullPath = p.join(dir.path, logPath, fileName);

      _logFile = File(fullPath);
      await _logFile!.create(recursive: true);
    }
  }

  static void log(String message) async {
    final now = DateTime.now();
    final timestamp =
        "${now.year}-${_pad2(now.month)}-${_pad2(now.day)} ${_pad2(now.hour)}:${_pad2(now.minute)}:${_pad2(now.second)}";
    final logMessage = "[$timestamp] $message";

    print(logMessage);

    if (_config.logToFile && _logFile != null) {
      _enqueueLog(logMessage);
    }
  }

  static void _enqueueLog(String message) {
    _logQueue.add(message);
    if (!_isWriting) {
      _writeNext();
    }
  }

  static void _writeNext() async {
    if (_logQueue.isEmpty || _logFile == null) {
      _isWriting = false;
      return;
    }

    _isWriting = true;
    final message = _logQueue.removeAt(0);
    try {
      await _logFile!.writeAsString("$message\n", mode: FileMode.append);
    } catch (e) {
      print("[LogService ERROR] Falha ao escrever no ficheiro de log: $e");
    }
    _writeNext();
  }

  static String _pad2(int value) => value.toString().padLeft(2, '0');
}
