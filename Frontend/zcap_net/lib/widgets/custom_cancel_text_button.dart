import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/globals.dart';

class CancelTextButton extends StatelessWidget {
  const CancelTextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text('cancel'.tr()),
    );
  }
}
