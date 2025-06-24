import 'package:flutter/material.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/acess_type.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profile_access_allowance_isar.dart';

class UserAccessEditor extends StatefulWidget {
  final List<UserProfileAccessAllowanceIsar> allowances;
  final void Function(UserProfileAccessAllowanceIsar, AccessType) onChanged;

  const UserAccessEditor({
    super.key,
    required this.allowances,
    required this.onChanged,
  });

  @override
  State<UserAccessEditor> createState() => _UserAccessEditorState();
}

class _UserAccessEditorState extends State<UserAccessEditor> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.allowances.length,
      itemBuilder: (context, index) {
        final allowance = widget.allowances[index];
        final currentType = AccessType.values[allowance.accessTypeIndex];

        return ListTile(
          title: Text(allowance.description),
          subtitle: Text("Chave: ${allowance.key}"),
          trailing: DropdownButton<AccessType>(
            value: currentType,
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() {
                  allowance.accessTypeIndex = newValue.index;
                  allowance.lastUpdatedAt = DateTime.now();
                });
                widget.onChanged(allowance, newValue);
              }
            },
            items: AccessType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.name),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
