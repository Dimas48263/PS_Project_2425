import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'tree_level.dart';

part 'tree_level_isar.g.dart';

@collection
class TreeLevelIsar implements IsarTable<TreeLevel> {
  @override
  Id id = Isar.autoIncrement;
  
  @override
  late int entityId;
  late int levelId;
  late String name;
  String? description;
  late DateTime startDate;
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now(); 

  @Index()
  @override
  bool isSynced = false;
  
  TreeLevelIsar();  

  factory TreeLevelIsar.toRemote(TreeLevel treeLevel) {
    return TreeLevelIsar()
      ..entityId = treeLevel.id
      ..levelId = treeLevel.levelId
      ..name = treeLevel.name
      ..description = treeLevel.description
      ..startDate = treeLevel.startDate
      ..endDate = treeLevel.endDate
      ..createdAt = treeLevel.createdAt
      ..updatedAt = treeLevel.updatedAt
      ..isSynced = true;
  }
  
  @override
  TreeLevel toEntity() {
    return TreeLevel(
      id: entityId,
      levelId: levelId,
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      updatedAt: updatedAt
    );
  }

  TreeLevelIsar copyWith({
    int? entityId, 
    int? levelId, 
    String? name, 
    String? description, 
    DateTime? startDate, 
    DateTime? endDate, 
    DateTime? createdAt, 
    DateTime? updatedAt, 
    bool? isSynced
  }) {
    return TreeLevelIsar()
      ..id = id
      ..entityId = entityId ?? this.entityId
      ..levelId = levelId ?? this.levelId
      ..name = name ?? this.name
      ..description = description ?? this.description
      ..startDate = startDate ?? this.startDate
      ..endDate = endDate ?? this.endDate
      ..createdAt = createdAt ?? this.createdAt
      ..updatedAt = updatedAt ?? this.updatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }
  
  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? entityId, bool? isSynced}) {
    return TreeLevelIsar()
      ..id = id 
      ..entityId = entityId ?? this.entityId
      ..levelId = levelId
      ..name = name 
      ..description = description 
      ..startDate = startDate 
      ..endDate = endDate 
      ..createdAt = createdAt 
      ..updatedAt = updatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }
  
  @override
  String toString() {
    return name;
  }
}