import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/users/user_data_profiles/user_data_profile_allowance.dart';
import 'package:zcap_net_app/features/settings/models/users/user_data_profiles/user_data_profile_allowance_isar.dart';

class UserDataProfile implements ApiTable {
  @override
  final int remoteId;
  final String name;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;
  bool isSynced;

  final List<UserDataProfileAllowance> userDataProfileAllowances;

  UserDataProfile({
    required this.remoteId,
    required this.name,
    required this.startDate,
    this.endDate,
    this.userDataProfileAllowances = const [],
    required this.createdAt,
    required this.lastUpdatedAt,
    this.isSynced = true,
  });

  factory UserDataProfile.fromJson(Map<String, dynamic> json) {
    final profile = UserDataProfile(
      remoteId: json['userDataProfileId'],
      name: json['name'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      userDataProfileAllowances:
          (json['userDataProfileDetail'] as List<dynamic>?)
                  ?.map((e) => UserDataProfileAllowance.fromJson(e))
                  .toList() ??
              [],
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
      'dataAllowances':
          [], //no datallowances, need to use async version instead
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    final dataAllowances = await DatabaseService
        .db.userDataProfileAllowanceIsars
        .filter()
        .userDataProfileIdEqualTo(remoteId)
        .findAll();

    return {
      'name': name,
      'dataAllowances':
          dataAllowances.map((a) => a.toEntity().toJson()).toList(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
