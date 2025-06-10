import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/sync_services/request_sync.dart';

class CustomUnsyncedIcon extends StatelessWidget {
  const CustomUnsyncedIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await requestSync(context);
      },
      icon: const Icon(
        Icons.sync_problem,
        color: Colors.amberAccent,
      ),
    );
  }
}
