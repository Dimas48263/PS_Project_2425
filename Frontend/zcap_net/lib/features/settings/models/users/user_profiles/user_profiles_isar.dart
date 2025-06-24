import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_access_keys_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profile_access_allowance.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profile_access_allowance_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles.dart';

part 'user_profiles_isar.g.dart';

@collection
class UserProfilesIsar implements IsarTable<UserProfile> {
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
  final accessAllowances = IsarLinks<UserProfileAccessAllowanceIsar>();

  DateTime startDate = DateTime(DateTime.now().year, 1, 1);
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  @override
  DateTime lastUpdatedAt = DateTime.now();

  // Construtor sem nome (necessário para o Isar)
  UserProfilesIsar();

  UserProfilesIsar copyWith({
    int? id,
    int? remoteId,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    bool? isSynced,
  }) {
    final copy = UserProfilesIsar()
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

  UserProfilesIsar copyWithFromEntity(UserProfile entity) {
    return copyWith(
      remoteId: entity.remoteId,
      name: entity.name,
      startDate: entity.startDate,
      endDate: entity.endDate,
      createdAt: entity.createdAt,
      lastUpdatedAt: entity.lastUpdatedAt,
      isSynced: true,
    );
  }

  @override
  Future<void> updateFromApiEntity(UserProfile entity) async {
    remoteId = entity.remoteId;
    name = entity.name;
    startDate = entity.startDate;
    endDate = entity.endDate;
    createdAt = entity.createdAt;
    lastUpdatedAt = entity.lastUpdatedAt;
    isSynced = true;
  }

  // Método para converter a partir do modelo EntityType
  factory UserProfilesIsar.fromEntity(UserProfile entity) {
    return UserProfilesIsar()
      ..remoteId = entity.remoteId
      ..name = entity.name
      ..startDate = entity.startDate
      ..endDate = entity.endDate
      ..createdAt = entity.createdAt
      ..lastUpdatedAt = entity.lastUpdatedAt
      ..isSynced = entity.isSynced;
  }

  // Método para converter para o modelo EntityType
  @override
  UserProfile toEntity({
    List<UserProfileAccessAllowanceIsar> allowances = const [],
  }) {
    return UserProfile(
      remoteId: remoteId ?? -1,
      name: name,
      accessAllowances: allowances.map((e) => e.toEntity()).toList(),
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
      isSynced: isSynced,
    );
  }

  factory UserProfilesIsar.toRemote(UserProfile entityType) {
    return UserProfilesIsar()
      ..remoteId = entityType.remoteId
      ..name = entityType.name
      ..startDate = entityType.startDate
      ..endDate = entityType.endDate
      ..createdAt = entityType.createdAt
      ..lastUpdatedAt = entityType.lastUpdatedAt
      ..isSynced = true;
  }

  @override
  UserProfilesIsar setEntityIdAndSync(
      {int? remoteId, bool? isSynced, DateTime? lastUpdatedAt}) {
    LogService.log(
        'setEntityIdAndSync chamado com remoteId=$remoteId, isSynced=$isSynced');
    return UserProfilesIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt ?? this.lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }

  static Future<void> saveAccessAllowances({
    required UserProfilesIsar profile,
    required List<UserProfileAccessAllowance> allowances,
  }) async {
    for (final entity in allowances) {
      final isarAllowance = UserProfileAccessAllowanceIsar.fromEntity(entity);

      isarAllowance.userProfile.value = profile;

      await DatabaseService.db.userProfileAccessAllowanceIsars
          .put(isarAllowance);

      await isarAllowance.userProfile.save();

      profile.accessAllowances.add(isarAllowance);
    }

    await profile.accessAllowances.save();

    await ensureAllAllowancesExist(profile);
  }

//If a new profile access key is created, should create with read-write access
  static Future<void> ensureAllAllowancesExist(UserProfilesIsar profile) async {
    final allKeys =
        await DatabaseService.db.userAccessKeysIsars.where().findAll();

//    await profile.accessAllowances.load();
//    final existingRemoteIds = profile.accessAllowances
//        .map((accessAllowances) => accessAllowances.remoteId)
//        .toSet();

    final existingRemoteIds = await DatabaseService
        .db.userProfileAccessAllowanceIsars
        .filter()
        .userProfile((q) => q.idEqualTo(profile.id))
        .findAll()
        .then((list) => list.map((e) => e.remoteId).toSet());

    final missingKeys = allKeys
        .where((allowance) => !existingRemoteIds.contains(allowance.remoteId));

    if (missingKeys.isEmpty) return;

    await DatabaseService.db.writeTxn(() async {
      for (final missing in missingKeys) {
        final newAllowance = UserProfileAccessAllowanceIsar()
          ..key = missing.accessKey
          ..remoteId = missing.remoteId
          ..accessTypeIndex = 0 // default Read-Write
          ..description = missing.description
          ..userProfile.value = profile;

        await DatabaseService.db.userProfileAccessAllowanceIsars
            .put(newAllowance);
      }

      profile.isSynced = false;
      profile.lastUpdatedAt = DateTime.now();
      await DatabaseService.db.userProfilesIsars.put(profile);
    });
  }
}
