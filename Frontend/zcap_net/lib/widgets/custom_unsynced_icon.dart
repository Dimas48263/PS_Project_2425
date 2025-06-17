import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/globals.dart';

class CustomUnsyncedIcon extends StatelessWidget {
  const CustomUnsyncedIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await syncServiceV3.synchronizeAll();
      },
      icon: const Icon(
        Icons.sync_problem,
        color: Colors.amberAccent,
      ),
    );
  }
}
