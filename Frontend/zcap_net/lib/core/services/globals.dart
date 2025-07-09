
export 'package:easy_localization/easy_localization.dart';
export 'package:zcap_net_app/core/services/log_service.dart';

import 'package:zcap_net_app/core/services/api_service.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/sync_service.dart';


final apiService = ApiService();
final syncService = SyncService(DatabaseService.db);




