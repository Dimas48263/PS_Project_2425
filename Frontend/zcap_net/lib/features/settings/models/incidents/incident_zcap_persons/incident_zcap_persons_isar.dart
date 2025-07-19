import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_zcap_persons/incident_zcap_persons.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_zcaps/incident_zcaps.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_zcaps/incident_zcaps_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/persons/persons.dart';
import 'package:zcap_net_app/features/settings/models/people/persons/persons_isar.dart';

part 'incident_zcap_persons_isar.g.dart';

@collection
class IncidentZcapPersonsIsar implements IsarTable<IncidentZcapPersons> {
  @override
  Id id = Isar.autoIncrement;

  @Index()
  @override
  int? remoteId;

  IsarLink<IncidentZcapsIsar> incidentZcap = IsarLink<IncidentZcapsIsar>();
  IsarLink<PersonsIsar> person = IsarLink<PersonsIsar>();

  @Index()
  late DateTime startDate;
  @Index()
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  @override
  DateTime lastUpdatedAt = DateTime.now();

  @override
  bool isSynced = false;

  IncidentZcapPersonsIsar();

  static Future<IncidentZcapsIsar> findOrBuildIncidentZcap(
      IncidentZcaps incidentZcapInput) async {
    final incidentZcapIsar = await DatabaseService.db.incidentZcapsIsars
        .filter()
        .remoteIdEqualTo(incidentZcapInput.remoteId)
        .findFirst();

    if (incidentZcapIsar != null) return incidentZcapIsar;

    final newIncidentZcap = await IncidentZcapsIsar.toRemote(incidentZcapInput);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.incidentZcapsIsars.put(newIncidentZcap);
      await newIncidentZcap.incident.save();
      await newIncidentZcap.zcap.save();
    });
    return newIncidentZcap;
  }

  static Future<PersonsIsar> findOrBuildPerson(Persons personInput) async {
    final personIsar = await DatabaseService.db.personsIsars
        .filter()
        .remoteIdEqualTo(personInput.remoteId)
        .findFirst();

    if (personIsar != null) return personIsar;

    final newPerson = await PersonsIsar.toRemote(personInput);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.personsIsars.put(newPerson);
      await newPerson.placeOfResidence.save();
      if (personInput.nationality != null) {
        await newPerson.nationality.save();
      } else {
        await newPerson.nationality.reset();
      }
      if (personInput.departureDestination != null) {
        await newPerson.departureDestination.save();
      } else {
        await newPerson.departureDestination.reset();
      }
    });
    return newPerson;
  }

  static Future<IncidentZcapPersonsIsar> toRemote(
      IncidentZcapPersons zcapPerson) async {
    final remoteIncidentZcapPerson = IncidentZcapPersonsIsar();
    remoteIncidentZcapPerson.remoteId = zcapPerson.remoteId;
    remoteIncidentZcapPerson.incidentZcap.value =
        await findOrBuildIncidentZcap(zcapPerson.incidentZcap);
    remoteIncidentZcapPerson.person.value =
        await findOrBuildPerson(zcapPerson.person);
    remoteIncidentZcapPerson.startDate = zcapPerson.startDate;
    remoteIncidentZcapPerson.endDate = zcapPerson.endDate;
    remoteIncidentZcapPerson.createdAt = zcapPerson.createdAt;
    remoteIncidentZcapPerson.lastUpdatedAt = zcapPerson.lastUpdatedAt;
    remoteIncidentZcapPerson.isSynced = true;
    return remoteIncidentZcapPerson;
  }

  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    return IncidentZcapPersonsIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..incidentZcap.value = incidentZcap.value
      ..person.value = person.value
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }

  @override
  IncidentZcapPersons toEntity() {
    return IncidentZcapPersons(
      remoteId: remoteId ?? 0,
      incidentZcap: incidentZcap.value!.toEntity(),
      person: person.value!.toEntity(),
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
    );
  }

  @override
  Future<void> updateFromApiEntity(IncidentZcapPersons entity) async {
    remoteId = entity.remoteId;
    incidentZcap.value = await findOrBuildIncidentZcap(entity.incidentZcap);
    person.value = await findOrBuildPerson(entity.person);
    startDate = entity.startDate;
    endDate = entity.endDate;
    createdAt = entity.createdAt;
    lastUpdatedAt = entity.lastUpdatedAt;
    isSynced = true;
  }
}
