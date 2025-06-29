import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_levels/tree_level.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_detail_types/tree_record_detail_type.dart';

class TreeLevelDetailType implements ApiTable {
  @override
  final int remoteId;
  final TreeLevel treeLevel;
  final TreeRecordDetailType detailType;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;

  TreeLevelDetailType(
      {required this.remoteId,
      required this.treeLevel,
      required this.detailType,
      required this.startDate,
      this.endDate,
      required this.createdAt,
      required this.lastUpdatedAt});

  @override
  Map<String, dynamic> toJsonInput() {
    return {
      'treeLevelId': treeLevel.remoteId,
      'detailTypeId': detailType.remoteId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    return {
      'treeLevelId': treeLevel.remoteId,
      'detailTypeId': detailType.remoteId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  factory TreeLevelDetailType.fromJson(Map<String, dynamic> json) =>
      TreeLevelDetailType(
        remoteId: json['treeLevelDetailTypeId'] as int,
        treeLevel:
            TreeLevel.fromJson(json['treeLevel'] as Map<String, dynamic>),
        detailType: TreeRecordDetailType.fromJson(
            json['detailType'] as Map<String, dynamic>),
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: json['endDate'] == null
            ? null
            : DateTime.parse(json['endDate'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
        lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
      );

  TreeLevelDetailType copyWith({
    int? remoteId,
    TreeLevel? treeLevel,
    TreeRecordDetailType? detailType,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) {
    return TreeLevelDetailType(
      remoteId: remoteId ?? this.remoteId,
      treeLevel: treeLevel ?? this.treeLevel,
      detailType: detailType ?? this.detailType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
