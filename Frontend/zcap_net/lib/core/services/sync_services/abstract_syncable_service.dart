abstract class SyncableService {
  Future<void> syncToServer();
  Future<void> syncFromServer();
  Future<void> syncAll();
}