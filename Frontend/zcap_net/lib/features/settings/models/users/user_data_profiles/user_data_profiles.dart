import 'package:zcap_net_app/core/services/remote_table.dart';

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

  UserDataProfile({
    required this.remoteId,
    required this.name,
    required this.startDate,
    this.endDate,
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
//      'dataAllowances':
//          [], //no datallowances, need to use async version instead
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
//    final dataAllowances = await isarDb.userDataProfileAllowanceIsars
//        .filter()
//        .userDataProfileIdEqualTo(remoteId)
//        .findAll();

    return {
      'name': name,
//      'dataAllowances':
//          dataAllowances.map((a) => a.toEntity().toJson()).toList(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
