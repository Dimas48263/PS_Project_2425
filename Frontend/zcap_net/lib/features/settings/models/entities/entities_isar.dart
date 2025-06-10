import 'package:isar/isar.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities.dart';
import 'package:zcap_net_app/features/settings/models/entity_types/entity_type_isar.dart';

part 'entities_isar.g.dart';

@Collection()
class EntitiesIsar {
  /*Local variables*/
  Id id = Isar.autoIncrement;
  bool isSynced = false;

  /* Remote variables */
  int? remoteId;

  @Index(type: IndexType.value)
  String name = "";

  final entityType = IsarLink<EntityTypeIsar>();

  DateTime startDate = DateTime(DateTime.now().year, 1, 1);
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  EntitiesIsar();

  EntitiesIsar copyWith({
    int? id,
    int? remoteId,
    String? name,
    IsarLink<EntityTypeIsar>? entityType,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    final copy = EntitiesIsar()
      ..id = id ?? this.id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name ?? this.name
      ..entityType.value = entityType?.value ?? this.entityType.value
      ..startDate = startDate ?? this.startDate
      ..endDate = endDate ?? this.endDate
      ..createdAt = createdAt ?? this.createdAt
      ..updatedAt = updatedAt ?? DateTime.now()
      ..isSynced = isSynced ?? this.isSynced;

    return copy;
  }

  factory EntitiesIsar.fromEntity(Entity entity) {
  final isarEntity = EntitiesIsar()
    ..remoteId = entity.id
    ..name = entity.name
    ..startDate = entity.startDate
    ..endDate = entity.endDate
    ..createdAt = entity.createdAt
    ..updatedAt = entity.updatedAt
    ..isSynced = true;

  isarEntity.entityType.value = EntityTypeIsar()..remoteId = entity.entityTypeId;
  return isarEntity;
}

Entity toEntity() {
  return Entity(
    id: remoteId ?? -1,
    name: name,
    entityTypeId: entityType.value?.remoteId ?? -1,
    startDate: startDate,
    endDate: endDate,
    createdAt: createdAt,
    updatedAt: updatedAt,
    isSynced: isSynced,
  );
}

}
