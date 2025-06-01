import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/tree_levels/tree_level.dart';

class Tree implements ApiTable {
  @override
  int id;
  final String name;
  final TreeLevel treeLevel;
  final Tree? parent;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Tree({
    required this.id,
    required this.name,
    required this.treeLevel,
    this.parent,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tree.fromJson(Map<String, dynamic> json) {
  return Tree(
    id: json['treeRecordId'],
    name: json['name'],
    treeLevel: TreeLevel.fromJson(json['treeLevel']),
    parent: json['parent'] != null ? Tree.fromJson(json['parent']) : null,
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
      'treeLevelId': treeLevel.id,
      'parentId': parent?.id,
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
    DateTime? updatedAt,
  }) {
    return Tree(
      id: id ?? this.id,
      name: name ?? this.name,
      treeLevel: treeLevel ?? this.treeLevel,
      parent: parent ?? this.parent,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 