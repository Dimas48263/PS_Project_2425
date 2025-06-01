import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities_isar.dart';
import 'package:zcap_net_app/features/settings/models/entity_types/entity_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/tree_levels/tree_level_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/users/users_isar.dart';

class DatabaseService {
  static late final Isar db;

  static Future<void> setup() async {
    final appDir = await getApplicationDocumentsDirectory();

    db = await Isar.open(
      [EntitiesIsarSchema, 
      EntityTypeIsarSchema,
      UsersIsarSchema, 
      UserProfilesIsarSchema,
      TreeIsarSchema,
      TreeLevelIsarSchema],
      directory: appDir.path,
    );
  }
}
