import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities/entities.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/building_types/building_type.dart';

class Zcap implements ApiTable {
  @override
  int remoteId;
  final String name;
  final BuildingType? buildingType;
  final String address;
  final Tree? tree;
  final double? latitude;
  final double? longitude;
  final Entity? zcapEntity;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;
  bool isSynced;

  Zcap({
    required this.remoteId,
    required this.name,
    required this.buildingType,
    required this.address,
    required this.tree,
    this.latitude,
    this.longitude,
    required this.zcapEntity,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.isSynced = true,
  });

  factory Zcap.fromJson(Map<String, dynamic> json) {
    return Zcap(
      remoteId: json['zcapId'],
      name: json['name'],
      buildingType: json['buildingType'] != null
          ? BuildingType.fromJson(json['buildingType'])
          : null,
      address: json['address'],
      tree: json['treeRecordId'] != null
          ? Tree.fromJson(json['treeRecordId'])
          : null,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      zcapEntity:
          json['entityId'] != null ? Entity.fromJson(json['entityId']) : null,
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJsonInput() {
    return {
      'name': name,
      'buildingTypeId': buildingType?.remoteId,
      'address': address,
      'treeRecordId': tree?.remoteId,
      'latitude': latitude,
      'longitude': longitude,
      'entityId': zcapEntity?.remoteId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    return {
      'name': name,
      'buildingTypeId': buildingType?.remoteId,
      'address': address,
      'treeRecordId': tree?.remoteId,
      'latitude': latitude,
      'longitude': longitude,
      'entityId': zcapEntity?.remoteId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  Zcap copyWith({
    int? remoteId,
    String? name,
    BuildingType? buildingType,
    String? address,
    Tree? tree,
    double? latitude,
    double? longitude,
    Entity? ent,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    bool? isSynced,
  }) {
    return Zcap(
      remoteId: remoteId ?? this.remoteId,
      name: name ?? this.name,
      buildingType: buildingType ?? this.buildingType,
      address: address ?? this.address,
      tree: tree ?? this.tree,
      latitude: latitude ?? this.latitude,
      zcapEntity: ent ?? zcapEntity,
      longitude: longitude ?? this.longitude,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
