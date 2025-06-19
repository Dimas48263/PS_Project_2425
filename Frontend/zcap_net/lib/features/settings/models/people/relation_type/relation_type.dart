import 'package:zcap_net_app/core/services/remote_table.dart';

class RelationType implements ApiTable{
  @override
  int remoteId;
  final String name;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;
  bool isSynced;

  RelationType({
    required this.remoteId,
    required this.name,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.isSynced = true,
  });

factory RelationType.fromJson(Map<String, dynamic> json) {
  return RelationType(
    remoteId: json['relationTypeId'],
    name: json['name'],
    startDate: DateTime.parse(json['startDate']),
    endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
    lastUpdatedAt: json['lastUpdatedAt'] != null
        ? DateTime.parse(json['lastUpdatedAt'])
        : DateTime.now(),
  );
}

@override
  Map<String, dynamic> toJsonInput() {
    return {
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  RelationType copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    bool? isSynced,
  }) {
    return RelationType(
      remoteId: id ?? remoteId,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
