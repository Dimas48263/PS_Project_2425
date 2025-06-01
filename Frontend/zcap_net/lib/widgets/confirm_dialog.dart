import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color iconColor;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.icon = Icons.warning,
    this.iconColor = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
            children: [
              Icon(icon, color: iconColor, size: 50.0,),
              const SizedBox(width: 12),
              Expanded(child: Text(title)),
            ],
          ),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
