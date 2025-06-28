import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/acess_type.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles.dart';

class UserProfileAccessAllowance implements ApiTable {
  @override
  final int remoteId;
  final UserProfile userProfile;
  final String key;
  final String description;
  final AccessType accessType;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;
  final bool isSynced;

  UserProfileAccessAllowance({
    required this.remoteId,
    required this.userProfile,
    required this.key,
    required this.description,
    required this.accessType,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.isSynced = true,
  });

  factory UserProfileAccessAllowance.fromJson(Map<String, dynamic> json) {
    return UserProfileAccessAllowance(
      remoteId: json['userProfileAccessKeyId'],
      userProfile: UserProfile.fromJson(json['userProfile']),
      key: json['key'],
      description: json['description'],
      accessType: AccessType.values[json['accessType']],
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJsonInput() {
    return {
      'userProfileAccessKeyId': remoteId,
      'accessType': accessType.index,
    };
  }
}
