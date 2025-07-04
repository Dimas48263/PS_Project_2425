import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_detail_types/tree_record_detail_type.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree.dart';

class TreeRecordDetail implements ApiTable {
  @override
  int remoteId;

  final Tree tree;
  final TreeRecordDetailType detailType;
  final String valueCol;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;

  TreeRecordDetail({
    required this.remoteId,
    required this.tree,
    required this.detailType,
    required this.valueCol,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  factory TreeRecordDetail.fromJson(Map<String, dynamic> json) {
    return TreeRecordDetail(
      remoteId: json['detailId'],
      tree: Tree.fromJson(json['treeRecord']),
      detailType: TreeRecordDetailType.fromJson(json['detailType']),
      valueCol: json['valueCol'],
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
      'treeRecordId': tree.remoteId,
      'detailTypeId': detailType.remoteId,
      'valueCol': valueCol,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    return {
      'treeRecordId': tree.remoteId,
      'detailTypeId': detailType.remoteId,
      'valueCol': valueCol,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
