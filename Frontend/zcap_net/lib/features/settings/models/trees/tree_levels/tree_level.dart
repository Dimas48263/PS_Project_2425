import 'package:zcap_net_app/core/services/remote_table.dart';

class TreeLevel implements ApiTable {
  @override
  int remoteId;
  final int levelId;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;

  TreeLevel({
    required this.remoteId,
    required this.levelId,
    required this.name,
    this.description,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  factory TreeLevel.fromJson(Map<String, dynamic> json) {
    return TreeLevel(
      remoteId: json['treeLevelId'],
      levelId: json['levelId'],
      name: json['name'],
      description: json['description'],
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
      'levelId': levelId,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    return {
      'levelId': levelId,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  TreeLevel copyWith({
    int? id,
    int? levelId,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) {
    return TreeLevel(
      remoteId: id ?? this.remoteId,
      levelId: levelId ?? this.levelId,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
