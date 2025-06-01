import 'package:flutter/material.dart';

Future<void> showNotImplementedDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Aviso'),
      content: const Text('A funcionalidade não está implementada.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}