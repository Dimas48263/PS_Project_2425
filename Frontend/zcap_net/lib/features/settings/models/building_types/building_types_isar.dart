import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/building_types/building_type.dart';

part 'building_types_isar.g.dart';

@collection
class BuildingTypesIsar implements IsarTable<BuildingType> {
  /*Local variables*/
  @override
  Id id = Isar.autoIncrement;

  @Index()
  @override
  bool isSynced = false;

  /* Remote variables */
  @Index()
  @override
  late int remoteId;

  @Index(type: IndexType.value)
  String name = "";

  DateTime startDate = DateTime(DateTime.now().year, 1, 1);
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  @override
  DateTime updatedAt = DateTime.now();

  // Construtor sem nome (necessário para o Isar)
  BuildingTypesIsar();

  factory BuildingTypesIsar.toRemote(BuildingType buildingType) {
    return BuildingTypesIsar()
      ..remoteId = buildingType.remoteId
      ..name = buildingType.name
      ..startDate = buildingType.startDate
      ..endDate = buildingType.endDate
      ..createdAt = buildingType.createdAt
      ..updatedAt = buildingType.updatedAt
      ..isSynced = true;
  }

  @override
  BuildingType toEntity() {
    return BuildingType(
      remoteId: remoteId,
      name: name,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      updatedAt: updatedAt
    );
  }

  BuildingTypesIsar copyWith({
    int? id,
    int? remoteId,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    final copy = BuildingTypesIsar()
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

  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    return BuildingTypesIsar()
      ..id = id 
      ..remoteId = remoteId ?? this.remoteId
      ..name = name 
      ..startDate = startDate 
      ..endDate = endDate 
      ..createdAt = createdAt 
      ..updatedAt = updatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }

  @override
  Future<void> updateFromApiEntity(BuildingType entity) async{
    remoteId = entity.remoteId;
    name = entity.name;
    startDate = entity.startDate;
    endDate = entity.endDate;
    createdAt = entity.createdAt;
    updatedAt = entity.updatedAt;
    isSynced = true;
  }

  // Método para converter a partir do modelo BuildingType
  factory BuildingTypesIsar.fromBuildingType(BuildingTypesIsar building) {
    return BuildingTypesIsar()
      ..id = building.id
      ..name = building.name
      ..startDate = building.startDate
      ..endDate = building.endDate
      ..createdAt = building.createdAt
      ..updatedAt = building.updatedAt
      ..isSynced = building.isSynced;
  }

  // Método para converter para o modelo EntityType
  BuildingType toBuildingType() {
    return BuildingType(
      remoteId: id,
      name: name,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
    );
  }
}
