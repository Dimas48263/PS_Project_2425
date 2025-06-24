import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities/entities_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/building_types/building_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcaps/zcap.dart';

part 'zcap_isar.g.dart';

@collection
class ZcapIsar implements IsarTable<Zcap> {
  @override
  Id id = Isar.autoIncrement;

  @Index()
  @override
  late int remoteId;

  late String name;
  IsarLink<BuildingTypesIsar> buildingType = IsarLink<BuildingTypesIsar>();
  late String address;

  IsarLink<TreeIsar> tree = IsarLink<TreeIsar>();

  double? latitude;
  double? longitude;

  IsarLink<EntitiesIsar> zcapEntity = IsarLink<EntitiesIsar>();


  @Index()
  late DateTime startDate;

  DateTime? endDate;
  late DateTime createdAt;

  @override
  late DateTime lastUpdatedAt;

  @Index()
  @override
  bool isSynced = false;

  ZcapIsar();

  static Future<ZcapIsar> toRemote(Zcap zcap) async {
    final zcapIsar = ZcapIsar()
      ..remoteId = zcap.remoteId
      ..name = zcap.name
      ..address = zcap.address
      ..latitude = zcap.latitude
      ..longitude = zcap.longitude
      ..startDate = zcap.startDate
      ..endDate = zcap.endDate
      ..createdAt = zcap.createdAt
      ..lastUpdatedAt = zcap.lastUpdatedAt
      ..isSynced = true;

    final buildingTypeIsar = await DatabaseService.db.buildingTypesIsars
            .filter()
            .remoteIdEqualTo(zcap.buildingType.remoteId)
            .findFirst() ??
        BuildingTypesIsar.toRemote(zcap.buildingType);

    zcapIsar.buildingType.value = buildingTypeIsar;


    if (zcap.tree != null) {
      final treeIsar =
          await TreeIsar.findOrBuildTree(zcap.tree!.remoteId, zcap.tree!);
      zcapIsar.tree.value = treeIsar;
    }

    final entityIsar = await DatabaseService.db.entitiesIsars
        .filter()
        .remoteIdEqualTo(zcap.zcapEntity.remoteId)
        .findFirst() ??
        EntitiesIsar.fromEntity(zcap.zcapEntity);

    zcapIsar.zcapEntity.value = entityIsar as EntitiesIsar?;

    return zcapIsar;
  }

  @override
  Zcap toEntity() {
    return Zcap(
      remoteId: remoteId,
      name: name,
      buildingType: buildingType.value!.toEntity(),
      address: address,
      tree: tree.value?.toEntity(),
      latitude: latitude,
      longitude: longitude,
      zcapEntity: zcapEntity.value!.toEntity(),
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
      isSynced: isSynced,
    );
  }

  @override
  Future<void> updateFromApiEntity(Zcap zcap) async {
    remoteId = zcap.remoteId;
    name = zcap.name;
    address = zcap.address;
    latitude = zcap.latitude;
    longitude = zcap.longitude;
    startDate = zcap.startDate;
    endDate = zcap.endDate;
    createdAt = zcap.createdAt;
    lastUpdatedAt = zcap.lastUpdatedAt;
    isSynced = true;

    final buildingTypeIsar = await DatabaseService.db.buildingTypesIsars
            .filter()
            .remoteIdEqualTo(zcap.buildingType.remoteId)
            .findFirst() ??
        BuildingTypesIsar.toRemote(zcap.buildingType);
    buildingType.value = buildingTypeIsar;

    if (zcap.tree != null) {
      final treeIsar =
          await TreeIsar.findOrBuildTree(zcap.tree!.remoteId, zcap.tree!);
      tree.value = treeIsar;
    } else {
      tree.value = null;
    }

    final entityIsar = await DatabaseService.db.entitiesIsars
        .filter()
        .remoteIdEqualTo(zcap.zcapEntity.remoteId)
        .findFirst() ??
        EntitiesIsar.fromEntity(zcap.zcapEntity);
    zcapEntity.value = entityIsar as EntitiesIsar?;
  }

  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    return ZcapIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name
      ..address = address
      ..tree = tree
      ..latitude = latitude
      ..longitude = longitude
      ..zcapEntity = zcapEntity
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced
      ..buildingType.value = buildingType.value;
  }
}
