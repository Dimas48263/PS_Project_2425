import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_types/incident_types.dart';

class Incidents implements ApiTable {
  @override
  int remoteId;
  final IncidentTypes incidentType;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;

  Incidents(
      {required this.remoteId,
      required this.incidentType,
      required this.startDate,
      this.endDate,
      required this.createdAt,
      required this.lastUpdatedAt});

  factory Incidents.fromJson(Map<String, dynamic> json) {
    return Incidents(
      remoteId: json['incidentId'],
      incidentType: IncidentTypes.fromJson(json['incidentType']),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJsonInput() {
    return {
      'incidentTypeId': incidentType.remoteId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    return {
      'incidentTypeId': incidentType.remoteId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  Incidents copyWith(
      {int? remoteId,
      IncidentTypes? incidentType,
      DateTime? startDate,
      DateTime? endDate,
      DateTime? createdAt,
      DateTime? lastUpdatedAt}) {
    return Incidents(
      remoteId: remoteId ?? this.remoteId,
      incidentType: incidentType ?? this.incidentType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
