abstract class IsarTable<T extends ApiTable> {
  int get id;
  int? get remoteId;
  bool get isSynced;
  set isSynced(bool value); 
  T toEntity();
  IsarTable setEntityIdAndSync({int? remoteId, bool? isSynced});
}

abstract class ApiTable {
  int get remoteId;
  Map<String, dynamic> toJsonInput();
}

