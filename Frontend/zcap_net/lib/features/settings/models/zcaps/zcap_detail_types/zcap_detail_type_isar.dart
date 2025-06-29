import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/data_types/data_types.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/detail_type_categories/detail_type_categories.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/detail_type_categories/detail_type_categories_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_detail_types/zcap_detail_type.dart';

part 'zcap_detail_type_isar.g.dart';

@collection
class ZcapDetailTypeIsar implements IsarTable {
  @override
  Id id = Isar.autoIncrement;
  @override
  bool isSynced = false;

  @Index()
  @override
  int? remoteId;

  late String name;
  IsarLink<DetailTypeCategoriesIsar> detailTypeCategory = IsarLink<DetailTypeCategoriesIsar>();
  @enumerated
  late DataTypes dataType;
  late bool isMandatory;

  @Index()
  late DateTime startDate;
  @Index()
  DateTime? endDate;
  late DateTime createdAt;
  @override
  late DateTime lastUpdatedAt;

  ZcapDetailTypeIsar();
  
  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    return ZcapDetailTypeIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name
      ..detailTypeCategory.value = detailTypeCategory.value
      ..dataType = dataType
      ..isMandatory = isMandatory
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }
  
  @override
  ZcapDetailType toEntity() {
    return ZcapDetailType(
      remoteId: remoteId ?? 0,
      name: name,
      detailTypeCategory: detailTypeCategory.value!.toEntity(),
      dataType: dataType,
      isMandatory: isMandatory,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt
    );
  }
  
  @override
  Future<void> updateFromApiEntity(ApiTable entity) async {
    final zcapDetailType = entity as ZcapDetailType;
    remoteId = zcapDetailType.remoteId;
    name = zcapDetailType.name;
    detailTypeCategory.value = DetailTypeCategoriesIsar.fromEntity(zcapDetailType.detailTypeCategory);
    dataType = zcapDetailType.dataType;
    isMandatory = zcapDetailType.isMandatory;
    startDate = zcapDetailType.startDate;
    endDate = zcapDetailType.endDate;
    createdAt = zcapDetailType.createdAt;
    lastUpdatedAt = zcapDetailType.lastUpdatedAt;
    isSynced = true;
  }

  static Future<ZcapDetailTypeIsar> toRemote(ZcapDetailType zcapDetailType) async {
    final zcapDetailTypeIsar = ZcapDetailTypeIsar()
      ..remoteId = zcapDetailType.remoteId
      ..name = zcapDetailType.name
      ..dataType = zcapDetailType.dataType
      ..isMandatory = zcapDetailType.isMandatory
      ..startDate = zcapDetailType.startDate
      ..endDate = zcapDetailType.endDate
      ..createdAt = zcapDetailType.createdAt
      ..lastUpdatedAt = zcapDetailType.lastUpdatedAt
      ..isSynced = true;

    final DetailTypeCategoriesIsar detailTypeCategory = await findOrBuildDetailTypeCategory(zcapDetailType.detailTypeCategory);
    zcapDetailTypeIsar.detailTypeCategory.value = detailTypeCategory;
    return zcapDetailTypeIsar;
  }

  static Future<DetailTypeCategoriesIsar> findOrBuildDetailTypeCategory(DetailTypeCategories detailTypeCategory) async {
    final detailTypeCategoriesIsar = await DatabaseService.db.detailTypeCategoriesIsars.filter().remoteIdEqualTo(detailTypeCategory.remoteId).findFirst();
    if (detailTypeCategoriesIsar != null) {
      return detailTypeCategoriesIsar;
    }
    final newDetailTypeCategory = DetailTypeCategoriesIsar.fromEntity(detailTypeCategory);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.detailTypeCategoriesIsars.put(newDetailTypeCategory);
    });
    return newDetailTypeCategory;
  }

  @override
  String toString() {
    return name;
  }
}