import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/sync_services/sync_service_manager.dart';

class CustomUnsyncedIcon extends StatelessWidget {
  const CustomUnsyncedIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await SyncServiceManager().syncNow();
      },
      icon: const Icon(
        Icons.sync_problem,
        color: Colors.amberAccent,        
      ),
    );
  }
}
