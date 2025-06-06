import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/tree_levels/tree_level.dart';
import 'package:zcap_net_app/features/settings/models/tree_levels/tree_level_isar.dart';
import 'tree.dart';

part 'tree_isar.g.dart';

@collection
class TreeIsar extends IsarTable<Tree> {
  @override
  Id id = Isar.autoIncrement;
  
  @override
  int? entityId;
  late String name;
  IsarLink<TreeLevelIsar> treeLevel = IsarLink<TreeLevelIsar>();
  IsarLink<TreeIsar> parent = IsarLink<TreeIsar>();
  late DateTime startDate;
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now(); 

  @override
  bool isSynced = false;

  TreeIsar();
  
  static Future<TreeLevelIsar> findOrBuildTreeLevel(int id, TreeLevel treeLevel) async {
    final tl = await DatabaseService.db.treeLevelIsars.filter().entityIdEqualTo(id).findFirst();//.where().findAll();
    return tl ?? TreeLevelIsar.toRemote(treeLevel);
  }

  static Future<TreeIsar> findOrBuildTree(int? id, Tree tree) async {
    TreeIsar? t;
    if (id != null) {
      t = await DatabaseService.db.treeIsars.filter().entityIdEqualTo(id).findFirst();
    }
    return t ?? TreeIsar.toRemote(tree);
  }

  static Future<TreeIsar> toRemote(Tree tree) async {
  final treeIsar = TreeIsar()
    ..entityId = tree.id
    ..name = tree.name
    ..startDate = tree.startDate
    ..endDate = tree.endDate
    ..createdAt = tree.createdAt
    ..updatedAt = tree.updatedAt
    ..isSynced = true;

  // Usar o objeto já existente ou criar novo (TreeLevel)
  final treeLevelIsar = await findOrBuildTreeLevel(tree.treeLevel.id, tree.treeLevel);
  treeIsar.treeLevel.value = treeLevelIsar;


  // Recursivamente associar o parent (se existir)
  if (tree.parent != null) {
    final parentIsar = await findOrBuildTree(tree.parent?.id, tree);
    treeIsar.parent.value = parentIsar;
  }

  await DatabaseService.db.writeTxn(() async {
    await DatabaseService.db.treeIsars.put(treeIsar);
    await treeIsar.treeLevel.save();
    if (tree.parent != null) {
      await treeIsar.parent.save();
    }
  });

  return treeIsar;
}


  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? entityId, bool? isSynced}) {
    return TreeIsar()
      ..id = id 
      ..entityId = entityId ?? this.entityId
      ..name = name 
      ..treeLevel.value = treeLevel.value
      ..parent.value = parent.value
      ..startDate = startDate 
      ..endDate = endDate 
      ..createdAt = createdAt 
      ..updatedAt = updatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }

  @override
  Tree toEntity() {
    return Tree(
      id: entityId ?? 0,
      name: name,
      treeLevel: treeLevel.value!.toEntity(),
      parent: parent.value?.toEntity(),
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      updatedAt: updatedAt
    );
  }

  @override
  String toString() {
    return name;
  }
}