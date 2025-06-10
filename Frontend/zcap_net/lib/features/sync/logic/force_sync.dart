import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/auth_service.dart';
import 'package:zcap_net_app/core/services/session_manager.dart';
import 'package:zcap_net_app/core/services/sync_services/sync_service_manager.dart';
import 'package:zcap_net_app/features/sync/ui/prompt_for_password.dart';
import 'package:zcap_net_app/shared/shared.dart';


Future<void> forceSync(BuildContext context) async {
  final session = SessionManager();

  if (session.token == null || session.isTokenExpired()) {
    final username = session.userName ?? "";
    final password = await promptForPassword(context, username);

    if (password == null || password.isEmpty) {
      CustomNOkSnackBar.show(context, "Sincronização cancelada.");
      return;
    }

    final success = await AuthService().login(username, password);
    if (!success || session.token == null || session.isTokenExpired()) {
      CustomNOkSnackBar.show(context, "Falha no login remoto.");
      return;
    }
  }

  await SyncServiceManager().syncNow();
  CustomOkSnackBar.show(context, "Sincronização concluída com sucesso.");
}


