import 'package:zcap_net_app/core/services/remote_table.dart';

class DetailTypeCategories implements ApiTable {
  @override
  int remoteId;
  final String name;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;

  DetailTypeCategories(
      {required this.remoteId,
      required this.name,
      required this.startDate,
      required this.endDate,
      required this.createdAt,
      required this.lastUpdatedAt});

  factory DetailTypeCategories.fromJson(Map<String, dynamic> json) {
    return DetailTypeCategories(
      remoteId: json['detailTypeCategoryId'],
      name: json['name'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJsonInput() => {
        'detailTypeCategoryId': remoteId,
        'name': name,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
      };

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    return {
      'detailTypeCategoryId': remoteId,
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }

  DetailTypeCategories copyWith({
    int? remoteId,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) {
    return DetailTypeCategories(
      remoteId: remoteId ?? this.remoteId,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
