import 'package:flutter/cupertino.dart';

class TextControllersInputFormCongig {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;

  TextControllersInputFormCongig({
    required this.controller,
    required this.label,
    this.validator,
  });
}