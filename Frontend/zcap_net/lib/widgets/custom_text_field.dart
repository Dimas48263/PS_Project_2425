import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String fieldName;
  final IconData prefixIcon;
  final bool obscureText;
  final FocusNode? focusNode;
  final void Function(String)? onSubmitted;

  final String? Function(String?)? validator;
  final TextInputType inputType;
  final double width;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.fieldName,
    required this.prefixIcon,
    required this.inputType,
    this.obscureText = false,
    this.focusNode,
    this.onSubmitted,
    this.validator,
    this.width = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // margem inferior de 16
      child: SizedBox(
        width: width,
        child: TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          focusNode: focusNode,
          onFieldSubmitted: onSubmitted,
          decoration: InputDecoration(
            labelText: fieldName,
            labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            prefixIcon: Icon(prefixIcon),
          ),
        ),
      ),
    );
  }
}
