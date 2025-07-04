import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/entities/entity_types/entity_type.dart';

class Entity implements ApiTable {
  @override
  final int remoteId;
  final String name;
  final EntityType entityType;
  final String? email;
  final String phone1;
  final String? phone2;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;
  final bool isSynced;

  Entity({
    required this.remoteId,
    required this.name,
    required this.entityType,
    this.email,
    required this.phone1,
    this.phone2,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.isSynced = true,
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      remoteId: json['entityId'],
      name: json['name'],
      entityType: EntityType.fromJson(json['entityType']),
      email: json['email'],
      phone1: json['phone1'],
      phone2: json['phone2'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJsonInput() {
    return {
      'name': name,
      'entityTypeId': entityType.remoteId,
      if (email != null) 'email': email,
      'phone1': phone1,
      if (phone2 != null) 'phone2': phone2,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    return {
      'name': name,
      'entityTypeId': entityType.remoteId,
      if (email != null) 'email': email,
      'phone1': phone1,
      if (phone2 != null) 'phone2': phone2,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
