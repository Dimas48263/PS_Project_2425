import 'package:zcap_net_app/core/services/database_service.dart';

import 'sync_service.dart';
import 'package:zcap_net_app/core/services/sync_service_v3.dart';


final syncService = SyncService(DatabaseService.db);
final syncServiceV3 = SyncServiceV3(DatabaseService.db);