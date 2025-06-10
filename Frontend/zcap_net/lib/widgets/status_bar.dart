import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/log_service.dart';
import 'package:zcap_net_app/core/services/notifiers.dart';
import 'package:zcap_net_app/core/services/sync_services/request_sync.dart';

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
            'User: ',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            userName ?? '',
            style: const TextStyle(fontSize: 14),
          ),
          const Spacer(),
          ValueListenableBuilder<bool>(
              valueListenable: isOnlineNotifier,
              builder: (context, isOnline, child) {
                LogService.log('Online: $isOnline');
                return isOnline
                    ? InkWell(
                        onTap: () async {
                          await requestSync(context);
                        },
                        child: Icon(
                          Icons.cloud_outlined,
                          color: Colors.green,
                          size: 18.0,
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          await requestSync(context);
                        },
                        child: Icon(
                          Icons.cloud_off,
                          color: Colors.red,
                          size: 18.0,
                        ),
                      );
              })
        ],
      ),
    );
  }
}
