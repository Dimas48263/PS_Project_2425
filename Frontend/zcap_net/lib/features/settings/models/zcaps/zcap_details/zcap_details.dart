import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_detail_types/zcap_detail_type.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcaps/zcap.dart';

class ZcapDetails implements ApiTable {
  @override
  int remoteId;
  final String valueCol;
  final Zcap zcap;
  final ZcapDetailType zcapDetailType;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;

  ZcapDetails(
      {required this.remoteId,
      required this.valueCol,
      required this.zcap,
      required this.zcapDetailType,
      required this.startDate,
      this.endDate,
      required this.createdAt,
      required this.lastUpdatedAt});

  factory ZcapDetails.fromJson(Map<String, dynamic> json) {
    return ZcapDetails(
      remoteId: json['zcapDetailId'],
      valueCol: json['valueCol'],
      zcap: Zcap.fromJson(json['zcap']),
      zcapDetailType: ZcapDetailType.fromJson(json['zcapDetailType']),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJsonInput() {
    return {
      'zcapId': zcap.remoteId,
      'zcapDetailTypeId': zcapDetailType.remoteId,
      'valueCol': valueCol,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    return {
      'zcapId': zcap.remoteId,
      'zcapDetailTypeId': zcapDetailType.remoteId,
      'valueCol': valueCol,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  ZcapDetails copyWith(
      {int? remoteId,
      String? valueCol,
      Zcap? zcap,
      ZcapDetailType? zcapDetailType,
      DateTime? startDate,
      DateTime? endDate,
      DateTime? createdAt,
      DateTime? lastUpdatedAt}) {
    return ZcapDetails(
      remoteId: remoteId ?? this.remoteId,
      valueCol: valueCol ?? this.valueCol,
      zcap: zcap ?? this.zcap,
      zcapDetailType: zcapDetailType ?? this.zcapDetailType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
