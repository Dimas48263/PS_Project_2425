
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities/entities.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities/entities_isar.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_zcaps/incident_zcaps.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incidents/incidents.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incidents/incidents_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcaps/zcap.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcaps/zcap_isar.dart';

part 'incident_zcaps_isar.g.dart';

@collection
class IncidentZcapsIsar implements IsarTable<IncidentZcaps>{
  @override
  Id id = Isar.autoIncrement;

  @Index()
  @override
  int? remoteId;

  IsarLink<IncidentsIsar> incident = IsarLink<IncidentsIsar>();
  IsarLink<ZcapIsar> zcap = IsarLink<ZcapIsar>();
  IsarLink<EntitiesIsar> entity = IsarLink<EntitiesIsar>();

  @Index()
  late DateTime startDate;
  @Index()
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  @override
  DateTime lastUpdatedAt = DateTime.now();

  @override
  bool isSynced = false;

  IncidentZcapsIsar();

  static Future<IncidentsIsar> findOrBuildIncident(
      Incidents incidentInput) async {
    final incidentIsar = await DatabaseService.db.incidentsIsars
        .filter()
        .remoteIdEqualTo(incidentInput.remoteId)
        .findFirst();

    if (incidentIsar != null) return incidentIsar;

    final newIncident = await IncidentsIsar.toRemote(incidentInput);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.incidentsIsars.put(newIncident);
      await newIncident.incidentType.save();
    });
    return newIncident;
  }

  static Future<ZcapIsar> findOrBuildZcap(
      Zcap zcapInput) async {
    final zcapIsar = await DatabaseService.db.zcapIsars
        .filter()
        .remoteIdEqualTo(zcapInput.remoteId)
        .findFirst();

    if (zcapIsar != null) return zcapIsar;

    final newZcap = await ZcapIsar.toRemote(zcapInput);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.zcapIsars.put(newZcap);
      await newZcap.buildingType.save();
      await newZcap.tree.save();
      await newZcap.zcapEntity.save();
    });
    return newZcap;
  }

  static Future<EntitiesIsar> findOrBuildEntity(
      Entity entityInput) async {
    final entityIsar = await DatabaseService.db.entitiesIsars
        .filter()
        .remoteIdEqualTo(entityInput.remoteId)
        .findFirst();

    if (entityIsar != null) return entityIsar;

    final newEntity = await EntitiesIsar.toRemote(entityInput);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.entitiesIsars.put(newEntity);
      await newEntity.entityType.save();
    });
    return newEntity;
  }

  static Future<IncidentZcapsIsar> toRemote(IncidentZcaps incidentZcap) async {
    final incidentZcapIsar = IncidentZcapsIsar()
      ..remoteId = incidentZcap.remoteId
      ..incident.value = await findOrBuildIncident(incidentZcap.incident)
      ..zcap.value = await findOrBuildZcap(incidentZcap.zcap)
      ..entity.value = await findOrBuildEntity(incidentZcap.entity)
      ..startDate = incidentZcap.startDate
      ..endDate = incidentZcap.endDate
      ..createdAt = incidentZcap.createdAt
      ..lastUpdatedAt = incidentZcap.lastUpdatedAt
      ..isSynced = true;
    return incidentZcapIsar;
  }

  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    return IncidentZcapsIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..incident.value = incident.value
      ..zcap.value = zcap.value
      ..entity.value = entity.value
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }

  @override
  IncidentZcaps toEntity() {
    return IncidentZcaps(
      remoteId: remoteId ?? 0,
      incident: incident.value!.toEntity(),
      zcap: zcap.value!.toEntity(),
      entity: entity.value!.toEntity(),
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt
    );
  }

  @override
  Future<void> updateFromApiEntity(IncidentZcaps incidentZcap) async {
    remoteId = incidentZcap.remoteId;
    incident.value = await findOrBuildIncident(incidentZcap.incident);
    zcap.value = await findOrBuildZcap(incidentZcap.zcap);
    entity.value = await findOrBuildEntity(incidentZcap.entity);
    startDate = incidentZcap.startDate;
    endDate = incidentZcap.endDate;
    createdAt = incidentZcap.createdAt;
    lastUpdatedAt = incidentZcap.lastUpdatedAt;
    isSynced = true;
  }
}