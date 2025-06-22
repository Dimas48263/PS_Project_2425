import 'package:isar/isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profile_access_allowance.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';

part 'user_profile_access_allowance_isar.g.dart';

@collection
class UserProfileAccessAllowanceIsar {
  Id id = Isar.autoIncrement;

  int userProfileAccessKeyId = -1;
  int accessType = 0; //Read-Write by default.

  final userProfile = IsarLink<UserProfilesIsar>();

  UserProfileAccessAllowanceIsar();

  factory UserProfileAccessAllowanceIsar.fromEntity(
      UserProfileAccessAllowance entity) {
    return UserProfileAccessAllowanceIsar()
      ..userProfileAccessKeyId = entity.userProfileAccessKeyId
      ..accessType = entity.accessType;
  }

  UserProfileAccessAllowance toEntity() {
    return UserProfileAccessAllowance(
      userProfileAccessKeyId: userProfileAccessKeyId,
      accessType: accessType,
    );
  }
}
