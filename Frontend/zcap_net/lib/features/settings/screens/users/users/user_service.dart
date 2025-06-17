import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/features/settings/models/users/users/users_isar.dart';
import 'package:zcap_net_app/shared/shared.dart';

class UserService {
  static Future<bool> validateUniqueUserName({
    required String userName,
    required BuildContext context,
    int? ownUserId,
  }) async {
    final existingUser = await DatabaseService.db.usersIsars
        .filter()
        .userNameEqualTo(userName.trim().toLowerCase())
        .findFirst();

    if (existingUser != null && existingUser.id != ownUserId) {
      showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: 'error'.tr(),
          content: 'user_exists'.tr(),
        ),
      );
      return false;
    }
    return true;
  }
}
