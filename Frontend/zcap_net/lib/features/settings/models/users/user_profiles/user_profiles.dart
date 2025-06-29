import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profile_access_allowance_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';

class UserProfile implements ApiTable {
  @override
  final int remoteId;
  final String name;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;
  bool isSynced;

  UserProfile({
    required this.remoteId,
    required this.name,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.isSynced = true,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final profile = UserProfile(
      remoteId: json['userProfileId'],
      name: json['name'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastUpdatedAt: json['lastUpdatedAt'] != null
          ? DateTime.parse(json['lastUpdatedAt'])
          : DateTime.now(),
    );
    return profile;
  }

  @override
  Map<String, dynamic> toJsonInput() {
    return {
      'name': name,
      'accessAllowances':
          [], //no accessallowances, need to use async version instead
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    final allowances = await DatabaseService.db.userProfileAccessAllowanceIsars
        .filter()
        .userProfile((q) => q.remoteIdEqualTo(remoteId))
        .findAll();

    return {
      'name': name,
      'accessAllowances':
          allowances.map((a) => a.toEntity().toJsonInput()).toList(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
