import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/session_manager.dart';
import 'package:zcap_net_app/shared/bool_with_feedback.dart';
import 'package:zcap_net_app/features/settings/models/users/users/users_isar.dart';
import 'package:zcap_net_app/shared/security_utils.dart';
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

  static Future<BoolWithFeedback> updatePassword(
      {required String currentPassword, required String newPassword}) async {
    final userName = SessionManager().userName;
    if (userName == null) {
      return BoolWithFeedback(
          success: false, message: 'no_user_logged_in'.tr());
    }

    final user = await DatabaseService.db.usersIsars
        .filter()
        .userNameEqualTo(userName.trim().toLowerCase())
        .findFirst();

    if (user == null) {
      return BoolWithFeedback(success: false, message: 'user_not_found'.tr());
    }

    if (!verifyPassword(currentPassword, user.password)) {
      return BoolWithFeedback(success: false, message: 'no_matching_password'.tr());
    }

    user
      ..password = hashPassword(newPassword)
      ..lastUpdatedAt = DateTime.now()
      ..isSynced = false;

    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.usersIsars.put(user);
    });

    return BoolWithFeedback(success: true, message: 'password_changed'.tr());
  }
}
