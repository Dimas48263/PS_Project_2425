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
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredAllowances = widget.allowances.where((allowance) {
      final translatedKey = allowance.key.tr().toLowerCase();
      return translatedKey.contains(_searchTerm);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'search'.tr(),
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredAllowances.length,
            itemBuilder: (context, index) {
              final allowance = filteredAllowances[index];
              final currentType = allowance.accessTypeIndex;

              return ListTile(
                title: Text(allowance.key.tr()),
                subtitle: CustomLabelValueText(
                    label: 'key'.tr(), value: allowance.key),
                trailing: DropdownButton<AccessType>(
                  value: currentType,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        allowance.accessTypeIndex =
                            AccessType.values[newValue.index];
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
          ),
        ),
      ],
    );
  }
}
