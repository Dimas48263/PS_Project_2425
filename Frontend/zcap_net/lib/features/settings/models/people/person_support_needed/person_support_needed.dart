
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/people/persons/persons.dart';
import 'package:zcap_net_app/features/settings/models/people/support/support_needed.dart';

class PersonSupportNeeded implements ApiTable {
  @override
  int remoteId;
  final Persons person;
  final SupportNeeded supportNeeded;
  final String? description;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;

  PersonSupportNeeded({
    required this.remoteId,
    required this.person,
    required this.supportNeeded,
    this.description,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  factory PersonSupportNeeded.fromJson(Map<String, dynamic> json) {
    return PersonSupportNeeded(
      remoteId: json['personSupportNeededId'],
      person: Persons.fromJson(json['person']),
      supportNeeded: SupportNeeded.fromJson(json['supportNeeded']),
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJsonInput() {
    return {
      'personSupportNeededId': remoteId,
      'personId': person.remoteId,
      'supportNeededId': supportNeeded.remoteId,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String()
    };
  }

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    return {
      'personSupportNeededId': remoteId,
      'personId': person.remoteId,
      'supportNeededId': supportNeeded.remoteId,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String()
    };
  }

  PersonSupportNeeded copyWith(
      {int? remoteId,
      Persons? person,
      SupportNeeded? supportNeeded,
      String? description,
      DateTime? startDate,
      DateTime? endDate,
      DateTime? createdAt,
      DateTime? lastUpdatedAt}) {
    return PersonSupportNeeded(
      remoteId: remoteId ?? this.remoteId,
      person: person ?? this.person,
      supportNeeded: supportNeeded ?? this.supportNeeded,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
