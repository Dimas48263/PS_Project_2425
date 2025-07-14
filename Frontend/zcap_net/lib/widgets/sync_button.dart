import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/globals.dart';

class SyncButton extends StatelessWidget  {
  const SyncButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.sync),
      onPressed: () async {
        final success = await syncService.synchronizeAll();
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('service_sync_ok'.tr())),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('service_sync_error'.tr())),
          );
        }
      },
    );
  }
}
