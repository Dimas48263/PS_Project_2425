import 'package:isar/isar.dart';
import 'package:zcap_net_app/features/settings/models/building_types/building_type.dart';

part 'building_types_isar.g.dart';

@collection
class BuildingTypesIsar {
  /*Local variables*/
  Id id = Isar.autoIncrement;
  bool isSynced = false;
  
  /* Remote variables */
  int? remoteId; 

  @Index(type: IndexType.value)
  String name = "";

  DateTime startDate = DateTime(DateTime.now().year, 1, 1);
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  
  // Construtor sem nome (necessário para o Isar)
  BuildingTypesIsar();

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
      id: id,
      name: name,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
    );
  }
}
