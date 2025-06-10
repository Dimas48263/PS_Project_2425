import 'package:flutter/material.dart';

Future<String?> customPromptForPassword(BuildContext context, String userName) async {
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
