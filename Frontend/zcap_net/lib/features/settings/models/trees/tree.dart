import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/tree_levels/tree_level.dart';

class Tree implements ApiTable {
  @override
  int remoteId;
  final String name;
  final TreeLevel treeLevel;
  final Tree? parent;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;

  Tree({
    required this.remoteId,
    required this.name,
    required this.treeLevel,
    this.parent,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  factory Tree.fromJson(Map<String, dynamic> json) {
    return Tree(
      remoteId: json['treeRecordId'],
      name: json['name'],
      treeLevel: TreeLevel.fromJson(json['treeLevel']),
      parent: json['parent'] != null ? Tree.fromJson(json['parent']) : null,
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
      'treeLevelId': treeLevel.remoteId,
      'parentId': parent?.remoteId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  Tree copyWith({
    int? id,
    String? name,
    TreeLevel? treeLevel,
    Tree? parent,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) {
    return Tree(
      remoteId: id ?? this.remoteId,
      name: name ?? this.name,
      treeLevel: treeLevel ?? this.treeLevel,
      parent: parent ?? this.parent,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
