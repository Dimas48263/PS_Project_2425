import 'package:isar/isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_data_profiles/user_data_profile_allowance.dart';

part 'user_data_profile_allowance_isar.g.dart';

@collection
class UserDataProfileAllowanceIsar {
  Id id = Isar.autoIncrement;

  @Index()
  late int userDataProfileId;

  @Index()
  late int treeRecordId;

  UserDataProfileAllowanceIsar();

  factory UserDataProfileAllowanceIsar.fromEntity(UserDataProfileAllowance entity) {
    return UserDataProfileAllowanceIsar()
      ..userDataProfileId = entity.userDataProfileId
      ..treeRecordId = entity.treeRecordId;
  }

  UserDataProfileAllowance toEntity() {
    return UserDataProfileAllowance(
      userDataProfileId: userDataProfileId,
      treeRecordId: treeRecordId,
    );
  }

  UserDataProfileAllowanceIsar copyWith({
    int? userDataProfileId,
    int? treeRecordId,
  }) {
    return UserDataProfileAllowanceIsar()
      ..id = id
      ..userDataProfileId = userDataProfileId ?? this.userDataProfileId
      ..treeRecordId = treeRecordId ?? this.treeRecordId;
  }
}