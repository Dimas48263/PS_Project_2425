import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities/entities.dart';
import 'package:zcap_net_app/features/settings/models/entities/entity_types/entity_type.dart';
import 'package:zcap_net_app/features/settings/models/entities/entity_types/entity_type_isar.dart';

part 'entities_isar.g.dart';

@Collection()
class EntitiesIsar implements IsarTable<Entity> {
  /*Local variables*/
  @override
  Id id = Isar.autoIncrement;
  @override
  bool isSynced = false;

  /* Remote variables */
  @override
  @Index()
  int? remoteId;

  @Index(type: IndexType.value)
  String name = "";
  String? email;
  String phone1 = "";
  String? phone2;

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
  Future<void> updateFromApiEntity(Entity e) async {
    remoteId = e.remoteId;
    name = e.name;
    email = e.email;
    phone1 = e.phone1;
    phone2 = e.phone2;
    startDate = e.startDate;
    endDate = e.endDate;
    createdAt = e.createdAt;
    lastUpdatedAt = e.lastUpdatedAt;
    isSynced = true;

    final entType = await findOrBuildEntityType(e.entityType);
    DatabaseService.db.writeTxn(() async {
      entityType.value = entType;
      await entityType.save();
    });
  }

  static Future<EntityTypeIsar> findOrBuildEntityType(
      EntityType entityType) async {
    EntityTypeIsar? i;

    i = await DatabaseService.db.entityTypeIsars
        .filter()
        .remoteIdEqualTo(entityType.remoteId)
        .findFirst();

    if (i != null) return i;

    final newI = EntityTypeIsar.fromEntityType(entityType);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.entityTypeIsars.put(newI);
    });
    return newI;
  }

  static Future<EntitiesIsar> fromEntity(Entity e) async {
    final isarEntity = EntitiesIsar()
      ..remoteId = e.remoteId
      ..name = e.name
      ..email = e.email
      ..phone1 = e.phone1
      ..phone2 = e.phone2
      ..startDate = e.startDate
      ..endDate = e.endDate
      ..createdAt = e.createdAt
      ..lastUpdatedAt = e.lastUpdatedAt
      ..isSynced = true;

    final entityTypeIsar = await findOrBuildEntityType(e.entityType);
    isarEntity.entityType.value = entityTypeIsar;

    return isarEntity;
  }

  @override
  Entity toEntity() {
    return Entity(
      remoteId: remoteId ?? -1,
      name: name,
      entityType: entityType.value?.toEntity() ??
          EntityType(
            remoteId: -1,
            name: '',
            startDate: DateTime.now(),
            createdAt: DateTime.now(),
            lastUpdatedAt: DateTime.now(),
          ),
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
      ..entityType.value = entityType.value
      ..email = email
      ..phone1 = phone1
      ..phone2 = phone2
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt ?? this.lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }

  static Future<EntitiesIsar> toRemote(Entity zcapEntity) async {
    final remote =  EntitiesIsar()
      ..remoteId = zcapEntity.remoteId
      ..name = zcapEntity.name
      ..email = zcapEntity.email
      ..phone1 = zcapEntity.phone1
      ..phone2 = zcapEntity.phone2
      ..startDate = zcapEntity.startDate
      ..endDate = zcapEntity.endDate
      ..createdAt = zcapEntity.createdAt
      ..lastUpdatedAt = zcapEntity.lastUpdatedAt
      ..isSynced = true;

      remote.entityType.value = await getOrBuildEntityType(zcapEntity.entityType);

      return remote;
  }

    static Future<EntityTypeIsar> getOrBuildEntityType(EntityType entityType) async {
    EntityTypeIsar? entityTypeIsar = await DatabaseService.db.entityTypeIsars.where().remoteIdEqualTo(entityType.remoteId).findFirst();
    if (entityTypeIsar != null) return entityTypeIsar;

    EntityTypeIsar newEntityType = EntityTypeIsar.toRemote(entityType);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.entityTypeIsars.put(newEntityType);
    });
    return newEntityType;
  }
}
