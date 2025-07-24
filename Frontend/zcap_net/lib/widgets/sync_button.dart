import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/auth_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/notifiers.dart';
import 'package:zcap_net_app/core/services/session_manager.dart';
import 'package:zcap_net_app/shared/shared.dart';
import 'package:zcap_net_app/widgets/custom_prompt_for_password.dart';

class SyncButton extends StatelessWidget {
  const SyncButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isOnlineNotifier,
        builder: (context, isOnline, child) {
          return IconButton(
            icon: const Icon(Icons.sync),
            color: isOnline ? AppColors.online : AppColors.offline,
            onPressed: () async {
              if (!isOnline) {
                try {
                  final apiStatus = await apiService.ping();
                  if (apiStatus.statusCode != 200) {
                    LogService.log('Offline');
                    CustomNOkSnackBar.show(context, 'api_error'.tr());
                    return;
                  }

                  final userName = SessionManager().userName!;
                  final password =
                      await customPromptForPassword(context, userName);
                  if (password == null) return;

                  final success = await AuthService().login(userName, password);
                  if (!success) {
                    CustomNOkSnackBar.show(context, 'login_fail'.tr());
                    return;
                  } else {
                    CustomOkSnackBar.show(context, 'login_ok'.tr());
                  }
                } catch (e, stack) {
                  LogService.log('Erro de login ou sincronização: $e\n$stack');
                  CustomNOkSnackBar.show(context, 'service_sync_error'.tr());
                  return;
                }
              }

              final success = await syncService.synchronizeAll();
              if (success) {
                CustomOkSnackBar.show(context, 'service_sync_ok'.tr());
              } else {
                CustomNOkSnackBar.show(context, 'service_sync_error'.tr());
              }
            },
          );
        });
  }
}
