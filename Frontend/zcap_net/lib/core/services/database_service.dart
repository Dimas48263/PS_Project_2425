import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;
import 'package:zcap_net_app/core/services/app_config.dart';
import 'package:zcap_net_app/shared/models.dart';


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
