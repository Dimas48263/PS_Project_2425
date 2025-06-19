import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'special_needs.dart';

part 'special_needs_isar.g.dart';

@collection
class SpecialNeedIsar implements IsarTable<SpecialNeed> {
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
  SpecialNeedIsar();

  SpecialNeedIsar copyWith({
    int? id,
    int? remoteId,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    bool? isSynced,
  }) {
    final copy = SpecialNeedIsar()
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
  Future<void> updateFromApiEntity(SpecialNeed specialNeed) async {
    remoteId = specialNeed.remoteId;
    name = specialNeed.name;
    startDate = specialNeed.startDate;
    endDate = specialNeed.endDate;
    createdAt = specialNeed.createdAt;
    lastUpdatedAt = specialNeed.lastUpdatedAt;
    isSynced = true;
  }

  // Método para converter a partir do modelo SpecialNeed
  factory SpecialNeedIsar.fromEntityType(SpecialNeed specialNeed) {
    return SpecialNeedIsar()
      ..remoteId = specialNeed.remoteId
      ..name = specialNeed.name
      ..startDate = specialNeed.startDate
      ..endDate = specialNeed.endDate
      ..createdAt = specialNeed.createdAt
      ..lastUpdatedAt = specialNeed.lastUpdatedAt
      ..isSynced = specialNeed.isSynced;
  }

  // Método para converter para o modelo SpecialNeed
  @override
  SpecialNeed toEntity() {
    return SpecialNeed(
      remoteId: remoteId ?? -1,
      name: name,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
      isSynced: isSynced,
    );
  }

  factory SpecialNeedIsar.toRemote(SpecialNeed specialNeed) {
    return SpecialNeedIsar()
      ..remoteId = specialNeed.remoteId
      ..name = specialNeed.name
      ..startDate = specialNeed.startDate
      ..endDate = specialNeed.endDate
      ..createdAt = specialNeed.createdAt
      ..lastUpdatedAt = specialNeed.lastUpdatedAt
      ..isSynced = true;
  }

  @override
  SpecialNeedIsar setEntityIdAndSync(
      {int? remoteId, bool? isSynced, DateTime? lastUpdatedAt}) {
    return SpecialNeedIsar()
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