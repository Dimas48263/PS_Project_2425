import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/treeLevelDetailType/tree_level_detail_type.dart';
import 'package:zcap_net_app/features/settings/models/tree_levels/tree_level.dart';
import 'package:zcap_net_app/features/settings/models/tree_levels/tree_level_isar.dart';
import 'package:zcap_net_app/features/settings/models/tree_record_detail_types/tree_record_detail_type.dart';
import 'package:zcap_net_app/features/settings/models/tree_record_detail_types/tree_record_detail_type_isar.dart';

part 'tree_level_detail_type_isar.g.dart';

@collection
class TreeLevelDetailTypeIsar implements IsarTable<TreeLevelDetailType>{
  @override
  Id id = Isar.autoIncrement;

  @Index()
  @override
  int? remoteId;

  IsarLink<TreeLevelIsar> treeLevel = IsarLink<TreeLevelIsar>();
  IsarLink<TreeRecordDetailTypeIsar> detailType = IsarLink<TreeRecordDetailTypeIsar>();
  late DateTime startDate;
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  @override
  DateTime lastUpdatedAt = DateTime.now();

  @override
  bool isSynced = false;

  TreeLevelDetailTypeIsar();

  static Future<TreeLevelDetailTypeIsar> toRemote(TreeLevelDetailType tldt) async {
    final tldtIsar = TreeLevelDetailTypeIsar()
      ..remoteId = tldt.remoteId
      ..startDate = tldt.startDate
      ..endDate = tldt.endDate
      ..createdAt = tldt.createdAt
      ..lastUpdatedAt = tldt.lastUpdatedAt
      ..isSynced = true;

    // Usar o objeto já existente ou criar novo (TreeLevel)
    final treeLevelIsar =
        await findOrBuildTreeLevel(tldt.treeLevel);
    tldtIsar.treeLevel.value = treeLevelIsar;

    final detailTypeIsar =
        await findOrBuildDetailType(tldt.detailType);
    tldtIsar.detailType.value = detailTypeIsar;

    return tldtIsar;
  }

  static Future<TreeLevelIsar> findOrBuildTreeLevel(TreeLevel treeLevel) async {
    final tl = await DatabaseService.db.treeLevelIsars
        .filter()
        .remoteIdEqualTo(treeLevel.remoteId)
        .findFirst();

    if (tl != null) return tl;

    final newTl = TreeLevelIsar.toRemote(treeLevel);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.treeLevelIsars.put(newTl);
    });
    return newTl;
  }

  static Future<TreeRecordDetailTypeIsar> findOrBuildDetailType(TreeRecordDetailType detailType) async {
    final dt = await DatabaseService.db.treeRecordDetailTypeIsars
        .filter()
        .remoteIdEqualTo(detailType.remoteId)
        .findFirst();

    if (dt != null) return dt;

    final newDt = TreeRecordDetailTypeIsar.toRemote(detailType);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.treeRecordDetailTypeIsars.put(newDt);
    });
    return newDt;
  }

  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    return TreeLevelDetailTypeIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..treeLevel.value = treeLevel.value
      ..detailType.value = detailType.value
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }

  @override
  TreeLevelDetailType toEntity() {
    return TreeLevelDetailType(
        remoteId: remoteId ?? 0,
        treeLevel: treeLevel.value!.toEntity(),
        detailType: detailType.value!.toEntity(),
        startDate: startDate,
        endDate: endDate,
        createdAt: createdAt,
        lastUpdatedAt: lastUpdatedAt);
  }

  @override
  Future<void> updateFromApiEntity(TreeLevelDetailType tldt) async {
    remoteId = tldt.remoteId;

    final treeLevelIsar =
        await findOrBuildTreeLevel(tldt.treeLevel);
    treeLevel.value = treeLevelIsar;

    final detailTypeIsar =
        await findOrBuildDetailType(tldt.detailType);
    detailType.value = detailTypeIsar;

    startDate = tldt.startDate;
    endDate = tldt.endDate;
    createdAt = tldt.createdAt;
    lastUpdatedAt = tldt.lastUpdatedAt;
    isSynced = true;
  }
}