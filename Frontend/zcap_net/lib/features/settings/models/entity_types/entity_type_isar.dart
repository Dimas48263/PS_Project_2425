import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'entity_type.dart';

part 'entity_type_isar.g.dart';

@collection
class EntityTypeIsar implements IsarTable<EntityType> {
  /*Local variables*/
  @override
  Id id = Isar.autoIncrement;
  @override
  bool isSynced = false;

  /* Remote variables */
  @override
  int? remoteId;

  @Index(type: IndexType.value)
  String name = "";

  DateTime startDate = DateTime(DateTime.now().year, 1, 1);
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // Construtor sem nome (necessário para o Isar)
  EntityTypeIsar();

  EntityTypeIsar copyWith({
    int? id,
    int? remoteId,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    final copy = EntityTypeIsar()
      ..id = id ?? this.id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name ?? this.name
      ..startDate = startDate ?? this.startDate
      ..endDate = endDate ?? this.endDate
      ..createdAt = createdAt ?? this.createdAt
      ..updatedAt = updatedAt ?? this.updatedAt
      ..isSynced = isSynced ?? this.isSynced;

    return copy;
  }

  void updateFromApiEntity(EntityType entity) {
    remoteId = entity.remoteId;
    name = entity.name;
    startDate = entity.startDate;
    endDate = entity.endDate;
    createdAt = entity.createdAt;
    updatedAt = entity.updatedAt;
    isSynced = true;
  }

  // Método para converter a partir do modelo EntityType
  factory EntityTypeIsar.fromEntityType(EntityType entity) {
    return EntityTypeIsar()
      ..remoteId = entity.remoteId
      ..name = entity.name
      ..startDate = entity.startDate
      ..endDate = entity.endDate
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..isSynced = entity.isSynced;
  }

  // Método para converter para o modelo EntityType
  @override
  EntityType toEntity() {
    return EntityType(
      remoteId: remoteId ?? -1,
      name: name,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
    );
  }

  @override
  EntityTypeIsar setEntityIdAndSync(
      {int? remoteId, bool? isSynced, DateTime? updatedAt}) {
    return EntityTypeIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..updatedAt = updatedAt ?? this.updatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }
}
