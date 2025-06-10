import 'package:zcap_net_app/core/services/remote_table.dart';

class Entity implements ApiTable {
  @override
  final int remoteId;
  final String name;
  final int entityTypeId;
  final String? email;
  final String phone1;
  final String? phone2;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  Entity({
    required this.remoteId,
    required this.name,
    required this.entityTypeId,
    this.email,
    required this.phone1,
    this.phone2,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = true,
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      remoteId: json['entityId'],
      name: json['name'],
      entityTypeId: json['entityType']?['entityTypeId'],
      email: json['email'],
      phone1: json['phone1'],
      phone2: json['phone2'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJsonInput() {
    return {
      'name': name,
      'entityTypeId': entityTypeId,
      if (email != null) 'email': email,
      'phone1': phone1,
      if (email != null) 'phone2': phone2,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
