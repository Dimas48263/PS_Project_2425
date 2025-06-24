import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/notifiers.dart';
import 'package:zcap_net_app/core/services/sync_services/sync_service_manager.dart';

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
                          await SyncServiceManager().syncNow();
                        },
                        child: Icon(
                          Icons.cloud_outlined,
                          color: Colors.green,
                          size: 25.0,
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          await syncServiceV3.synchronizeAll();
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
