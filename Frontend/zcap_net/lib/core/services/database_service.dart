import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;
import 'package:zcap_net_app/core/services/app_config.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_types/incident_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/relation_type/relation_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/special_needs/special_needs_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/support/support_needed_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_access_keys_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profile_access_allowance_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/building_types/building_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities/entities_isar.dart';
import 'package:zcap_net_app/features/settings/models/entities/entity_types/entity_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/treeLevelDetailType/tree_level_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_levels/tree_level_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_detail_types/tree_record_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_details/tree_record_detail_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/users/users_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/detail_type_categories/detail_type_categories_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_details/zcap_details_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcaps/zcap_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_detail_types/zcap_detail_type_isar.dart';

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

/* ZCAPS */
    CollectionSchemaEntry(BuildingTypesIsarSchema,
        (db) => db.buildingTypesIsars, 'buildingTypes', 'buildingTypeId'),
    CollectionSchemaEntry(
        DetailTypeCategoriesIsarSchema,
        (db) => db.detailTypeCategoriesIsars,
        'detail-type-categories',
        'detailTypeCategoryId'),
    CollectionSchemaEntry(
        ZcapDetailTypeIsarSchema,
        (db) => db.zcapDetailTypeIsars,
        'zcap-detail-types',
        'zcapDetailTypeId'),
    CollectionSchemaEntry(
        ZcapDetailsIsarSchema,
        (db) => db.zcapDetailsIsars,
        'zcap-details',
        'zcapDetailId'),

/* Incidents */
    CollectionSchemaEntry(IncidentTypesIsarSchema,
        (db) => db.incidentTypesIsars, 'incident-types', 'incidentTypeId'),

/* Support Tables */
    CollectionSchemaEntry(
        EntitiesIsarSchema, (db) => db.entitiesIsars, 'entities', 'entityId'),
    CollectionSchemaEntry(EntityTypeIsarSchema, (db) => db.entityTypeIsars,
        'entity-types', 'entityTypeId'),

/* Persons */
    CollectionSchemaEntry(RelationTypeIsarSchema, (db) => db.relationTypeIsars,
        'relation-type', 'relationTypeId'),
    CollectionSchemaEntry(SpecialNeedIsarSchema, (db) => db.specialNeedIsars,
        'special-needs', 'specialNeedId'),
    CollectionSchemaEntry(SupportNeededIsarSchema,
        (db) => db.supportNeededIsars, 'support-needed', 'supportNeededId'),

/* Users */
    CollectionSchemaEntry(
        UsersIsarSchema, (db) => db.usersIsars, 'users', 'userId'),
    CollectionSchemaEntry(
        UserAccessKeysIsarSchema,
        (db) => db.userAccessKeysIsars,
        'users/access-keys',
        'userProfileAccessKeyId'),
    CollectionSchemaEntry(UserProfilesIsarSchema, (db) => db.userProfilesIsars,
        'user/profiles', 'userProfileId'),
    CollectionSchemaEntry(
        UserProfileAccessAllowanceIsarSchema,
        (db) => db.userProfileAccessAllowanceIsars,
        '',
        'userProfileAccessKeyId'),

/* TREE */
    CollectionSchemaEntry(
        TreeIsarSchema, (db) => db.treeIsars, 'trees', 'treeId'),
    CollectionSchemaEntry(TreeLevelIsarSchema, (db) => db.treeLevelIsars,
        'tree-levels', 'treeLevelId'),
    CollectionSchemaEntry(
        TreeRecordDetailTypeIsarSchema,
        (db) => db.treeRecordDetailTypeIsars,
        'tree-record-detail-types',
        'treeRecordDetailTypeId'),
    CollectionSchemaEntry(TreeRecordDetailIsarSchema,
        (db) => db.treeRecordDetailIsars, 'tree-record-details', 'detailId'),
    CollectionSchemaEntry(
        TreeLevelDetailTypeIsarSchema,
        (db) => db.treeLevelDetailTypeIsars,
        'tree-level-detail-type',
        'treeLevelDetailTypeId'),

/*
 * ZCAPS
*/
    CollectionSchemaEntry( ZcapIsarSchema,
        (db) => db.zcapIsars, 'zcaps', 'zcapId'),

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
