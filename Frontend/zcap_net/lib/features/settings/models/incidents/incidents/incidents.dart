import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_types/incident_types.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree.dart';

class Incidents implements ApiTable {
  @override
  int remoteId;
  final IncidentTypes incidentType;
  final Tree treeRecord;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;

  Incidents(
      {required this.remoteId,
      required this.incidentType,
      required this.treeRecord,
      required this.startDate,
      this.endDate,
      required this.createdAt,
      required this.lastUpdatedAt});

  factory Incidents.fromJson(Map<String, dynamic> json) {
    return Incidents(
      remoteId: json['incidentId'],
      incidentType: IncidentTypes.fromJson(json['incidentType']),
      treeRecord: Tree.fromJson(json['treeRecord']),
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
      'treeRecordId': treeRecord.remoteId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    return {
      'incidentTypeId': incidentType.remoteId,
      'treeRecordId': treeRecord.remoteId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }

  Incidents copyWith(
      {int? remoteId,
      IncidentTypes? incidentType,
      Tree? treeRecord,
      DateTime? startDate,
      DateTime? endDate,
      DateTime? createdAt,
      DateTime? lastUpdatedAt}) {
    return Incidents(
      remoteId: remoteId ?? this.remoteId,
      incidentType: incidentType ?? this.incidentType,
      treeRecord: treeRecord ?? this.treeRecord,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
