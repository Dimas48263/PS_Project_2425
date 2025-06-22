import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'detail_type_category.dart';

part 'detail_type_category_isar.g.dart';

@collection
class DetailTypeCategoryIsar implements IsarTable<DetailTypeCategory> {
  /*Local variables*/
  @override
  Id id = Isar.autoIncrement;
  @override
  bool isSynced = false;

  /* Remote variables */
  @Index()
  @override
  int? remoteId;

  @Index(type: IndexType.value)
  String name = "";

  DateTime startDate = DateTime(DateTime.now().year, 1, 1);
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  @override
  DateTime lastUpdatedAt = DateTime.now();

  // Construtor sem nome (necessário para o Isar)
  DetailTypeCategoryIsar();

  DetailTypeCategoryIsar copyWith({
    int? id,
    int? remoteId,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    bool? isSynced,
  }) {
    final copy = DetailTypeCategoryIsar()
      ..id = id ?? this.id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name ?? this.name
      ..startDate = startDate ?? this.startDate
      ..endDate = endDate ?? this.endDate
      ..createdAt = createdAt ?? this.createdAt
      ..lastUpdatedAt = lastUpdatedAt ?? this.lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;

    return copy;
  }

  @override
  Future<void> updateFromApiEntity(DetailTypeCategory entity) async {
    remoteId = entity.remoteId;
    name = entity.name;
    startDate = entity.startDate;
    endDate = entity.endDate;
    createdAt = entity.createdAt;
    lastUpdatedAt = entity.lastUpdatedAt;
    isSynced = true;
  }

  // Método para converter a partir do modelo EntityType
  factory DetailTypeCategoryIsar.fromEntityType(DetailTypeCategory entity) {
    return DetailTypeCategoryIsar()
      ..remoteId = entity.remoteId
      ..name = entity.name
      ..startDate = entity.startDate
      ..endDate = entity.endDate
      ..createdAt = entity.createdAt
      ..lastUpdatedAt = entity.lastUpdatedAt
      ..isSynced = entity.isSynced;
  }

  // Método para converter para o modelo EntityType
  @override
  DetailTypeCategory toEntity() {
    return DetailTypeCategory(
      remoteId: remoteId ?? -1,
      name: name,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
      isSynced: isSynced,
    );
  }

  factory DetailTypeCategoryIsar.toRemote(DetailTypeCategory entityType) {
    return DetailTypeCategoryIsar()
      ..remoteId = entityType.remoteId
      ..name = entityType.name
      ..startDate = entityType.startDate
      ..endDate = entityType.endDate
      ..createdAt = entityType.createdAt
      ..lastUpdatedAt = entityType.lastUpdatedAt
      ..isSynced = true;
  }

  @override
  DetailTypeCategoryIsar setEntityIdAndSync(
      {int? remoteId, bool? isSynced, DateTime? lastUpdatedAt}) {
    return DetailTypeCategoryIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt ?? this.lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }
}
