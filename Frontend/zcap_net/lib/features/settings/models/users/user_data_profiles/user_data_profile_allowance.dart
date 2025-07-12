
class UserDataProfileAllowance {
  final int userDataProfileId;
  final int treeRecordId;

  UserDataProfileAllowance({
    required this.userDataProfileId,
    required this.treeRecordId,
  });

  factory UserDataProfileAllowance.fromJson(Map<String, dynamic> json) {
    return UserDataProfileAllowance(
      userDataProfileId: json['userDataProfileId'],
      treeRecordId: json['treeRecordId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userDataProfileId': userDataProfileId,
      'treeRecordId': treeRecordId,
    };
  }
}
