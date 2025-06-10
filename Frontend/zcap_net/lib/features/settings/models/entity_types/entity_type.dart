import 'package:zcap_net_app/core/services/remote_table.dart';

class EntityType implements ApiTable{
  @override
  int id;
  final String name;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool isSynced;

  EntityType({
    required this.id,
    required this.name,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = true,
  });

factory EntityType.fromJson(Map<String, dynamic> json) {
  return EntityType(
    id: json['entityTypeId'],
    name: json['name'],
    startDate: DateTime.parse(json['startDate']),
    endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
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

/*
  EntityType copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return EntityType(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }*/
}
