
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_zcaps/incident_zcaps.dart';
import 'package:zcap_net_app/features/settings/models/people/persons/persons.dart';

class IncidentZcapPersons implements ApiTable{
  @override
  int remoteId;
  final IncidentZcaps incidentZcap;
  final Persons person;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;

  IncidentZcapPersons({
    required this.remoteId,
    required this.incidentZcap,
    required this.person,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  factory IncidentZcapPersons.fromJson(Map<String, dynamic> json) {
    return IncidentZcapPersons(
      remoteId: json['incidentZcapPersonId'],
      incidentZcap: IncidentZcaps.fromJson(json['incidentZcap']),
      person: Persons.fromJson(json['person']),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJsonInput() {
    return {
      'incidentZcapId': incidentZcap.remoteId,
      'personId': person.remoteId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    return {
      'incidentZcapId': incidentZcap.remoteId,
      'personId': person.remoteId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  IncidentZcapPersons copyWith({
    int? remoteId,
    IncidentZcaps? incidentZcap,
    Persons? person,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) {
    return IncidentZcapPersons(
      remoteId: remoteId ?? this.remoteId,
      incidentZcap: incidentZcap ?? this.incidentZcap,
      person: person ?? this.person,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}