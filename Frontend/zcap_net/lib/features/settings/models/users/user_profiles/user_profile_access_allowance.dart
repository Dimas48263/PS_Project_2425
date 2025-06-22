

class UserProfileAccessAllowance {
  final int userProfileAccessKeyId;
  final int accessType;

  UserProfileAccessAllowance({
    required this.userProfileAccessKeyId,
    required this.accessType,
  });

  factory UserProfileAccessAllowance.fromJson(Map<String, dynamic> json) {
    return UserProfileAccessAllowance(
      userProfileAccessKeyId: json['userProfileAccessKeyId'],
      accessType: json['accessType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userProfileAccessKeyId': userProfileAccessKeyId,
      'accessType': accessType,
    };
  }
}
