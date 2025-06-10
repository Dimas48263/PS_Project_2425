import 'package:zcap_net_app/core/services/log_service.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';

class Entity implements ApiTable {
  @override
  final int id;
  final String name;
  final int entityTypeId;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  Entity({
    required this.id,
    required this.name,
    required this.entityTypeId,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = true,
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      id: json['entityId'],
      name: json['name'],
      entityTypeId: json['entityType']?['entityTypeId'],
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
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
