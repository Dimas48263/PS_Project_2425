/*import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/auth_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/session_manager.dart';
import 'package:zcap_net_app/core/services/sync_services/sync_service_manager.dart';
import 'package:zcap_net_app/widgets/custom_prompt_for_password.dart';
import 'package:zcap_net_app/shared/shared.dart';

Future<void> requestSync(BuildContext context) async {
  final session = SessionManager();

  // Se não houver token válido, pede a senha
  if (session.token == null || session.isTokenExpired()) {
    final username = session.userName ?? "";
    final password = await customPromptForPassword(context, username);

    if (password == null || password.isEmpty) {
      CustomNOkSnackBar.show(context, 'sync_cancel'.tr());
      return;
    }

    final success = await AuthService().login(username, password);
    if (!success || session.token == null || session.isTokenExpired()) {
      CustomNOkSnackBar.show(context, 'sync_auth_failed'.tr());
      return;
    }
  }

  try {
    await SyncServiceManager().syncNow();
    if (!context.mounted) return;
    CustomOkSnackBar.show(context, 'sync_ok'.tr());
  } catch (e) {
    if (!context.mounted) return;
    CustomNOkSnackBar.show(context, 'sync_error'.tr(namedArgs: {'error': e.toString()}));
  }
}
*/