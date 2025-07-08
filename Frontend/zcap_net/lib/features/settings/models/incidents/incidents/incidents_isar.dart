import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_types/incident_types.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_types/incident_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incidents/incidents.dart';

part 'incidents_isar.g.dart';

@collection
class IncidentsIsar implements IsarTable<Incidents> {
  @override
  Id id = Isar.autoIncrement;

  @Index()
  @override
  int? remoteId;

  IsarLink<IncidentTypesIsar> incidentType = IsarLink<IncidentTypesIsar>();

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

  static Future<IncidentsIsar> toRemote(Incidents incident) async {
    final incidentIsar = IncidentsIsar();
    incidentIsar.remoteId = incident.remoteId;
    incidentIsar.incidentType.value =
        await findOrBuildIncidentType(incident.incidentType);
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
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt
    );
  }

  @override
  Future<void> updateFromApiEntity(Incidents entity) async {
    remoteId = entity.remoteId;
    incidentType.value = await findOrBuildIncidentType(entity.incidentType);
    startDate = entity.startDate;
    endDate = entity.endDate;
    createdAt = entity.createdAt;
    lastUpdatedAt = entity.lastUpdatedAt;
    isSynced = true;
  }
}
