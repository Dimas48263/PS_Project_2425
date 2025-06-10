
import 'package:zcap_net_app/core/services/log_service.dart';
import 'package:zcap_net_app/core/services/sync_services/abstract_syncable_service.dart';

class SyncManager {
  final List<SyncableService> services;

  SyncManager(this.services);

  Future<void> syncAll() async {
    for (final service in services) {
      LogService.log('[Sync2] $service is beying synced!');
      await service.syncAll();
    }
  }

  Future<void> syncToServer() async {
    for (final service in services) {
      await service.syncToServer();
    }
  }

  Future<void> syncFromServer() async {
    for (final service in services) {
      await service.syncFromServer();
    }
  }
}