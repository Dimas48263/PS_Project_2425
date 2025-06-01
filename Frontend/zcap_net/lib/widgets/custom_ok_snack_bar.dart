import 'package:flutter/material.dart';
import '../shared/shared.dart';

class CustomOkSnackBar {
  static void show(
    BuildContext context, 
    String message,
    {
    TextAlign textAlign = TextAlign.center,
    Color backgroundColor = AppColors.ok,
    Color textColor = AppColors.text,
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.bold,
    Duration duration = const Duration(seconds: 1),
  }
    ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
  }
}