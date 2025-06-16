import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/globals.dart';

Future<String?> customPromptForPassword(
    BuildContext context, String userName) async {
  final controller = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (context) {
      void confirm() {
        Navigator.of(context).pop(controller.text);
      }

      return AlertDialog(
        title: Text('required_login'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${'user'.tr()}: ',
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
              decoration: InputDecoration(labelText: 'password'.tr()),
              onSubmitted: (_) => confirm(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text('cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: confirm,
            child: Text('confirm'.tr()),
          ),
        ],
      );
    },
  );
}
