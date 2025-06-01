import 'package:flutter/material.dart';
import '../shared/shared.dart';

class CustomNOkSnackBar {
  static void show(
    BuildContext context, 
    String message,
    {
    TextAlign textAlign = TextAlign.center,
    Color backgroundColor = AppColors.error,
    Color textColor = AppColors.text,
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.bold,
    Duration duration = const Duration(seconds: 2),
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