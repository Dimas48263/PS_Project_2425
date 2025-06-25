import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities/entities.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities/entities_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/building_types/building_type.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/building_types/building_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcaps/zcap.dart';

part 'zcap_isar.g.dart';

@collection
class ZcapIsar implements IsarTable<Zcap> {
  @override
  Id id = Isar.autoIncrement;

  @override
  bool isSynced = false;

  @Index()
  @override
  int? remoteId;

  late String name;
  late String address;

  IsarLink<BuildingTypesIsar> buildingType = IsarLink<BuildingTypesIsar>();
  IsarLink<TreeIsar> tree = IsarLink<TreeIsar>();
  IsarLink<EntitiesIsar> zcapEntity = IsarLink<EntitiesIsar>();

  double? latitude;
  double? longitude;

  late DateTime startDate;
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  @override
  DateTime lastUpdatedAt = DateTime.now();

  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    return ZcapIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name
      ..buildingType.value = buildingType.value
      ..address = address
      ..tree.value = tree.value
      ..latitude = latitude
      ..longitude = longitude
      ..zcapEntity.value = zcapEntity.value
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }

  @override
  Zcap toEntity() {
    return Zcap(
      remoteId: remoteId ?? 0,
      name: name,
      buildingType: buildingType.value?.toEntity(),
      address: address,
      tree: tree.value?.toEntity(),
      latitude: latitude,
      longitude: longitude,
      zcapEntity: zcapEntity.value?.toEntity(),
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
      isSynced: isSynced,
    );
  }

  static Future<ZcapIsar> toRemote(Zcap zcap) async {
    final remote = ZcapIsar()
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

    remote.buildingType.value = zcap.buildingType != null ? await getOrBuildBuildingType(zcap.buildingType!) : null;
    remote.tree.value = zcap.tree != null ? await getOrBuildTree(zcap.tree!) : null;
    remote.zcapEntity.value = zcap.zcapEntity != null ? await getOrBuildEntity(zcap.zcapEntity!) : null;

    return remote;
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
            .remoteIdEqualTo(zcap.buildingType!.remoteId)
            .findFirst() ??
        BuildingTypesIsar.toRemote(zcap.buildingType!);
    buildingType.value = buildingTypeIsar as BuildingTypesIsar?;


    if (zcap.tree != null) {
      final treeIsar =
          await TreeIsar.findOrBuildTree(zcap.tree!.remoteId, zcap.tree!);
      tree.value = treeIsar;
    } else {
      tree.value = null;
    }

    final entityIsar = await DatabaseService.db.entitiesIsars
            .filter()
            .remoteIdEqualTo(zcap.zcapEntity!.remoteId)
            .findFirst() ??
        EntitiesIsar.fromEntity(zcap.zcapEntity!);
    zcapEntity.value = entityIsar as EntitiesIsar?;

  }

  static Future<BuildingTypesIsar> getOrBuildBuildingType(
      BuildingType buildingType) async {
    BuildingTypesIsar? buildingTypesIsar = await DatabaseService
        .db.buildingTypesIsars
        .where()
        .remoteIdEqualTo(buildingType.remoteId)
        .findFirst();
    if (buildingTypesIsar != null) return buildingTypesIsar;

    BuildingTypesIsar newBuildingType =
        await BuildingTypesIsar.toRemote(buildingType);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.buildingTypesIsars.put(newBuildingType);
    });
    return newBuildingType;
  }

  static Future<TreeIsar> getOrBuildTree(Tree tree) async {
    TreeIsar? treeIsar = await DatabaseService.db.treeIsars
        .where()
        .remoteIdEqualTo(tree.remoteId)
        .findFirst();
    if (treeIsar != null) return treeIsar;

    TreeIsar newTree = await TreeIsar.toRemote(tree);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.treeIsars.put(newTree);
    });
    return newTree;
  }

  static Future<EntitiesIsar> getOrBuildEntity(Entity zcapEntity) async {
    EntitiesIsar? entityIsar = await DatabaseService.db.entitiesIsars
        .where()
        .remoteIdEqualTo(zcapEntity.remoteId)
        .findFirst();
    if (entityIsar != null) return entityIsar;

    EntitiesIsar newEntity = await EntitiesIsar.toRemote(zcapEntity);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.entitiesIsars.put(newEntity);
    });
    return newEntity;
  }
}
