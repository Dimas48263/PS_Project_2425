import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/people/person_special_needs/person_special_needs.dart';
import 'package:zcap_net_app/features/settings/models/people/persons/persons.dart';
import 'package:zcap_net_app/features/settings/models/people/persons/persons_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/special_needs/special_needs.dart';
import 'package:zcap_net_app/features/settings/models/people/special_needs/special_needs_isar.dart';

part 'person_special_needs_isar.g.dart';

@collection
class PersonSpecialNeedsIsar extends IsarTable<PersonSpecialNeeds> {
  @override
  Id id = Isar.autoIncrement;

  @Index()
  @override
  int? remoteId;

  IsarLink<PersonsIsar> person = IsarLink<PersonsIsar>();
  IsarLink<SpecialNeedIsar> specialNeed = IsarLink<SpecialNeedIsar>();

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

  PersonSpecialNeedsIsar();

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

  static Future<SpecialNeedIsar> findOrBuildSpecialNeed(
      SpecialNeed specialNeedInput) async {
    final specialNeedIsar = await DatabaseService.db.specialNeedIsars
        .filter()
        .remoteIdEqualTo(specialNeedInput.remoteId)
        .findFirst();

    if (specialNeedIsar != null) return specialNeedIsar;

    final newSpecialNeed = SpecialNeedIsar.toRemote(specialNeedInput);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.specialNeedIsars.put(newSpecialNeed);
    });
    return newSpecialNeed;
  }

  static Future<PersonSpecialNeedsIsar> toRemote(
      PersonSpecialNeeds personSpecialNeeds) async {
    final personSpecialNeedsIsar = PersonSpecialNeedsIsar();
    personSpecialNeedsIsar.remoteId = personSpecialNeeds.remoteId;
    personSpecialNeedsIsar.person.value =
        await PersonSpecialNeedsIsar.findOrBuildPerson(
            personSpecialNeeds.person);
    personSpecialNeedsIsar.specialNeed.value =
        await PersonSpecialNeedsIsar.findOrBuildSpecialNeed(
            personSpecialNeeds.specialNeed);
    personSpecialNeedsIsar.description = personSpecialNeeds.description;
    personSpecialNeedsIsar.startDate = personSpecialNeeds.startDate;
    personSpecialNeedsIsar.endDate = personSpecialNeeds.endDate;
    return personSpecialNeedsIsar;
  }

  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    return PersonSpecialNeedsIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..person.value = person.value
      ..specialNeed.value = specialNeed.value
      ..description = description
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }

  @override
  PersonSpecialNeeds toEntity() {
    return PersonSpecialNeeds(
      remoteId: remoteId ?? 0,
      person: person.value!.toEntity(),
      specialNeed: specialNeed.value!.toEntity(),
      description: description,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt
    );
  }

  @override
  Future<void> updateFromApiEntity(PersonSpecialNeeds personSpecialNeed) async {
    remoteId = personSpecialNeed.remoteId;
    person.value = await PersonSpecialNeedsIsar.findOrBuildPerson(personSpecialNeed.person);
    specialNeed.value = await PersonSpecialNeedsIsar.findOrBuildSpecialNeed(personSpecialNeed.specialNeed);
    description = personSpecialNeed.description;
    startDate = personSpecialNeed.startDate;
    endDate = personSpecialNeed.endDate;
    createdAt = personSpecialNeed.createdAt;
    lastUpdatedAt = personSpecialNeed.lastUpdatedAt;
    isSynced = true;
  }
}
