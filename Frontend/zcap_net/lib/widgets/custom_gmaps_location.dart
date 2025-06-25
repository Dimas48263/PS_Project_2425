import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zcap_net_app/core/services/globals.dart';

class CustomGMapsLocationButton extends StatelessWidget {
  final String latitude;
  final String longitude;

  const CustomGMapsLocationButton({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final lat = double.tryParse(latitude);
    final lng = double.tryParse(longitude);

    return IconButton(
      icon: const Icon(Icons.location_on),
      tooltip:
          '${'zcap_screen_open_location'.tr()}:\n ${'latitude'.tr()}: $latitude \n ${'longitude'.tr()}: $longitude',
      onPressed: () async {
        if (lat == null || lng == null) {
          return; //no valid references, do nothing
        }

        final url = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
        );

        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('zcap_screen_open_location_error'.tr()),
            ),
          );
        }
      },
    );
  }
}
