import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/globals.dart';

class UserDataAccessScreen extends StatefulWidget {
  const UserDataAccessScreen({super.key});

  @override
  State<UserDataAccessScreen> createState() => _UserDataAccessScreenState();
}

class _UserDataAccessScreenState extends State<UserDataAccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('screen_settings_user_access_data'.tr()),
      ),
    );
  }
}