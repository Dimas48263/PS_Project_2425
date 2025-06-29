import 'package:zcap_net_app/core/services/remote_table.dart';

class EntityType implements ApiTable {
  @override
  int remoteId;
  final String name;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;
  bool isSynced;

  EntityType({
    required this.remoteId,
    required this.name,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.isSynced = true,
  });

  factory EntityType.fromJson(Map<String, dynamic> json) {
    return EntityType(
      remoteId: json['entityTypeId'],
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

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    return {
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  EntityType copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    bool? isSynced,
  }) {
    return EntityType(
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
