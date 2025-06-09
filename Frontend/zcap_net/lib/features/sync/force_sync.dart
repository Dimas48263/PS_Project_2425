import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/auth_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/session_manager.dart';
import 'package:zcap_net_app/core/services/log_service.dart';
import 'package:zcap_net_app/shared/shared.dart';


Future<void> forceSync(BuildContext context) async {
  final session = SessionManager();

  if (session.token == null || session.isTokenExpired()) {
    LogService.log("[Sync] API Token invalido. Solicitar credenciais.");

    final username = session.userName ?? "";
    final password = await promptForPassword(context, username);

    if (password == null || password.isEmpty) {
      CustomNOkSnackBar.show(context, "Sincronização cancelada.");
      LogService.log("[Sync] Tentativa cancelada pelo utilizador.");
      return;
    }

    final success = await AuthService().login(username, password);

    if (!success || session.token == null || session.isTokenExpired()) {
      LogService.log("[Sync] Login remoto falhado.");

      CustomNOkSnackBar.show(
          context, "Falha no login remoto. Tente novamente.");
      return;
    }

    LogService.log("[Sync] Login com sucesso. A iniciar sincronização...");
  }

  await syncServiceV3.synchronizeAll();
  LogService.log("[Sync] Pedido de sincronização concluído.");
  CustomOkSnackBar.show(
    context,
    "Pedido de sincronização concluído com sucesso.",
  );
}

Future<String?> promptForPassword(BuildContext context, String userName) async {
  final controller = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (context) {
      void confirm() {
        Navigator.of(context).pop(controller.text);
      }

      return AlertDialog(
        title: const Text("Autenticação necessária"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "User: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(userName, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
              onSubmitted: (_) => confirm(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: confirm,
            child: const Text("Confirmar"),
          ),
        ],
      );
    },
  );
}
