import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/shared/models.dart';

class Relations extends ApiTable {
  @override
  int remoteId;

  Persons person1;
  Persons person2;
  RelationType relationType;

  final DateTime createdAt;
  @override
  DateTime lastUpdatedAt;

  Relations(
      {required this.remoteId,
      required this.person1,
      required this.person2,
      required this.relationType,
      required this.createdAt,
      required this.lastUpdatedAt});

  @override
  Map<String, dynamic> toJsonInput() {
    return {
      'personId1': person1.remoteId,
      'personId2': person2.remoteId,
      'relationTypeId': relationType.remoteId
    };
  }

  factory Relations.fromJson(Map<String, dynamic> json) => Relations(
      remoteId: json['relationId'],
      person1: Persons.fromJson(json['person1']),
      person2: Persons.fromJson(json['person2']),
      relationType: RelationType.fromJson(json['relationType']),
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']));

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    return {
      'personId1': person1.remoteId,
      'personId2': person2.remoteId,
      'relationTypeId': relationType.remoteId
    };
  }

  Relations copyWith({
    int? remoteId,
    Persons? person1,
    Persons? person2,
    RelationType? relationType,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) {
    return Relations(
      remoteId: remoteId ?? this.remoteId,
      person1: person1 ?? this.person1,
      person2: person2 ?? this.person2,
      relationType: relationType ?? this.relationType,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
