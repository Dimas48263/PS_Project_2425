import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities/entities.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incidents/incidents.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcaps/zcap.dart';

class IncidentZcaps implements ApiTable {
  @override
  int remoteId;
  final Incidents incident;
  final Zcap zcap;
  final Entity entity;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;

  IncidentZcaps({
    required this.remoteId,
    required this.incident,
    required this.zcap,
    required this.entity,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  factory IncidentZcaps.fromJson(Map<String, dynamic> json) {
    return IncidentZcaps(
      remoteId: json['incidentZcapId'],
      incident: Incidents.fromJson(json['incident']),
      zcap: Zcap.fromJson(json['zcap']),
      entity: Entity.fromJson(json['entity']),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJsonInput() {
    return {
      'incidentId': incident.remoteId,
      'zcapId': zcap.remoteId,
      'entityId': entity.remoteId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String()
    };
  }

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    return {
      'incidentId': incident.remoteId,
      'zcapId': zcap.remoteId,
      'entityId': entity.remoteId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String()
    };
  }

  IncidentZcaps copyWith(
      {int? remoteId,
      Incidents? incident,
      Zcap? zcap,
      Entity? entity,
      DateTime? startDate,
      DateTime? endDate,
      DateTime? createdAt,
      DateTime? lastUpdatedAt}) {
    return IncidentZcaps(
      remoteId: remoteId ?? this.remoteId,
      incident: incident ?? this.incident,
      zcap: zcap ?? this.zcap,
      entity: entity ?? this.entity,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
