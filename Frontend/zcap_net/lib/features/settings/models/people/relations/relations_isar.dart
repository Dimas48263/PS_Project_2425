import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/people/persons/persons.dart';
import 'package:zcap_net_app/features/settings/models/people/persons/persons_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/relation_type/relation_type.dart';
import 'package:zcap_net_app/features/settings/models/people/relation_type/relation_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/relations/relations.dart';

part 'relations_isar.g.dart';

@collection
class RelationsIsar extends IsarTable<Relations> {
  @override
  Id id = Isar.autoIncrement;
  @Index()
  @override
  int? remoteId;
  IsarLink<PersonsIsar> person1 = IsarLink<PersonsIsar>();
  IsarLink<PersonsIsar> person2 = IsarLink<PersonsIsar>();
  IsarLink<RelationTypeIsar> relationType = IsarLink<RelationTypeIsar>();
  DateTime createdAt = DateTime.now();
  @override
  DateTime lastUpdatedAt = DateTime.now();
  @override
  bool isSynced = false;

  RelationsIsar();

  static Future<PersonsIsar> findOrBuildPerson(Persons person) async {
    final personIsar = await isarDb.personsIsars
        .filter()
        .remoteIdEqualTo(person.remoteId)
        .findFirst();

    if (personIsar != null) return personIsar;

    final newPerson = await PersonsIsar.toRemote(person);
    await isarDb.writeTxn(() async {
      await isarDb.personsIsars.put(newPerson);
      await newPerson.placeOfResidence.save();
      if (person.nationality != null) {
        await newPerson.nationality.save();
      } else {
        await newPerson.nationality.reset();
      }
      if (person.departureDestination != null) {
        await newPerson.departureDestination.save();
      } else {
        await newPerson.departureDestination.reset();
      }
    });
    return newPerson;
  }

  static Future<RelationTypeIsar> findOrBuildRelationType(
      RelationType relationTypeInput) async {
    final relationTypeIsar = await isarDb.relationTypeIsars
        .filter()
        .remoteIdEqualTo(relationTypeInput.remoteId)
        .findFirst();

    if (relationTypeIsar != null) return relationTypeIsar;

    final newRelationType = RelationTypeIsar.toRemote(relationTypeInput);
    await isarDb.writeTxn(() async {
      await isarDb.relationTypeIsars.put(newRelationType);
    });
    return newRelationType;
  }

  static Future<RelationsIsar> toRemote(Relations relations) async => RelationsIsar()
    ..remoteId = relations.remoteId
    ..person1.value = await findOrBuildPerson(relations.person1)
    ..person2.value = await findOrBuildPerson(relations.person2)
    ..relationType.value = await findOrBuildRelationType(relations.relationType)
    ..createdAt = relations.createdAt
    ..lastUpdatedAt = relations.lastUpdatedAt
    ..isSynced = true;

  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    return RelationsIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..person1.value = person1.value
      ..person2.value = person2.value
      ..relationType.value = relationType.value
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }

  @override
  Relations toEntity() => Relations(
    remoteId: remoteId ?? 0,
    person1: person1.value!.toEntity(),
    person2: person2.value!.toEntity(),
    relationType: relationType.value!.toEntity(),
    createdAt: createdAt,
    lastUpdatedAt: lastUpdatedAt
  );

  @override
  Future<void> updateFromApiEntity(Relations relations) async {
    remoteId = relations.remoteId;
    person1.value = await findOrBuildPerson(relations.person1);
    person2.value = await findOrBuildPerson(relations.person2);
    relationType.value = await findOrBuildRelationType(relations.relationType);
    createdAt = relations.createdAt;
    lastUpdatedAt = relations.lastUpdatedAt;
    isSynced = true;
  }
}
