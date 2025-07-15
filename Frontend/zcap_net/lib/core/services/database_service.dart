import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;
import 'package:zcap_net_app/core/services/app_config.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_types/incident_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_zcap_persons/incident_zcap_persons_isar.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_zcaps/incident_zcaps_isar.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incidents/incidents_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/departure_destination/departure_destination_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/person_special_needs/person_special_needs_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/person_support_needed/person_support_needed_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/persons/persons_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/relation_type/relation_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/special_needs/special_needs_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/support/support_needed_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_data_profiles/user_data_profile_allowance_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_data_profiles/user_data_profiles_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_access_keys/user_access_keys_isar.dart';
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

class DatabaseService {
  static late final Isar db;

  static List<CollectionSchema> schemas = [
    /**
     * Tree
     */
    TreeLevelIsarSchema,
    TreeIsarSchema,
    TreeRecordDetailTypeIsarSchema,
    TreeRecordDetailIsarSchema,
    TreeLevelDetailTypeIsarSchema,
    
    /**
     * Entities
     */
    EntityTypeIsarSchema,
    EntitiesIsarSchema,

    /**
     * ZCAPs
     */
    BuildingTypesIsarSchema,
    ZcapIsarSchema,
    DetailTypeCategoriesIsarSchema,
    ZcapDetailTypeIsarSchema,
    ZcapDetailsIsarSchema,
    
    /**
     * Persons
     */
    DepartureDestinationIsarSchema,
    PersonsIsarSchema,
    SpecialNeedIsarSchema,
    PersonSpecialNeedsIsarSchema,
    SupportNeededIsarSchema,
    PersonSupportNeededIsarSchema,
    RelationTypeIsarSchema,
    //TODO Relations
    
    /**
     * Incidents
     */
    IncidentTypesIsarSchema,
    IncidentsIsarSchema,
    IncidentZcapsIsarSchema,
    IncidentZcapPersonsIsarSchema,
    
    /**
     * Users
     */
    UserDataProfilesIsarSchema,
    UserDataProfileAllowanceIsarSchema,
    UserProfilesIsarSchema,
    UserAccessKeysIsarSchema,
    UserProfileAccessAllowanceIsarSchema,
    UsersIsarSchema,
  ];

  static Future<void> setup() async {
    final appDir = p.join(AppConfig.instance.appDataPath, 'db');
    await Directory(appDir).create(recursive: true);

    db = await Isar.open(
      schemas,
      directory: appDir,
      inspector: true,
    );
  }
}
