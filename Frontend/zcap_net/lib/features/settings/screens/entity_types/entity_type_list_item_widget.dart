/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/entity_types/entity_type.dart';

class EntityTypeListItem extends StatelessWidget {
  const EntityTypeListItem({
    super.key,
    required this.entityType,
    required this.dateFormat,
    required this.onEdit,
  });

  final EntityType entityType;
  final DateFormat dateFormat;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        entityType.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  "Inicio:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  " ${dateFormat.format(entityType.startDate)}",
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Text(
                  "Fim:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  entityType.endDate != null
                      ? " ${dateFormat.format(entityType.endDate!)}"
                      : " --- ",
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!entityType.isSynced)
            IconButton(icon: Icon(Icons.sync_problem, color: Colors.orange, size: 30),
            onPressed: () {
              print('update pressed');
            },),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}
*/