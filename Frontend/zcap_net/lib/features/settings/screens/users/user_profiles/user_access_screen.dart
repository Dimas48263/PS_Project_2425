/*
import 'package:flutter/material.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/acess_type.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_access_keys.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_detail_isar.dart';

class UserAccessEditor extends StatefulWidget {
  final List<UserProfileDetail> details;
  final void Function(UserProfileDetail, AccessType) onChanged;

  const UserAccessEditor({
    super.key,
    required this.details,
    required this.onChanged,
  });

  @override
  State<UserAccessEditor> createState() => _UserAccessEditorState();
}

class _UserAccessEditorState extends State<UserAccessEditor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.details.length,
            itemBuilder: (context, index) {
              final detail = widget.details[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(child: Text(detail.permissionKey.label)),
                    const SizedBox(width: 8),
                    DropdownButton<AccessType>(
                      value: detail.accessType,
                      onChanged: (newType) {
                        if (newType != null) {
                          setState(() {
                            detail.accessType = newType;
                          });
                          widget.onChanged(detail, newType);
                        }
                      },
                      items: AccessType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.label),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
*/