/*import 'dart:async';

import 'package:zcap_net_app/core/services/app_config.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/log_service.dart';
import 'package:zcap_net_app/core/services/session_manager.dart';
import 'package:zcap_net_app/core/services/sync_services/sync_manager.dart';
import 'package:zcap_net_app/core/services/sync_services/tables/entities_sync_service.dart';
import 'package:zcap_net_app/core/services/sync_services/tables/entity_type_sync_service.dart';

class SyncServiceManager {
  static final SyncServiceManager _instance = SyncServiceManager._internal();
  late final SyncManager _syncManager;
  Timer? _timer;

  factory SyncServiceManager() {
    return _instance;
  }

  SyncServiceManager._internal();

  void setup() {
    _syncManager = SyncManager([
      EntityTypeSyncService(DatabaseService.db),
//      EntitySyncService(DatabaseService.db),
      // TreeSyncService(DatabaseService.db),
      // TreeLevelSyncService(DatabaseService.db),
    ]);

    _startPeriodicSync();
  }

  void _startPeriodicSync() {
    final session = SessionManager();
    final duration =
        Duration(seconds: AppConfig.instance.apiSyncIntervalSeconds);
    _timer?.cancel();
    _timer = Timer.periodic(duration, (_) async {
      if (session.token != null && !session.isTokenExpired()) {
        LogService.log('[Sync2] Timed sync activated!');
        await _syncManager.syncAll();
      } else {
        LogService.log(
            '[Sync2] Sincronização ignorada: token ausente ou expirado.');
      }
    });
  }

  Future<void> syncNow() async {
    await _syncManager.syncAll();
  }

  void dispose() {
    _timer?.cancel();
  }
}
*/