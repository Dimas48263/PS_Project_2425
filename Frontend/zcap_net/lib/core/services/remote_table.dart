abstract class IsarTable<T extends ApiTable> {
  int get id;
  int? get remoteId;
  bool get isSynced;
  set isSynced(bool value); 
  DateTime get lastUpdatedAt;
  T toEntity();
  IsarTable setEntityIdAndSync({int? remoteId, bool? isSynced});
  Future<void> updateFromApiEntity(T entity);
}

abstract class ApiTable {
  int get remoteId;
  DateTime get lastUpdatedAt;
  Map<String, dynamic> toJsonInput();
}

