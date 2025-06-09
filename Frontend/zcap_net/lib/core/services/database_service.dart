import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;
import 'package:zcap_net_app/core/services/app_config.dart';
import 'package:zcap_net_app/features/settings/models/building_types/building_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities_isar.dart';
import 'package:zcap_net_app/features/settings/models/entity_types/entity_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/tree_levels/tree_level_isar.dart';
import 'package:zcap_net_app/features/settings/models/tree_record_detail_types/tree_record_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/users/users_isar.dart';

class CollectionSchemaEntry {
  final CollectionSchema schema;
  final IsarCollection<dynamic> Function(Isar) collection;
  final String endpoint;
  final String idName;

  CollectionSchemaEntry(
      this.schema, this.collection, this.endpoint, this.idName);
}

class DatabaseService {
  static late final Isar db;

  static final List<CollectionSchemaEntry> collectionSchemas = [
    CollectionSchemaEntry(BuildingTypesIsarSchema,
        (db) => db.buildingTypesIsars, 'buildingTypes', 'buildingTypeId'),
    CollectionSchemaEntry(
        EntitiesIsarSchema, (db) => db.entitiesIsars, 'entities', 'entityId'),
    CollectionSchemaEntry(EntityTypeIsarSchema, (db) => db.entityTypeIsars,
        'entity-types', 'entityTypeId'),
    CollectionSchemaEntry(
        UsersIsarSchema, (db) => db.usersIsars, 'users', 'userId'),
    CollectionSchemaEntry(UserProfilesIsarSchema, (db) => db.userProfilesIsars,
        'user-profiles', 'userProfileId'),
    CollectionSchemaEntry(
        TreeIsarSchema, (db) => db.treeIsars, 'trees', 'treeId'),
    CollectionSchemaEntry(TreeLevelIsarSchema, (db) => db.treeLevelIsars,
        'tree-levels', 'treeLevelId'),
    CollectionSchemaEntry(
        TreeRecordDetailTypeIsarSchema,
        (db) => db.treeRecordDetailTypeIsars,
        'tree-record-detail-types',
        'treeRecordDetailTypeId'),
  ];

  static Future<void> setup() async {
    final appDir = p.join(AppConfig.instance.appDataPath, 'db');
    await Directory(appDir).create(recursive: true);

    db = await Isar.open(
      collectionSchemas.map((e) => e.schema).toList(),
      directory: appDir,
    );
  }

  static IsarCollection<dynamic> getCollectionByEndpoint(String endpoint) {
    final entry = collectionSchemas.firstWhere((e) => e.endpoint == endpoint);
    return entry.collection(db); // só agora se acede ao `db`
  }
}
