import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/features/settings/screens/users/users/user_service.dart';
import 'package:zcap_net_app/shared/shared.dart';

void showChangePasswordDialog(BuildContext context) {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool passwordsMatch = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('change_password'.tr()),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: currentPasswordController,
                      obscureText: true,
                      decoration:
                          InputDecoration(labelText: 'current_password'.tr()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'required_field'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomPasswordConfirmation(
                      passwordController: newPasswordController,
                      passwordConfirmationController: confirmPasswordController,
                      onValidationChanged: (valid) {
                        setState(() => passwordsMatch = valid);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text('cancel'.tr()),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate() || !passwordsMatch) {
                    return;
                  }

                  final result = await UserService.updatePassword(
                    currentPassword: currentPasswordController.text,
                    newPassword: newPasswordController.text,
                  );

                  if (result.success) {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (_) => CustomAlertDialog(
                        title: 'success'.tr(),
                        content: result.message ?? '',
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => CustomAlertDialog(
                        title: 'error'.tr(),
                        content: result.message ?? 'unknown_error'.tr(),
                      ),
                    );
                  }
                },
                child: Text('save'.tr()),
              ),
            ],
          );
        },
      );
    },
  );
}
