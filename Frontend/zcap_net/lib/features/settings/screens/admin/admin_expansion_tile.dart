import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/constants/api_constants.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/shared/shared.dart';

class AdminExpansionTile extends StatefulWidget {
  final Widget child;
  const AdminExpansionTile({super.key, required this.child});

  @override
  State<AdminExpansionTile> createState() => _AdminExpansionTileState();
}

class _AdminExpansionTileState extends State<AdminExpansionTile> {
  bool _isAuthorized = false;
  bool _isExpanded = false;

  Future<void> _askPassword() async {
    final authorized = await showDialog<bool>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();

        void tryConfirm() {
          if (controller.text == ApiConstants.specialAdminPassword) {
            Navigator.pop(context, true);
          } else {
            CustomNOkSnackBar.show(context, 'login_nok'.tr());
          }
        }

        return AlertDialog(
          title: Text('admin_password'.tr()),
          content: TextField(
            controller: controller,
            obscureText: true,
            autofocus: true,
            onSubmitted: (_) => tryConfirm(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('cancel'.tr()),
            ),
            ElevatedButton(
              onPressed: tryConfirm,
              child: Text('confirm'.tr()),
            ),
          ],
        );
      },
    );

    if (authorized == true) {
      setState(() {
        _isAuthorized = true;
        _isExpanded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('admin'.tr()),
      leading: const Icon(Icons.maps_home_work_outlined),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      initiallyExpanded: _isExpanded,
      onExpansionChanged: (expanded) {
        if (expanded && !_isAuthorized) {
          _askPassword();
        } else {
          setState(() {
            _isExpanded = expanded;
          });
        }
      },
      children: _isAuthorized ? [widget.child] : [],
    );
  }
}
