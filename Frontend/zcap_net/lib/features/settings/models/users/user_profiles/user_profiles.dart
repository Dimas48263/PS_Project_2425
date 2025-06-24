import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profile_access_allowance.dart';

class UserProfile implements ApiTable {
  @override
  final int remoteId;
  final String name;
  final List<UserProfileAccessAllowance> accessAllowances;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;
  bool isSynced;

  UserProfile({
    required this.remoteId,
    required this.name,
    required this.accessAllowances,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.isSynced = true,
  });

factory UserProfile.fromJson(Map<String, dynamic> json) {
  final accessAllowancesList = (json['accessAllowances'] as List<dynamic>?)
      ?.map((e) => UserProfileAccessAllowance.fromJson(e))
      .toList() ?? [];

  final profile = UserProfile(
    remoteId: json['userProfileId'],
    name: json['name'],
    accessAllowances: accessAllowancesList,
    startDate: DateTime.parse(json['startDate']),
    endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
    lastUpdatedAt: json['lastUpdatedAt'] != null
        ? DateTime.parse(json['lastUpdatedAt'])
        : DateTime.now(),
  );
  LogService.log(profile.toString());
  return profile;
}

  @override
  Map<String, dynamic> toJsonInput() {
    return {
      'name': name,
      'accessAllowances': accessAllowances.map((e) => e.toJson()).toList(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  UserProfile copyWith({
    int? id,
    String? name,
    List<UserProfileAccessAllowance>? accessAllowances,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    bool? isSynced,
  }) {
    return UserProfile(
      remoteId: id ?? remoteId,
      name: name ?? this.name,
      accessAllowances: accessAllowances ?? this.accessAllowances,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
