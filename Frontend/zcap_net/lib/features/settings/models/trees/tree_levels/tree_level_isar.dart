import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'tree_level.dart';

part 'tree_level_isar.g.dart';

@collection
class TreeLevelIsar implements IsarTable<TreeLevel> {
  @override
  Id id = Isar.autoIncrement;
  
  @Index()
  @override
  late int remoteId;
  late int levelId;
  late String name;
  String? description;
  @Index()
  late DateTime startDate;
  @Index()
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  @override
  DateTime lastUpdatedAt = DateTime.now(); 

  @Index()
  @override
  bool isSynced = false;
  
  TreeLevelIsar();  

  factory TreeLevelIsar.toRemote(TreeLevel treeLevel) {
    return TreeLevelIsar()
      ..remoteId = treeLevel.remoteId
      ..levelId = treeLevel.levelId
      ..name = treeLevel.name
      ..description = treeLevel.description
      ..startDate = treeLevel.startDate
      ..endDate = treeLevel.endDate
      ..createdAt = treeLevel.createdAt
      ..lastUpdatedAt = treeLevel.lastUpdatedAt
      ..isSynced = true;
  }
  
  @override
  TreeLevel toEntity() {
    return TreeLevel(
      remoteId: remoteId,
      levelId: levelId,
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt
    );
  }

  TreeLevelIsar copyWith({
    int? remoteId, 
    int? levelId, 
    String? name, 
    String? description, 
    DateTime? startDate, 
    DateTime? endDate, 
    DateTime? createdAt, 
    DateTime? lastUpdatedAt, 
    bool? isSynced
  }) {
    return TreeLevelIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..levelId = levelId ?? this.levelId
      ..name = name ?? this.name
      ..description = description ?? this.description
      ..startDate = startDate ?? this.startDate
      ..endDate = endDate ?? this.endDate
      ..createdAt = createdAt ?? this.createdAt
      ..lastUpdatedAt = lastUpdatedAt ?? this.lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }
  
  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    return TreeLevelIsar()
      ..id = id 
      ..remoteId = remoteId ?? this.remoteId
      ..levelId = levelId
      ..name = name 
      ..description = description 
      ..startDate = startDate 
      ..endDate = endDate 
      ..createdAt = createdAt 
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }
  
  @override
  String toString() {
    return name;
  }
  
  @override
  Future<void> updateFromApiEntity(TreeLevel entity) async{
    remoteId = entity.remoteId;
    levelId = entity.levelId;
    name = entity.name;
    description = entity.description;
    startDate = entity.startDate;
    endDate = entity.endDate;
    createdAt = entity.createdAt;
    lastUpdatedAt = entity.lastUpdatedAt;
    isSynced = true;
  }
}