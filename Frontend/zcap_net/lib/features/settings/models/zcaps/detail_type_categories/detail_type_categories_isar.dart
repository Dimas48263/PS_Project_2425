import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/detail_type_categories/detail_type_categories.dart';

part 'detail_type_categories_isar.g.dart';

@collection
class DetailTypeCategoriesIsar implements IsarTable<DetailTypeCategories> {
  @override
  Id id = Isar.autoIncrement;

  @Index()
  @override
  int? remoteId;

  late String name = "";

  late DateTime startDate;
  DateTime? endDate;
  late DateTime createdAt;
  @override
  late DateTime lastUpdatedAt;

  @override
  bool isSynced = false;

  DetailTypeCategoriesIsar();

  factory DetailTypeCategoriesIsar.fromEntity(
          DetailTypeCategories detailTypeCategories) =>
      DetailTypeCategoriesIsar()
        ..remoteId = detailTypeCategories.remoteId
        ..name = detailTypeCategories.name
        ..startDate = detailTypeCategories.startDate
        ..endDate = detailTypeCategories.endDate
        ..createdAt = detailTypeCategories.createdAt
        ..lastUpdatedAt = detailTypeCategories.lastUpdatedAt
        ..isSynced = true;

  @override
  DetailTypeCategories toEntity() => DetailTypeCategories(
        remoteId: remoteId ?? 0,
        name: name,
        startDate: startDate,
        endDate: endDate,
        createdAt: createdAt,
        lastUpdatedAt: lastUpdatedAt,
      );

  DetailTypeCategoriesIsar copyWith(
      {int? id,
      int? remoteId,
      String? name,
      DateTime? startDate,
      DateTime? endDate,
      DateTime? createdAt,
      DateTime? lastUpdatedAt,
      bool? isSynced}) {
    return DetailTypeCategoriesIsar()
      ..id = id ?? this.id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name ?? this.name
      ..startDate = startDate ?? this.startDate
      ..endDate = endDate ?? this.endDate
      ..createdAt = createdAt ?? this.createdAt
      ..lastUpdatedAt = lastUpdatedAt ?? this.lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }

  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    return DetailTypeCategoriesIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }

  @override
  Future<void> updateFromApiEntity(DetailTypeCategories detailTypeCategories) async {
    remoteId = detailTypeCategories.remoteId;
    name = detailTypeCategories.name;
    startDate = detailTypeCategories.startDate;
    endDate = detailTypeCategories.endDate;
    createdAt = detailTypeCategories.createdAt;
    lastUpdatedAt = detailTypeCategories.lastUpdatedAt;
    isSynced = true;
  }

  @override
  String toString() {
    return name;
  }
}
