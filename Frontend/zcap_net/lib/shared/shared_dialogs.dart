import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/globals.dart';

Future<void> showNotImplementedDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('warning'.tr()),
      content: Text('not_implemented'.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('ok'.tr()),
        ),
      ],
    ),
  );
}
