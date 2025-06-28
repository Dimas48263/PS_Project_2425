import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/acess_type.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_access_keys/user_access_keys_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profile_access_allowance_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles.dart';

part 'user_profiles_isar.g.dart';

@collection
class UserProfilesIsar implements IsarTable<UserProfile> {
  UserProfilesIsar();

  /*Local variables*/
  @override
  Id id = Isar.autoIncrement;
  @override
  bool isSynced = false;

  /* Remote variables */
  @Index()
  @override
  int? remoteId;

  late String name;

  late DateTime startDate;
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  @override
  DateTime lastUpdatedAt = DateTime.now();

  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    final newUserProfile = UserProfilesIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;

    return newUserProfile;
  }

  @override
  UserProfile toEntity({
    List<UserProfileAccessAllowanceIsar> allowances = const [],
  }) {
    return UserProfile(
      remoteId: remoteId ?? 0,
      name: name,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
      isSynced: isSynced,
    );
  }

  factory UserProfilesIsar.fromEntityType(UserProfile userProfile) {
    return UserProfilesIsar()
      ..remoteId = userProfile.remoteId
      ..name = userProfile.name
      ..startDate = userProfile.startDate
      ..endDate = userProfile.endDate
      ..createdAt = userProfile.createdAt
      ..lastUpdatedAt = userProfile.lastUpdatedAt
      ..isSynced = userProfile.isSynced;
  }

  factory UserProfilesIsar.toRemote(UserProfile userProfile) {
    final remote = UserProfilesIsar()
      ..remoteId = userProfile.remoteId
      ..name = userProfile.name
      ..startDate = userProfile.startDate
      ..endDate = userProfile.endDate
      ..createdAt = userProfile.createdAt
      ..lastUpdatedAt = userProfile.lastUpdatedAt
      ..isSynced = true;

    return remote;
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

/*
  static Future<void> saveAccessAllowances({
    required UserProfilesIsar profile,
    required List<UserProfileAccessAllowance> allowances,
  }) async {
    await DatabaseService.db.writeTxn(() async {
      for (final entity in allowances) {
        final isarAllowance = UserProfileAccessAllowanceIsar.fromEntity(entity);

        isarAllowance.userProfile.value = profile;

        await DatabaseService.db.userProfileAccessAllowanceIsars
            .put(isarAllowance);
        await isarAllowance.userProfile.save();

      }

      await ensureAllAllowancesExist(profile);
    });
  }*/

  static Future<void> ensureAllAllowancesExist(UserProfilesIsar profile) async {
    final allKeys =
        await DatabaseService.db.userAccessKeysIsars.where().findAll();

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
          ..accessTypeIndex = AccessType.readWrite // default Read-Write
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
