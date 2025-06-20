import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/people/support/support_needed.dart';

part 'support_needed_isar.g.dart';

@collection
class SupportNeededIsar implements IsarTable<SupportNeeded> {
  /*Local variables*/
  @override
  Id id = Isar.autoIncrement;
  @override
  bool isSynced = false;

  /* Remote variables */
  @Index()
  @override
  int? remoteId;

  @Index(type: IndexType.value)
  String name = "";

  DateTime startDate = DateTime(DateTime.now().year, 1, 1);
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  @override
  DateTime lastUpdatedAt = DateTime.now();

  // Construtor sem nome (necessário para o Isar)
  SupportNeededIsar();

  SupportNeededIsar copyWith({
    int? id,
    int? remoteId,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    bool? isSynced,
  }) {
    final copy = SupportNeededIsar()
      ..id = id ?? this.id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name ?? this.name
      ..startDate = startDate ?? this.startDate
      ..endDate = endDate ?? this.endDate
      ..createdAt = createdAt ?? this.createdAt
      ..lastUpdatedAt = lastUpdatedAt ?? this.lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;

    return copy;
  }

  @override
  Future<void> updateFromApiEntity(SupportNeeded supportNeeded) async {
    remoteId = supportNeeded.remoteId;
    name = supportNeeded.name;
    startDate = supportNeeded.startDate;
    endDate = supportNeeded.endDate;
    createdAt = supportNeeded.createdAt;
    lastUpdatedAt = supportNeeded.lastUpdatedAt;
    isSynced = true;
  }

  // Método para converter a partir do modelo SpecialNeed
  factory SupportNeededIsar.fromEntityType(SupportNeeded supportNeeded) {
    return SupportNeededIsar()
      ..remoteId = supportNeeded.remoteId
      ..name = supportNeeded.name
      ..startDate = supportNeeded.startDate
      ..endDate = supportNeeded.endDate
      ..createdAt = supportNeeded.createdAt
      ..lastUpdatedAt = supportNeeded.lastUpdatedAt
      ..isSynced = supportNeeded.isSynced;
  }

  // Método para converter para o modelo SpecialNeed
  @override
  SupportNeeded toEntity() {
    return SupportNeeded(
      remoteId: remoteId ?? -1,
      name: name,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
      isSynced: isSynced,
    );
  }

  factory SupportNeededIsar.toRemote(SupportNeeded supportNeeded) {
    return SupportNeededIsar()
      ..remoteId = supportNeeded.remoteId
      ..name = supportNeeded.name
      ..startDate = supportNeeded.startDate
      ..endDate = supportNeeded.endDate
      ..createdAt = supportNeeded.createdAt
      ..lastUpdatedAt = supportNeeded.lastUpdatedAt
      ..isSynced = true;
  }

  @override
  SupportNeededIsar setEntityIdAndSync(
      {int? remoteId, bool? isSynced, DateTime? lastUpdatedAt}) {
    return SupportNeededIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt ?? this.lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }
}