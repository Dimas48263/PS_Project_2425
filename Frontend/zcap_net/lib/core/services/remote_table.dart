abstract class IsarTable<T extends ApiTable> {
  int get id;
  int? get entityId;
  bool get isSynced;
  set isSynced(bool value); 
  T toEntity();
  IsarTable setEntityIdAndSync({int? entityId, bool? isSynced});
}

abstract class ApiTable {
  int get id;
  Map<String, dynamic> toJsonInput();
}

