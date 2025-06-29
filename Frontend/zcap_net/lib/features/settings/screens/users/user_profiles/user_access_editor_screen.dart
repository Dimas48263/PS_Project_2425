import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/acess_type.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profile_access_allowance_isar.dart';
import 'package:zcap_net_app/widgets/custom_label_value_text.dart';

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
        final currentType = allowance.accessTypeIndex;

        return ListTile(
          title: Text(allowance.key.tr()),
          subtitle: CustomLabelValueText(label: 'key'.tr(), value: allowance.key),
          trailing: DropdownButton<AccessType>(
            value: currentType,
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() {
                  allowance.accessTypeIndex = AccessType.values[newValue.index];
                  allowance.lastUpdatedAt = DateTime.now();
                });
                widget.onChanged(allowance, newValue);
              }
            },
            items: AccessType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.label),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
