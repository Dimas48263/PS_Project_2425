import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';

class UserAccessKeys implements ApiTable {
  @override
  int remoteId; //userProfileAccessKeyId
  final String accessKey;
  final String description;

  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;
  bool isSynced;

  UserAccessKeys({
    required this.remoteId,
    required this.accessKey,
    required this.description,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.isSynced = true,
  });

  factory UserAccessKeys.fromJson(Map<String, dynamic> json) {
    return UserAccessKeys(
      remoteId: json['userProfileAccessKeyId'],
      accessKey: json['accessKey'],
      description: json['description'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastUpdatedAt: json['lastUpdatedAt'] != null
          ? DateTime.parse(json['lastUpdatedAt'])
          : DateTime.now(),
    );
  }

  @override
  Map<String, dynamic> toJsonInput() {
    return {'accessKey': accessKey, 'description': description};
  }

  UserAccessKeys copyWith({
    int? id,
    String? accessKey,
    String? description,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    bool? isSynced,
  }) {
    return UserAccessKeys(
      remoteId: id ?? remoteId,
      accessKey: accessKey ?? this.accessKey,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}