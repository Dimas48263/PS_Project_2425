import 'package:flutter/cupertino.dart';

class TextControllersInputFormConfig {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;

  TextControllersInputFormConfig({
    required this.controller,
    required this.label,
    this.validator,
  });
}