abstract class IsarTable<T extends ApiTable> {
  int get id;
  int? get remoteId;
  bool get isSynced;
  set isSynced(bool value); 
  DateTime get updatedAt;
  T toEntity();
  IsarTable setEntityIdAndSync({int? remoteId, bool? isSynced});
  Future<void> updateFromApiEntity(T entity);
}

abstract class ApiTable {
  int get remoteId;
  DateTime get updatedAt;
  Map<String, dynamic> toJsonInput();
}

