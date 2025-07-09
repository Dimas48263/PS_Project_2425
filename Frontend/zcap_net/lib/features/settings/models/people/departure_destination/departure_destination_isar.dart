import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/people/departure_destination/departure_destination.dart';

part 'departure_destination_isar.g.dart';

@collection
class DepartureDestinationIsar implements IsarTable<DepartureDestination> {
  @override
  Id id = Isar.autoIncrement;

  @Index()
  @override
  int? remoteId;
  late String name;
  @Index()
  late DateTime startDate;
  @Index()
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  @override
  DateTime lastUpdatedAt = DateTime.now();
  @override
  bool isSynced = false;

  DepartureDestinationIsar();

  static Future<DepartureDestinationIsar> toRemote(
      DepartureDestination departureDestination) async {
    final departureDestinationIsar = DepartureDestinationIsar()
      ..remoteId = departureDestination.remoteId
      ..name = departureDestination.name
      ..startDate = departureDestination.startDate
      ..endDate = departureDestination.endDate
      ..createdAt = departureDestination.createdAt
      ..lastUpdatedAt = departureDestination.lastUpdatedAt
      ..isSynced = true;
    return departureDestinationIsar;
  }

  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    return DepartureDestinationIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }

  @override
  DepartureDestination toEntity() {
    return DepartureDestination(
      remoteId: remoteId ?? 0,
      name: name,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
    );
  }

  @override
  Future<void> updateFromApiEntity(
      DepartureDestination departureDestination) async {
    remoteId = departureDestination.remoteId;
    name = departureDestination.name;
    startDate = departureDestination.startDate;
    endDate = departureDestination.endDate;
    createdAt = departureDestination.createdAt;
    lastUpdatedAt = departureDestination.lastUpdatedAt;
    isSynced = true;
  }
}
