import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/users/user_data_profiles/user_data_profiles.dart';

part 'user_data_profiles_isar.g.dart';

@collection
class UserDataProfilesIsar implements IsarTable<UserDataProfile> {
  UserDataProfilesIsar();

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
    final newUserDataProfile = UserDataProfilesIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name
      ..startDate = startDate
      ..endDate = endDate
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;

    return newUserDataProfile;
  }

  @override
  UserDataProfile toEntity() {
    return UserDataProfile(
      remoteId: remoteId ?? 0,
      name: name,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
      isSynced: isSynced,
    );
  }

  factory UserDataProfilesIsar.fromEntityType(UserDataProfile userDataProfile) {
    return UserDataProfilesIsar()
      ..remoteId = userDataProfile.remoteId
      ..name = userDataProfile.name
      ..startDate = userDataProfile.startDate
      ..endDate = userDataProfile.endDate
      ..createdAt = userDataProfile.createdAt
      ..lastUpdatedAt = userDataProfile.lastUpdatedAt
      ..isSynced = userDataProfile.isSynced;
  }

  factory UserDataProfilesIsar.toRemote(UserDataProfile userDataProfile) {
    final remote = UserDataProfilesIsar()
      ..remoteId = userDataProfile.remoteId
      ..name = userDataProfile.name
      ..startDate = userDataProfile.startDate
      ..endDate = userDataProfile.endDate
      ..createdAt = userDataProfile.createdAt
      ..lastUpdatedAt = userDataProfile.lastUpdatedAt
      ..isSynced = true;

    return remote;
  }

  @override
  Future<void> updateFromApiEntity(UserDataProfile entity) async {
    remoteId = entity.remoteId;
    name = entity.name;
    startDate = entity.startDate;
    endDate = entity.endDate;
    createdAt = entity.createdAt;
    lastUpdatedAt = entity.lastUpdatedAt;
    isSynced = true;
  }
}
