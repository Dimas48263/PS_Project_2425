import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_types/incident_types.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_types/incident_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incidents/incidents.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree_isar.dart';

part 'incidents_isar.g.dart';

@collection
class IncidentsIsar implements IsarTable<Incidents> {
  @override
  Id id = Isar.autoIncrement;

  @Index()
  @override
  int? remoteId;

  IsarLink<IncidentTypesIsar> incidentType = IsarLink<IncidentTypesIsar>();
  IsarLink<TreeIsar> treeRecord = IsarLink<TreeIsar>();

  @Index()
  late DateTime startDate;
  @Index()
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  @override
  DateTime lastUpdatedAt = DateTime.now();

  @override
  bool isSynced = false;

  IncidentsIsar();

  static Future<IncidentTypesIsar> findOrBuildIncidentType(
      IncidentTypes incidentTypeInput) async {
    final incidentTypeIsar = await DatabaseService.db.incidentTypesIsars
        .filter()
        .remoteIdEqualTo(incidentTypeInput.remoteId)
        .findFirst();

    if (incidentTypeIsar != null) return incidentTypeIsar;

    final newIncidentType = IncidentTypesIsar.toRemote(incidentTypeInput);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.incidentTypesIsars.put(newIncidentType);
    });
    return newIncidentType;
  }

  static Future<TreeIsar> findOrBuildTree(Tree tree) async {
    final treeIsar = await DatabaseService.db.treeIsars
        .filter()
        .remoteIdEqualTo(tree.remoteId)
        .findFirst();

    if (treeIsar != null) return treeIsar;

    final newTree = await TreeIsar.toRemote(tree);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.treeIsars.put(newTree);
      await newTree.treeLevel.save();
      if (tree.parent != null) await newTree.parent.save();
    });
    return newTree;
  }

  static Future<IncidentsIsar> toRemote(Incidents incident) async {
    final incidentIsar = IncidentsIsar();
    incidentIsar.remoteId = incident.remoteId;
    incidentIsar.incidentType.value =
        await findOrBuildIncidentType(incident.incidentType);
    incidentIsar.treeRecord.value = await findOrBuildTree(incident.treeRecord);
    incidentIsar.startDate = incident.startDate;
    incidentIsar.endDate = incident.endDate;
    incidentIsar.createdAt = incident.createdAt;
    incidentIsar.lastUpdatedAt = incident.lastUpdatedAt;
    incidentIsar.isSynced = true;
    return incidentIsar;
  }

  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    return IncidentsIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..incidentType.value = incidentType.value
      ..treeRecord.value = treeRecord.value
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }

  @override
  Incidents toEntity() {
    return Incidents(
        remoteId: remoteId ?? 0,
        incidentType: incidentType.value!.toEntity(),
        treeRecord: treeRecord.value!.toEntity(),
        startDate: startDate,
        endDate: endDate,
        createdAt: createdAt,
        lastUpdatedAt: lastUpdatedAt);
  }

  @override
  Future<void> updateFromApiEntity(Incidents entity) async {
    remoteId = entity.remoteId;
    incidentType.value = await findOrBuildIncidentType(entity.incidentType);
    treeRecord.value = await findOrBuildTree(entity.treeRecord);
    startDate = entity.startDate;
    endDate = entity.endDate;
    createdAt = entity.createdAt;
    lastUpdatedAt = entity.lastUpdatedAt;
    isSynced = true;
  }
}
