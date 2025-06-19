import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'relation_type.dart';

part 'relation_type_isar.g.dart';

@collection
class RelationTypeIsar implements IsarTable<RelationType> {
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
  RelationTypeIsar();

  RelationTypeIsar copyWith({
    int? id,
    int? remoteId,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    bool? isSynced,
  }) {
    final copy = RelationTypeIsar()
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
  Future<void> updateFromApiEntity(RelationType relation_type) async {
    remoteId = relation_type.remoteId;
    name = relation_type.name;
    startDate = relation_type.startDate;
    endDate = relation_type.endDate;
    createdAt = relation_type.createdAt;
    lastUpdatedAt = relation_type.lastUpdatedAt;
    isSynced = true;
  }

  // Método para converter a partir do modelo EntityType
  factory RelationTypeIsar.fromEntityType(RelationType relation_type) {
    return RelationTypeIsar()
      ..remoteId = relation_type.remoteId
      ..name = relation_type.name
      ..startDate = relation_type.startDate
      ..endDate = relation_type.endDate
      ..createdAt = relation_type.createdAt
      ..lastUpdatedAt = relation_type.lastUpdatedAt
      ..isSynced = relation_type.isSynced;
  }

  // Método para converter para o modelo RelationType
  @override
  RelationType toEntity() {
    return RelationType(
      remoteId: remoteId ?? -1,
      name: name,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
      isSynced: isSynced,
    );
  }

  factory RelationTypeIsar.toRemote(RelationType relation_type) {
    return RelationTypeIsar()
      ..remoteId = relation_type.remoteId
      ..name = relation_type.name
      ..startDate = relation_type.startDate
      ..endDate = relation_type.endDate
      ..createdAt = relation_type.createdAt
      ..lastUpdatedAt = relation_type.lastUpdatedAt
      ..isSynced = true;
  }

  @override
  RelationTypeIsar setEntityIdAndSync(
      {int? remoteId, bool? isSynced, DateTime? lastUpdatedAt}) {
    return RelationTypeIsar()
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