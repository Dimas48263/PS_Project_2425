
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/people/person_support_needed/person_support_needed.dart';
import 'package:zcap_net_app/features/settings/models/people/persons/persons.dart';
import 'package:zcap_net_app/features/settings/models/people/persons/persons_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/support/support_needed.dart';
import 'package:zcap_net_app/features/settings/models/people/support/support_needed_isar.dart';

part 'person_support_needed_isar.g.dart';

@collection
class PersonSupportNeededIsar extends IsarTable<PersonSupportNeeded> {
  @override
  Id id = Isar.autoIncrement;

  @Index()
  @override
  int? remoteId;

  IsarLink<PersonsIsar> person = IsarLink<PersonsIsar>();
  IsarLink<SupportNeededIsar> supportNeeded = IsarLink<SupportNeededIsar>();

  String? description;
  @Index()
  late DateTime startDate;
  @Index()
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  @override
  DateTime lastUpdatedAt = DateTime.now();

  @override
  bool isSynced = false;

  PersonSupportNeededIsar();

  static Future<PersonsIsar> findOrBuildPerson(Persons personInput) async {
    final personIsar = await DatabaseService.db.personsIsars
        .filter()
        .remoteIdEqualTo(personInput.remoteId)
        .findFirst();

    if (personIsar != null) return personIsar;

    final newPerson = await PersonsIsar.toRemote(personInput);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.personsIsars.put(newPerson);
      await newPerson.countryCode.save();
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

  static Future<SupportNeededIsar> findOrBuildSupportNeeded(
      SupportNeeded supportNeededInput) async {
    final supportNeededIsar = await DatabaseService.db.supportNeededIsars
        .filter()
        .remoteIdEqualTo(supportNeededInput.remoteId)
        .findFirst();

    if (supportNeededIsar != null) return supportNeededIsar;

    final newSupportNeeded = SupportNeededIsar.toRemote(supportNeededInput);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.supportNeededIsars.put(newSupportNeeded);
    });
    return newSupportNeeded;
  }

  static Future<PersonSupportNeededIsar> toRemote(
      PersonSupportNeeded personSupportNeeded) async {
    final personSupportNeededIsar = PersonSupportNeededIsar();
    personSupportNeededIsar.remoteId = personSupportNeeded.remoteId;
    personSupportNeededIsar.person.value =
        await PersonSupportNeededIsar.findOrBuildPerson(
            personSupportNeeded.person);
    personSupportNeededIsar.supportNeeded.value =
        await PersonSupportNeededIsar.findOrBuildSupportNeeded(
            personSupportNeeded.supportNeeded);
    personSupportNeededIsar.description = personSupportNeeded.description;
    personSupportNeededIsar.startDate = personSupportNeeded.startDate;
    personSupportNeededIsar.endDate = personSupportNeeded.endDate;
    return personSupportNeededIsar;
  }

  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    return PersonSupportNeededIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..person.value = person.value
      ..supportNeeded.value = supportNeeded.value
      ..description = description
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }

  @override
  PersonSupportNeeded toEntity() {
    return PersonSupportNeeded(
      remoteId: remoteId ?? 0,
      person: person.value!.toEntity(),
      supportNeeded: supportNeeded.value!.toEntity(),
      description: description,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt
    );
  }

  @override
  Future<void> updateFromApiEntity(PersonSupportNeeded personSupportNeeded) async {
    remoteId = personSupportNeeded.remoteId;
    person.value = await PersonSupportNeededIsar.findOrBuildPerson(personSupportNeeded.person);
    supportNeeded.value = await PersonSupportNeededIsar.findOrBuildSupportNeeded(personSupportNeeded.supportNeeded);
    description = personSupportNeeded.description;
    startDate = personSupportNeeded.startDate;
    endDate = personSupportNeeded.endDate;
    createdAt = personSupportNeeded.createdAt;
    lastUpdatedAt = personSupportNeeded.lastUpdatedAt;
    isSynced = true;
  }
}
