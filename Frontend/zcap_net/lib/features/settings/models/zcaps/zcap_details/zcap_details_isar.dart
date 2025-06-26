import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_detail_types/zcap_detail_type.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_detail_types/zcap_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_details/zcap_details.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcaps/zcap.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcaps/zcap_isar.dart';

part 'zcap_details_isar.g.dart';

@collection
class ZcapDetailsIsar implements IsarTable<ZcapDetails> {
  @override
  Id id = Isar.autoIncrement;

  @override
  bool isSynced = false;

  @Index()
  @override
  int? remoteId;

  late String valueCol;

  IsarLink<ZcapIsar> zcap = IsarLink<ZcapIsar>();
  IsarLink<ZcapDetailTypeIsar> zcapDetailType = IsarLink<ZcapDetailTypeIsar>();

  late DateTime startDate;
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  @override
  DateTime lastUpdatedAt = DateTime.now();

  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    return ZcapDetailsIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..zcap.value = zcap.value
      ..zcapDetailType.value = zcapDetailType.value
      ..valueCol = valueCol
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }

  @override
  ZcapDetails toEntity() {
    return ZcapDetails(
      remoteId: remoteId ?? 0,
      zcap: zcap.value!.toEntity(),
      zcapDetailType: zcapDetailType.value!.toEntity(),
      valueCol: valueCol,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt
    );
  }

  static Future<ZcapDetailsIsar> toRemote(ZcapDetails zcapDetails) async {
    final remote = ZcapDetailsIsar()
      ..remoteId = zcapDetails.remoteId
      ..valueCol = zcapDetails.valueCol
      ..startDate = zcapDetails.startDate
      ..endDate = zcapDetails.endDate
      ..createdAt = zcapDetails.createdAt
      ..lastUpdatedAt = zcapDetails.lastUpdatedAt
      ..isSynced = true;

    remote.zcap.value = await getOrBuildZcap(zcapDetails.zcap);
    remote.zcapDetailType.value = await getOrBuildZcapDetailType(zcapDetails.zcapDetailType);

    return remote;
  }

  @override
  Future<void> updateFromApiEntity(ZcapDetails zcapDetails) async {
    remoteId = zcapDetails.remoteId;
    valueCol = zcapDetails.valueCol;
    startDate = zcapDetails.startDate;
    endDate = zcapDetails.endDate;
    createdAt = zcapDetails.createdAt;
    lastUpdatedAt = zcapDetails.lastUpdatedAt;
    isSynced = true;

    zcap.value = await getOrBuildZcap(zcapDetails.zcap);
    zcapDetailType.value = await getOrBuildZcapDetailType(zcapDetails.zcapDetailType);
  }

  static Future<ZcapIsar> getOrBuildZcap(
      Zcap zcap) async {
    ZcapIsar? zcapIsar = await DatabaseService
        .db.zcapIsars
        .where()
        .remoteIdEqualTo(zcap.remoteId)
        .findFirst();
    if (zcapIsar != null) return zcapIsar;

    ZcapIsar newZcapIsar =
        await ZcapIsar.toRemote(zcap);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.zcapIsars.put(newZcapIsar);
    });
    return newZcapIsar;
  }

  static Future<ZcapDetailTypeIsar> getOrBuildZcapDetailType(ZcapDetailType zcapDetailType) async {
    ZcapDetailTypeIsar? zcapDetailTypeIsar = await DatabaseService.db.zcapDetailTypeIsars
        .where()
        .remoteIdEqualTo(zcapDetailType.remoteId)
        .findFirst();
    if (zcapDetailTypeIsar != null) return zcapDetailTypeIsar;

    ZcapDetailTypeIsar newZcapDetailTypeIsar = await ZcapDetailTypeIsar.toRemote(zcapDetailType);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.zcapDetailTypeIsars.put(newZcapDetailTypeIsar);
    });
    return newZcapDetailTypeIsar;
  }
}
