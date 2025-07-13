import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/people/departure_destination/departure_destination.dart';
import 'package:zcap_net_app/features/settings/models/people/departure_destination/departure_destination_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/persons/persons.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_details/tree_record_detail.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_details/tree_record_detail_isar.dart';

part 'persons_isar.g.dart';

@collection
class PersonsIsar implements IsarTable<Persons> {
  @override
  Id id = Isar.autoIncrement;
  @Index()
  @override
  int? remoteId;
  late String name;
  late int age;
  late String contact;
  IsarLink<TreeRecordDetailIsar> countryCode = IsarLink<TreeRecordDetailIsar>();
  IsarLink<TreeIsar> placeOfResidence = IsarLink<TreeIsar>();
  late DateTime entryDateTime;
  DateTime? departureDateTime;
  DateTime? birthDate;
  IsarLink<TreeRecordDetailIsar> nationality = IsarLink<TreeRecordDetailIsar>();
  String? address;
  String? niss;
  IsarLink<DepartureDestinationIsar> departureDestination =
      IsarLink<DepartureDestinationIsar>();
  String? destinationContact;

  DateTime createdAt = DateTime.now();
  @override
  DateTime lastUpdatedAt = DateTime.now();
  @override
  bool isSynced = false;

  PersonsIsar();

  static Future<TreeRecordDetailIsar> findOrBuildTreeRecordDetail(
      TreeRecordDetail detail) async {
    final detailIsar = await DatabaseService.db.treeRecordDetailIsars
        .filter()
        .remoteIdEqualTo(detail.remoteId)
        .findFirst();

    if (detailIsar != null) return detailIsar;

    final newDetail = await TreeRecordDetailIsar.toRemote(detail);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.treeRecordDetailIsars.put(newDetail);
      await newDetail.detailType.save();
      await newDetail.tree.save();
    });
    return newDetail;
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

  static Future<DepartureDestinationIsar> findOrBuildDepartureDestination(
      DepartureDestination departureDestinationInput) async {
    final departureDestinationIsar = await DatabaseService
        .db.departureDestinationIsars
        .filter()
        .remoteIdEqualTo(departureDestinationInput.remoteId)
        .findFirst();

    if (departureDestinationIsar != null) return departureDestinationIsar;

    final newDepartureDestination =
        await DepartureDestinationIsar.toRemote(departureDestinationInput);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.departureDestinationIsars
          .put(newDepartureDestination);
    });
    return newDepartureDestination;
  }

  static Future<PersonsIsar> toRemote(Persons persons) async => PersonsIsar()
    ..remoteId = persons.remoteId
    ..name = persons.name
    ..age = persons.age
    ..contact = persons.contact
    ..countryCode.value = await findOrBuildTreeRecordDetail(persons.countryCode)
    ..placeOfResidence.value = await findOrBuildTree(persons.placeOfResidence)
    ..entryDateTime = persons.entryDateTime
    ..departureDateTime = persons.departureDateTime
    ..birthDate = persons.birthDate
    ..nationality.value = persons.nationality == null
        ? null
        : await findOrBuildTreeRecordDetail(persons.nationality!)
    ..address = persons.address
    ..niss = persons.niss
    ..departureDestination.value = persons.departureDestination == null
        ? null
        : await findOrBuildDepartureDestination(persons.departureDestination!)
    ..destinationContact = persons.destinationContact
    ..createdAt = persons.createdAt
    ..lastUpdatedAt = persons.lastUpdatedAt
    ..isSynced = true;

  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    return PersonsIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name
      ..age = age
      ..contact = contact
      ..countryCode.value = countryCode.value
      ..placeOfResidence.value = placeOfResidence.value
      ..entryDateTime = entryDateTime
      ..departureDateTime = departureDateTime
      ..birthDate = birthDate
      ..nationality.value = nationality.value
      ..address = address
      ..niss = niss
      ..departureDestination.value = departureDestination.value
      ..destinationContact = destinationContact
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }

  @override
  Persons toEntity() => Persons(
      remoteId: remoteId ?? 0,
      name: name,
      age: age,
      contact: contact,
      countryCode: countryCode.value!.toEntity(),
      placeOfResidence: placeOfResidence.value!.toEntity(),
      entryDateTime: entryDateTime,
      departureDateTime: departureDateTime,
      birthDate: birthDate,
      nationality: nationality.value?.toEntity(),
      address: address,
      niss: niss,
      departureDestination: departureDestination.value?.toEntity(),
      destinationContact: destinationContact,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt);

  @override
  Future<void> updateFromApiEntity(Persons person) async {
    remoteId = person.remoteId;
    name = person.name;
    age = person.age;
    contact = person.contact;
    countryCode.value = await findOrBuildTreeRecordDetail(person.countryCode);
    placeOfResidence.value = await findOrBuildTree(person.placeOfResidence);
    entryDateTime = person.entryDateTime;
    departureDateTime = person.departureDateTime;
    birthDate = person.birthDate;
    nationality.value = person.nationality != null
        ? await findOrBuildTreeRecordDetail(person.nationality!)
        : null;
    address = person.address;
    niss = person.niss;
    departureDestination.value = person.departureDestination != null
        ? await findOrBuildDepartureDestination(person.departureDestination!)
        : null;
    destinationContact = person.destinationContact;
    createdAt = person.createdAt;
    lastUpdatedAt = person.lastUpdatedAt;
    isSynced = true;
  }
}
