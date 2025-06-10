import 'package:zcap_net_app/core/services/remote_table.dart';

class TreeRecordDetailType implements ApiTable {
  @override
  int remoteId;
  final String name;
  final String unit;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  TreeRecordDetailType(
      {required this.remoteId,
      required this.name,
      required this.unit,
      required this.startDate,
      this.endDate,
      required this.createdAt,
      required this.updatedAt});

  @override
  Map<String, dynamic> toJsonInput() {
    return {
      'name': name,
      'unit': unit,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  factory TreeRecordDetailType.fromJson(Map<String, dynamic> json) {
    return TreeRecordDetailType(
      remoteId: json['detailTypeId'],
      name: json['name'],
      unit: json['unit'],
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

  TreeRecordDetailType copyWith({
    int? id,
    String? name,
    String? unit,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TreeRecordDetailType(
      remoteId: id ?? this.remoteId,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
