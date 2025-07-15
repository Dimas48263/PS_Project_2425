import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/people/persons/persons.dart';
import 'package:zcap_net_app/features/settings/models/people/special_needs/special_needs.dart';

class PersonSpecialNeeds implements ApiTable {
  @override
  int remoteId;
  final Persons person;
  final SpecialNeed specialNeed;
  final String? description;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;

  PersonSpecialNeeds({
    required this.remoteId,
    required this.person,
    required this.specialNeed,
    this.description,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  factory PersonSpecialNeeds.fromJson(Map<String, dynamic> json) {
    return PersonSpecialNeeds(
      remoteId: json['personSpecialNeedId'],
      person: Persons.fromJson(json['person']),
      specialNeed: SpecialNeed.fromJson(json['specialNeed']),
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
      'personSpecialNeedId': remoteId,
      'personId': person.remoteId,
      'specialNeedId': specialNeed.remoteId,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String()
    };
  }

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    return {
      'personSpecialNeedId': remoteId,
      'personId': person.remoteId,
      'specialNeedId': specialNeed.remoteId,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String()
    };
  }

  PersonSpecialNeeds copyWith(
      {int? remoteId,
      Persons? person,
      SpecialNeed? specialNeed,
      String? description,
      DateTime? startDate,
      DateTime? endDate,
      DateTime? createdAt,
      DateTime? lastUpdatedAt}) {
    return PersonSpecialNeeds(
      remoteId: remoteId ?? this.remoteId,
      person: person ?? this.person,
      specialNeed: specialNeed ?? this.specialNeed,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
