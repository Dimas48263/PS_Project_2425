import 'package:zcap_net_app/core/services/log_service.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/acess_type.dart';

class UserProfileAccessAllowance {
  final int remoteId;
  final String key;
  final String description;
  final AccessType accessType;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;

  UserProfileAccessAllowance({
    required this.remoteId,
    required this.key,
    required this.description,
    required this.accessType,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  factory UserProfileAccessAllowance.fromJson(Map<String, dynamic> json) {
    return UserProfileAccessAllowance(
      remoteId: json['userProfileAccessKeyId'],
      key: json['key'],
      description: json['description'],
      accessType: AccessType.values[json['accessType']],
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    LogService.log('Name: ${accessType.name} | Index: ${accessType.index}');
    return {
      'userProfileAccessKeyId': remoteId,
      'accessType': accessType.index,
    };
  }
}
