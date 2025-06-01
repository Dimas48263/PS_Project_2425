import 'package:zcap_net_app/core/services/database_service.dart';

import 'sync_service.dart';
import 'isar_service_v2.dart';
import 'package:zcap_net_app/features/settings/models/tree_levels/tree_level_isar.dart';
import 'package:zcap_net_app/core/services/sync_service_v2.dart';
import 'package:zcap_net_app/core/services/sync_service_v3.dart';


final syncService = SyncService(DatabaseService.db);
final syncServiceV3 = SyncServiceV3(DatabaseService.db);

final treeLevelIsarService = IsarServiceV2<TreeLevelIsar>();
final treeLevelSyncService = SyncServiceV2<TreeLevelIsar>(treeLevelIsarService, 'tree-levels', 'treeLevelId');