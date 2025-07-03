import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/users/users.dart';

part 'users_isar.g.dart';

@Collection()
class UsersIsar implements IsarTable<Users> {
  @override
  Id id = Isar.autoIncrement;
  @override
  bool isSynced = false;

  @override
  @Index(unique: true)
  int? remoteId;

  @Index(unique: true)
  String userName = "";
  String name = "";
  String password = "";

  final userProfile = IsarLink<UserProfilesIsar>();
  //TODO: final userDataProfile = IsarLink<UserDataProfilesIsar>();

  DateTime startDate = DateTime(DateTime.now().year, 1, 1);
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  @override
  DateTime lastUpdatedAt = DateTime.now();

  UsersIsar();

  @override
  IsarTable<ApiTable> setEntityIdAndSync({int? remoteId, bool? isSynced}) {
    final newUser = UsersIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..userName = userName
      ..name = name
      ..password = password
      ..userProfile.value = userProfile.value
//      ..userDataProfile.value = userDataProfile.value
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;

    return newUser;
  }

  @override
  Users toEntity() {
    return Users(
      remoteId: remoteId ?? 0,
      userName: userName,
      name: name,
      password: password,
      userProfile: userProfile.value!.toEntity(),
//      userDataProfile: userDataProfile.value!.toEntity(),
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
      isSynced: isSynced,
    );
  }

  @override
  Future<void> updateFromApiEntity(Users user) async {
    remoteId = user.remoteId;
    userName = user.userName;
    name = user.name;
    password = user.password;
    startDate = user.startDate;
    endDate = user.endDate;
    createdAt = user.createdAt;
    lastUpdatedAt = user.lastUpdatedAt;
    isSynced = true;

    final uProfile = await findOrBuildUserProfile(user.userProfile);
    await DatabaseService.db.writeTxn(() async {
      userProfile.value = uProfile;
      await userProfile.save();
    });
  }

  static Future<UserProfilesIsar> findOrBuildUserProfile(
      UserProfile profile) async {
    UserProfilesIsar? p;

    p = await DatabaseService.db.userProfilesIsars
        .filter()
        .remoteIdEqualTo(profile.remoteId)
        .findFirst();

    if (p != null) return p;

    final newProfile = UserProfilesIsar.fromEntityType(profile);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.userProfilesIsars.put(newProfile);
    });
    return newProfile;
  }

/*  static Future<UserDataProfilesIsar> findOrBuildUserDataProfile(UserDataProfile profile) async {
    var p = await DatabaseService.db.userDataProfilesIsars
        .filter()
        .remoteIdEqualTo(profile.remoteId)
        .findFirst();

    if (p != null) return p;

    final newProfile = UserDataProfilesIsar.fromUserDataProfile(profile);
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.userDataProfilesIsars.put(newProfile);
    });
    return newProfile;
  }*/

  static Future<UsersIsar> fromEntity(Users u) async {
    final user = UsersIsar()
      ..remoteId = u.remoteId
      ..userName = u.userName
      ..name = u.name
      ..password = u.password
      ..startDate = u.startDate
      ..endDate = u.endDate
      ..createdAt = u.createdAt
      ..lastUpdatedAt = u.lastUpdatedAt
      ..isSynced = true;

    user.userProfile.value = await findOrBuildUserProfile(u.userProfile);
//    user.userDataProfile.value = await findOrBuildUserDataProfile(u.userDataProfile);

    return user;
  }

  static Future<UsersIsar> toRemote(Users user) async {
    final remote = UsersIsar()
      ..remoteId = user.remoteId
      ..name = user.name
      ..userName = user.userName
      ..password = user.password
      ..startDate = user.startDate
      ..endDate = user.endDate
      ..createdAt = user.createdAt
      ..lastUpdatedAt = user.lastUpdatedAt
      ..isSynced = true;

    remote.userProfile.value = await getOrBuildUserProfile(user.userProfile);

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
}
