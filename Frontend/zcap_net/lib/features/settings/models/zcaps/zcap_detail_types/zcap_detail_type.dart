import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/data_types/data_types.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/detail_type_categories/detail_type_categories.dart';

class ZcapDetailType implements ApiTable {
  @override
  int remoteId;
  String name;
  DetailTypeCategories detailTypeCategory;
  DataTypes dataType;
  bool isMandatory;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  DateTime lastUpdatedAt;

  ZcapDetailType(
      {required this.remoteId,
      required this.name,
      required this.detailTypeCategory,
      required this.dataType,
      required this.isMandatory,
      required this.startDate,
      required this.endDate,
      required this.createdAt,
      required this.lastUpdatedAt});

  factory ZcapDetailType.fromJson(Map<String, dynamic> json) {
    return ZcapDetailType(
      remoteId: json['zcapDetailTypeId'],
      name: json['name'],
      detailTypeCategory:
          DetailTypeCategories.fromJson(json['detailTypeCategory']),
      dataType: DataTypesExtension.fromString(json['dataType'] as String),
      isMandatory: json['isMandatory'],
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
      'detailTypeCategoryId': detailTypeCategory.remoteId,
      'dataType': dataType.name,
      'isMandatory': isMandatory,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    return {
      'name': name,
      'detailTypeCategoryId': detailTypeCategory.remoteId,
      'dataType': dataType.name,
      'isMandatory': isMandatory,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  ZcapDetailType copyWith({
    int? remoteId,
    String? name,
    DetailTypeCategories? detailTypeCategory,
    DataTypes? dataType,
    bool? isMandatory,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) {
    return ZcapDetailType(
      remoteId: remoteId ?? this.remoteId,
      name: name ?? this.name,
      detailTypeCategory: detailTypeCategory ?? this.detailTypeCategory,
      dataType: dataType ?? this.dataType,
      isMandatory: isMandatory ?? this.isMandatory,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
