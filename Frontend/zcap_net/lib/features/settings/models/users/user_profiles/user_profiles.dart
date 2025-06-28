import 'package:zcap_net_app/core/services/remote_table.dart';

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
      'accessAllowances': [], //TODO: access_allowances list
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

/*
  UserProfile copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    bool? isSynced,
  }) {
    return UserProfile(
      remoteId: id ?? remoteId,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
  */
}
