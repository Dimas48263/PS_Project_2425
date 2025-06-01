import 'package:flutter/material.dart';

class CancelTextButton extends StatelessWidget {
  const CancelTextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
    onPressed: () => Navigator.pop(context),
    child: const Text('Cancelar'),
                    );
  }
}