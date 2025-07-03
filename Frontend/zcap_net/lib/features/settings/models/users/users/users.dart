import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles.dart';

class Users implements ApiTable{
  @override
  final int remoteId;
  final String userName;
  final String name;
  final String password;
  final UserProfile userProfile;
//  final UserDataProfile userDataProfile;


  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;
  bool isSynced;

  Users({
    required this.remoteId,
    required this.userName,
    required this.name,
    required this.password,
    required this.userProfile,
//    required this.userDataProfile,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.isSynced = true,
  });

    factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      remoteId: json['userId'],
      userName: json['userName'],
      name: json['name'],
      password: json['password'],
      userProfile: UserProfile.fromJson(json['userProfile']),
//      userDataProfile: UserDataProfile.fromJson(json['userDataProfile']),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
    );
  }

    @override
  Map<String, dynamic> toJsonInput() {
    return {
      'userName': userName,
      'name': name,
      'password': password,
      'userProfileId': userProfile.remoteId,
//      'userDataProfileId': userDataProfile.remoteId,
      'userDataProfileId': 1, //TODO: userDataProfile
      'startDate': startDate.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
    };
  }

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    return toJsonInput();
  }
}