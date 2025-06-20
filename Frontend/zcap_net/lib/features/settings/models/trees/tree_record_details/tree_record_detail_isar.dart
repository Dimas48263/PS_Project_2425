
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_detail_types/tree_record_detail_type.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_detail_types/tree_record_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_details/tree_record_detail.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree_isar.dart';

part 'tree_record_detail_isar.g.dart';

@collection
class TreeRecordDetailIsar implements IsarTable<TreeRecordDetail> {
  @override
  Id id = Isar.autoIncrement;
  
  @override
  bool isSynced = false;

  @Index()
  @override
  int? remoteId;

  IsarLink<TreeIsar> tree = IsarLink<TreeIsar>();
  IsarLink<TreeRecordDetailTypeIsar> detailType = IsarLink<TreeRecordDetailTypeIsar>();
  late String valueCol;
  late DateTime startDate;
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  @override
  DateTime lastUpdatedAt = DateTime.now(); 
  
  @override
  TreeRecordDetailIsar setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    return TreeRecordDetailIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..tree.value = tree.value
      ..detailType.value = detailType.value
      ..valueCol = valueCol
      ..startDate = startDate 
      ..endDate = endDate 
      ..createdAt = createdAt 
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }
  
  @override
  TreeRecordDetail toEntity() {
    return TreeRecordDetail(
      remoteId: remoteId ?? 0, 
      tree: tree.value!.toEntity(), 
      detailType: detailType.value!.toEntity(), 
      valueCol: valueCol, 
      startDate: startDate, 
      createdAt: createdAt, 
      lastUpdatedAt: lastUpdatedAt
      );
  }
  
  @override
  String toString() {
    return 'Detalhe do tipo ${detailType.value?.name}';
  }

  static Future<TreeRecordDetailIsar> toRemote(TreeRecordDetail trd) async {
    final remote = TreeRecordDetailIsar()
      ..remoteId = trd.remoteId
      ..valueCol = trd.valueCol
      ..startDate = trd.startDate
      ..endDate = trd.endDate
      ..createdAt = trd.createdAt
      ..lastUpdatedAt = trd.lastUpdatedAt
      ..isSynced = true;

    remote.tree.value = await getOrBuildTree(trd.tree);
    remote.detailType.value = await getOrBuildDetailType(trd.detailType);

    return remote;
  }
  
  @override
  Future<void> updateFromApiEntity(TreeRecordDetail entity) async {
    remoteId = entity.remoteId;
    valueCol = entity.valueCol;
    startDate = entity.startDate;
    endDate = entity.endDate;
    createdAt = entity.createdAt;
    lastUpdatedAt = entity.lastUpdatedAt;
    isSynced = true;
  }

  static Future<TreeIsar> getOrBuildTree(Tree tree) async {
    TreeIsar? treeIsar = await DatabaseService.db.treeIsars.where().remoteIdEqualTo(tree.remoteId).findFirst();
    if (treeIsar != null) return treeIsar;

    TreeIsar newTree = await TreeIsar.toRemote(tree);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.treeIsars.put(newTree);
    });
    return newTree;
  }

  static Future<TreeRecordDetailTypeIsar> getOrBuildDetailType(TreeRecordDetailType detailType) async {
    TreeRecordDetailTypeIsar? detailTypeIsar = await DatabaseService.db.treeRecordDetailTypeIsars.where().remoteIdEqualTo(detailType.remoteId).findFirst();
    if (detailTypeIsar != null) return detailTypeIsar;

    TreeRecordDetailTypeIsar newdetailType = TreeRecordDetailTypeIsar.toRemote(detailType);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.treeRecordDetailTypeIsars.put(newdetailType);
    });
    return newdetailType;
  }
}