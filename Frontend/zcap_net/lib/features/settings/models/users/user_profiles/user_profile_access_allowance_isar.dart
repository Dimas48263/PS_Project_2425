import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/acess_type.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profile_access_allowance.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';

part 'user_profile_access_allowance_isar.g.dart';

@collection
class UserProfileAccessAllowanceIsar
    implements IsarTable<UserProfileAccessAllowance> {
  @override
  Id id = Isar.autoIncrement;
  @override
  bool isSynced = true; //default true, is synced by userProfile

  @override
  @Index()
  int? remoteId;

  IsarLink<UserProfilesIsar> userProfile = IsarLink<UserProfilesIsar>();
  late String key;
  late String description;

  @enumerated
  late AccessType accessTypeIndex;

  late DateTime createdAt = DateTime.now();
  @override
  late DateTime lastUpdatedAt = DateTime.now();

  UserProfileAccessAllowanceIsar();

  @override
  Future<void> updateFromApiEntity(UserProfileAccessAllowance a) async {
    remoteId = a.remoteId;
    key = a.key;
    description = a.description;
    accessTypeIndex = a.accessType;
    createdAt = a.createdAt;
    lastUpdatedAt = a.lastUpdatedAt;
    isSynced = true;

    final userProf = await findOrBuildUserProfile(a.userProfile);
    DatabaseService.db.writeTxn(() async {
      userProfile.value = userProf;
      await userProfile.save();
    });
  }

  static Future<UserProfilesIsar> findOrBuildUserProfile(
      UserProfile userProfile) async {
    UserProfilesIsar? p;

    p = await DatabaseService.db.userProfilesIsars
        .filter()
        .remoteIdEqualTo(userProfile.remoteId)
        .findFirst();

    if (p != null) return p;

    final newP = UserProfilesIsar.fromEntityType(userProfile);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.userProfilesIsars.put(newP);
    });
    return newP;
  }

  static Future<UserProfileAccessAllowanceIsar> fromEntity(
      UserProfileAccessAllowance a) async {
    final isarUserAllowances = UserProfileAccessAllowanceIsar()
      ..remoteId = a.remoteId
      ..key = a.key
      ..description = a.description
      ..accessTypeIndex = a.accessType
      ..createdAt = a.createdAt
      ..lastUpdatedAt = a.lastUpdatedAt
      ..isSynced = true;

    final newP = await findOrBuildUserProfile(a.userProfile);
    isarUserAllowances.userProfile.value = newP;

    return isarUserAllowances;
  }

  @override
  UserProfileAccessAllowance toEntity() {
    return UserProfileAccessAllowance(
      userProfile: userProfile.value?.toEntity() ??
          UserProfile(
            remoteId: 0,
            name: '',
            startDate: DateTime.now(),
            createdAt: DateTime.now(),
            lastUpdatedAt: DateTime.now(),
          ),
      key: key,
      description: description,
      accessType: accessTypeIndex,
      remoteId: remoteId ?? -1,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
      isSynced: isSynced,
    );
  }

  @override
  UserProfileAccessAllowanceIsar setEntityIdAndSync(
      {int? remoteId, bool? isSynced, DateTime? lastUpdatedAt}) {
    return UserProfileAccessAllowanceIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..userProfile.value = userProfile.value
      ..key = key
      ..description = description
      ..accessTypeIndex = accessTypeIndex
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt ?? this.lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }

  static Future<UserProfileAccessAllowanceIsar> toRemote(
      UserProfileAccessAllowance allowances) async {
    final remote = UserProfileAccessAllowanceIsar()
      ..remoteId = allowances.remoteId
      ..key = allowances.key
      ..description = allowances.description
      ..accessTypeIndex = allowances.accessType
      ..createdAt = allowances.createdAt
      ..lastUpdatedAt = allowances.lastUpdatedAt
      ..isSynced = true;

    remote.userProfile.value =
        await getOrBuildUserProfile(allowances.userProfile);

    return remote;
  }

  static Future<UserProfilesIsar> getOrBuildUserProfile(
      UserProfile userProfile) async {
    UserProfilesIsar? userProfilesIsar = await DatabaseService
        .db.userProfilesIsars
        .where()
        .remoteIdEqualTo(userProfile.remoteId)
        .findFirst();
    if (userProfilesIsar != null) return userProfilesIsar;

    UserProfilesIsar newUserProfile = UserProfilesIsar.toRemote(userProfile);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.userProfilesIsars.put(newUserProfile);
    });
    return newUserProfile;
  }

  UserProfileAccessAllowanceIsar copyWith() {
    return UserProfileAccessAllowanceIsar()
      ..id = id
      ..remoteId = remoteId
      ..key = key
      ..description = description
      ..accessTypeIndex = accessTypeIndex
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced
      ..userProfile.value = userProfile.value;
  }
}
