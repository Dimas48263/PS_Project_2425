import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities.dart';
import 'package:zcap_net_app/features/settings/models/entity_types/entity_type_isar.dart';

part 'entities_isar.g.dart';

@Collection()
class EntitiesIsar implements IsarTable<Entity> {
  /*Local variables*/
  Id id = Isar.autoIncrement;
  @override
  bool isSynced = false;

  /* Remote variables */
  @override
  int? remoteId;

  @Index(type: IndexType.value)
  String name = "";
  String email = "";
  String phone1 = "";
  String phone2 = "";

  var entityType = IsarLink<EntityTypeIsar>();

  DateTime startDate = DateTime(DateTime.now().year, 1, 1);
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  @override
  DateTime lastUpdatedAt = DateTime.now();

  EntitiesIsar();

  EntitiesIsar copyWith({
    int? id,
    int? remoteId,
    String? name,
    IsarLink<EntityTypeIsar>? entityType,
    String? email,
    String? phone1,
    String? phone2,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    bool? isSynced,
  }) {
    final copy = EntitiesIsar()
      ..id = id ?? this.id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name ?? this.name
      ..entityType.value = entityType?.value ?? this.entityType.value
      ..email = email ?? this.email
      ..phone1 = phone1 ?? this.phone1
      ..phone2 = phone2 ?? this.phone2
      ..startDate = startDate ?? this.startDate
      ..endDate = endDate ?? this.endDate
      ..createdAt = createdAt ?? this.createdAt
      ..lastUpdatedAt = lastUpdatedAt ?? DateTime.now()
      ..isSynced = isSynced ?? this.isSynced;

    return copy;
  }

  @override
  Future<void> updateFromApiEntity(Entity entity) async {
    remoteId = entity.remoteId;
    name = entity.name;
    entityType = entity.entityTypeId as IsarLink<EntityTypeIsar>;
    email = entity.email!;
    phone1 = entity.phone1;
    phone2 = entity.phone2!;
    startDate = entity.startDate;
    endDate = entity.endDate;
    createdAt = entity.createdAt;
    lastUpdatedAt = entity.lastUpdatedAt;
    isSynced = true;
  }

  factory EntitiesIsar.fromEntity(Entity entity) {
    final isarEntity = EntitiesIsar()
      ..remoteId = entity.remoteId
      ..name = entity.name
      ..email = entity.email!
      ..phone1 = entity.phone1
      ..phone2 = entity.phone2!
      ..startDate = entity.startDate
      ..endDate = entity.endDate
      ..createdAt = entity.createdAt
      ..lastUpdatedAt = entity.lastUpdatedAt
      ..isSynced = true;

    isarEntity.entityType.value = EntityTypeIsar()
      ..remoteId = entity.entityTypeId;
    return isarEntity;
  }

  @override
  Entity toEntity() {
    return Entity(
      remoteId: remoteId ?? -1,
      name: name,
      entityTypeId: entityType.value?.remoteId ?? -1,
      email: email,
      phone1: phone1,
      phone2: phone2,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
      isSynced: isSynced,
    );
  }

    @override
  EntitiesIsar setEntityIdAndSync(
      {int? remoteId, bool? isSynced, DateTime? lastUpdatedAt}) {
    return EntitiesIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name
      ..entityType = entityType
      ..email = email
      ..phone1 = phone1
      ..phone2 = phone2
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt ?? this.lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }
}
