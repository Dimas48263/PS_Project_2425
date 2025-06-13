import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/tree_record_detail_types/tree_record_detail_type.dart';

part 'tree_record_detail_type_isar.g.dart';

@collection
class TreeRecordDetailTypeIsar implements IsarTable<TreeRecordDetailType> {
  @override
  Id id = Isar.autoIncrement;

  @Index()
  @override
  int? remoteId;
  late String name;
  late String unit;
  late DateTime startDate;
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  @override
  DateTime updatedAt = DateTime.now();

  @override
  bool isSynced = false;

  TreeRecordDetailTypeIsar();

  @override
  TreeRecordDetailTypeIsar setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    return TreeRecordDetailTypeIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name
      ..unit = unit
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }

  @override
  TreeRecordDetailType toEntity() {
    return TreeRecordDetailType(
        remoteId: remoteId ?? 0,
        name: name,
        unit: unit,
        startDate: startDate,
        endDate: endDate,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }

  @override
  String toString() {
    return name;
  }

  static TreeRecordDetailTypeIsar toRemote(TreeRecordDetailType detailType) {
    return TreeRecordDetailTypeIsar()
      ..remoteId = detailType.remoteId
      ..name = detailType.name
      ..unit = detailType.unit
      ..startDate = detailType.startDate
      ..endDate = detailType.endDate
      ..createdAt = detailType.createdAt
      ..updatedAt = detailType.updatedAt
      ..isSynced = true;
  }

  @override
  Future<void> updateFromApiEntity(TreeRecordDetailType entity) async {
    remoteId = entity.remoteId;
    name = entity.name;
    unit = entity.unit;
    startDate = entity.startDate;
    endDate = entity.endDate;
    createdAt = entity.createdAt;
    updatedAt = entity.updatedAt;
    isSynced = true;
  }
}
