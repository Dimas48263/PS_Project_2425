import 'package:isar/isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/acess_type.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profile_access_allowance.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';

part 'user_profile_access_allowance_isar.g.dart';

@collection
class UserProfileAccessAllowanceIsar {
  Id id = Isar.autoIncrement;

  @Index()
  int? remoteId;

  late String key;
  late String description;
  late int accessTypeIndex;

  late DateTime createdAt = DateTime.now();
  late DateTime lastUpdatedAt = DateTime.now();

  final userProfile = IsarLink<UserProfilesIsar>();

  UserProfileAccessAllowanceIsar();

  UserProfileAccessAllowanceIsar copyWith({
    int? id,
    int? remoteId,
    String? key,
    String? description,
    int? accessTypeIndex,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) {
    final copy = UserProfileAccessAllowanceIsar()
      ..id = id ?? this.id
      ..remoteId = remoteId ?? this.remoteId
      ..key = key ?? this.key
      ..description = description ?? this.description
      ..accessTypeIndex = accessTypeIndex ?? this.accessTypeIndex
      ..createdAt = createdAt ?? this.createdAt
      ..lastUpdatedAt = lastUpdatedAt ?? this.lastUpdatedAt;

//    copy.userProfile.value = userProfile.value;

    return copy;
  }

  UserProfileAccessAllowance toEntity() {
    return UserProfileAccessAllowance(
      remoteId: remoteId ?? 0,
      key: key,
      description: description,
      accessType: AccessType.values[accessTypeIndex],
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
    );
  }

  static UserProfileAccessAllowanceIsar fromEntity(
      UserProfileAccessAllowance entity) {
    return UserProfileAccessAllowanceIsar()
      ..remoteId = entity.remoteId
      ..key = entity.key
      ..description = entity.description
      ..accessTypeIndex = entity.accessType.index
      ..createdAt = entity.createdAt
      ..lastUpdatedAt = entity.lastUpdatedAt;
  }
}
