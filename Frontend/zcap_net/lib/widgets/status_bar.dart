import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/auth_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/notifiers.dart';
import 'package:zcap_net_app/core/services/session_manager.dart';
import 'package:zcap_net_app/widgets/custom_nok_snack_bar.dart';
import 'package:zcap_net_app/widgets/custom_ok_snack_bar.dart';
import 'package:zcap_net_app/widgets/custom_prompt_for_password.dart';

class StatusBar extends StatelessWidget {
  final String? userName;

  const StatusBar({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.0,
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text(
            '${'user'.tr()}: ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            userName ?? '',
            style: const TextStyle(fontSize: 16),
          ),
          Expanded(
            child: Center(
              child: StreamBuilder<DateTime>(
                stream: Stream.periodic(
                    const Duration(minutes: 1), (_) => DateTime.now()),
                builder: (context, snapshot) {
                  final now = snapshot.data ?? DateTime.now();
                  final formatted =
                      '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} '
                      '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
                  return Text(
                    formatted,
                    style: const TextStyle(fontSize: 14),
                  );
                },
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
              valueListenable: isOnlineNotifier,
              builder: (context, isOnline, child) {
                LogService.log(
                  'log_online_status'.tr(namedArgs: {
                    'status': isOnline.toString(),
                  }),
                );
                return isOnline
                    ? InkWell(
                        onTap: () async {
                          await syncServiceV3.synchronizeAll();
                        },
                        child: Icon(
                          Icons.cloud_outlined,
                          color: Colors.green,
                          size: 25.0,
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          try {
                            final apiStatus = await apiService.ping();
                            if (apiStatus.statusCode != 200) {
                              LogService.log('Offline');
                              CustomNOkSnackBar.show(context, 'api_error'.tr());
                              return;
                            }

                            final userName = SessionManager().userName!;
                            final password = await customPromptForPassword(
                                context, userName);
                            if (password == null) return;

                            final success =
                                await AuthService().login(userName, password);
                            if (success) {
                              CustomOkSnackBar.show(
                                context,
                                'login_ok'.tr(),
                              );
                              await syncServiceV3.synchronizeAll();
                            }
                          } catch (e, stack) {
                            LogService.log('Erro no login ou sincronização: $e\n$stack');
                            CustomNOkSnackBar.show(
                                context, 'Erro desconhecido');
                          }
                        },
                        child: Icon(
                          Icons.cloud_off,
                          color: Colors.red,
                          size: 25.0,
                        ),
                      );
              })
        ],
      ),
    );
  }
}
