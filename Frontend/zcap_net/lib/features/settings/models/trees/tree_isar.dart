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

  @Index()
  @override
  int? remoteId;
  late String name;
  IsarLink<TreeLevelIsar> treeLevel = IsarLink<TreeLevelIsar>();
  IsarLink<TreeIsar> parent = IsarLink<TreeIsar>();
  late DateTime startDate;
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  @override
  DateTime updatedAt = DateTime.now();

  @override
  bool isSynced = false;

  TreeIsar();

  static Future<TreeLevelIsar> findOrBuildTreeLevel(
      int id, TreeLevel treeLevel) async {
    final tl = await DatabaseService.db.treeLevelIsars
        .filter()
        .remoteIdEqualTo(id)
        .findFirst();

    if (tl != null) return tl;

    final newTl = TreeLevelIsar.toRemote(treeLevel);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.treeLevelIsars.put(newTl);
    });
    return newTl;
  }

  static Future<TreeIsar> findOrBuildTree(int? id, Tree tree) async {
    TreeIsar? t;
    if (id != null) {
      t = await DatabaseService.db.treeIsars
          .filter()
          .remoteIdEqualTo(id)
          .findFirst();
    }
    if (t != null) return t;

    final newT = await TreeIsar.toRemote(tree);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.treeIsars.put(newT);
    });
    return newT;
  }

  static Future<TreeIsar> toRemote(Tree tree) async {
    final treeIsar = TreeIsar()
      ..remoteId = tree.remoteId
      ..name = tree.name
      ..startDate = tree.startDate
      ..endDate = tree.endDate
      ..createdAt = tree.createdAt
      ..updatedAt = tree.updatedAt
      ..isSynced = true;

    // Usar o objeto já existente ou criar novo (TreeLevel)
    final treeLevelIsar =
        await findOrBuildTreeLevel(tree.treeLevel.remoteId, tree.treeLevel);
    treeIsar.treeLevel.value = treeLevelIsar;

    // Recursivamente associar o parent (se existir)
    if (tree.parent != null) {
      final parentIsar = await findOrBuildTree(tree.parent?.remoteId, tree);
      treeIsar.parent.value = parentIsar;
    }

    return treeIsar;
  }

  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    return TreeIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
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
        remoteId: remoteId ?? 0,
        name: name,
        treeLevel: treeLevel.value!.toEntity(),
        parent: parent.value?.toEntity(),
        startDate: startDate,
        endDate: endDate,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }

  @override
  String toString() {
    return name;
  }

  @override
  Future<void> updateFromApiEntity(Tree entity) async {
    remoteId = entity.remoteId;
    name = entity.name;

    final treeLevelIsar =
        await findOrBuildTreeLevel(entity.treeLevel.remoteId, entity.treeLevel);
    treeLevel.value = treeLevelIsar;

    if (entity.parent != null) {
      final parentIsar =
          await findOrBuildTree(entity.parent?.remoteId, entity.parent!);
      parent.value = parentIsar;
    }

    startDate = entity.startDate;
    endDate = entity.endDate;
    createdAt = entity.createdAt;
    updatedAt = entity.updatedAt;
    isSynced = true;
  }
}
