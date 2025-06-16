import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zcap_net_app/core/services/globals.dart';

class CustomPasswordConfirmation extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmationController;
  final ValueChanged<bool> onValidationChanged;

  const CustomPasswordConfirmation({
    super.key,
    required this.passwordController,
    required this.passwordConfirmationController,
    required this.onValidationChanged,
  });

  @override
  State<CustomPasswordConfirmation> createState() =>
      _CustomPasswordConfirmationState();
}

class _CustomPasswordConfirmationState
    extends State<CustomPasswordConfirmation> {
  bool _passwordsMatch = false;

  @override
  void initState() {
    super.initState();
    widget.passwordController.addListener(_checkPasswords);
    widget.passwordConfirmationController.addListener(_checkPasswords);
  }

  @override
  void dispose() {
    widget.passwordController.removeListener(_checkPasswords);
    widget.passwordConfirmationController.removeListener(_checkPasswords);
    super.dispose();
  }

  void _checkPasswords() {
    final match = widget.passwordController.text.isNotEmpty &&
        widget.passwordController.text == widget.passwordConfirmationController.text;

    if (match != _passwordsMatch) {
      setState(() {
        _passwordsMatch = match;
      });
      widget.onValidationChanged(match);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.passwordController,
          obscureText: true,
          decoration: InputDecoration(labelText: 'password'.tr()),
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: widget.passwordConfirmationController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password_confirmation'.tr(),
            labelStyle: TextStyle(
              color: _passwordsMatch ? null : Colors.red,
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
        ),
        if (!_passwordsMatch)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'no_matching_password'.tr(),
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
