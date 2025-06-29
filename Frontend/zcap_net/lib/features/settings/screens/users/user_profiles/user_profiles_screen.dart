import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profile_access_allowance_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';
import 'package:zcap_net_app/features/settings/screens/users/user_profiles/user_access_editor_screen.dart';

import 'package:zcap_net_app/shared/shared.dart';

class UserProfilesScreen extends StatefulWidget {
  const UserProfilesScreen({super.key});

  @override
  State<UserProfilesScreen> createState() => _UserProfilesScreenState();
}

class _UserProfilesScreenState extends State<UserProfilesScreen> {
  List<UserProfilesIsar> userProfiles = [];
  StreamSubscription? userProfilesStream;

  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    userProfilesStream = DatabaseService.db.userProfilesIsars
        .buildQuery<UserProfilesIsar>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        userProfiles = data;
        _isLoading = false;
      });
    });

    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    userProfilesStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredUserProfiles = userProfiles.where((entity) {
      final name = entity.name.toLowerCase();
      return name.contains(_searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('screen_settings_user_profiles'.tr()),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              CustomSearchAndAddBar(
                controller: _searchController,
                onSearchChanged: (value) => setState(() {
                  _searchTerm = value.toLowerCase();
                }),
                onAddPressed: _addOrEditUserProfile,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: filteredUserProfiles.length,
                        itemBuilder: (context, index) {
                          final userProfile = filteredUserProfiles[index];
                          return Card(
                            child: ListTile(
                              contentPadding: EdgeInsets.only(
                                left: 10.0,
                              ),
                              title: Text(
                                '${userProfile.remoteId != null ? "[${userProfile.remoteId}] " : ""}${userProfile.name}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomLabelValueText(
                                            label: 'start'.tr(),
                                            value: userProfile.startDate
                                                .toLocal()
                                                .toString()
                                                .split(' ')[0]),
                                      ),
                                      Expanded(
                                        child: CustomLabelValueText(
                                          label: 'end'.tr(),
                                          value: userProfile.endDate != null
                                              ? userProfile.endDate!
                                                  .toLocal()
                                                  .toString()
                                                  .split(' ')[0]
                                              : 'no_end_date'.tr(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.vpn_key),
                                    tooltip:
                                        'tooltip_edit_user_allowances'.tr(),
                                    onPressed: () {
                                      _editUserAccessAllowances(userProfile);
                                    },
                                  ),
                                  if (!userProfile.isSynced)
                                    CustomUnsyncedIcon(),
                                  IconButton(
                                    onPressed: () {
                                      _addOrEditUserProfile(
                                          userProfile: userProfile);
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => ConfirmDialog(
                                          title: 'confirm_delete'.tr(),
                                          content:
                                              'confirm_delete_message'.tr(),
                                        ),
                                      );
                                      if (confirm == true) {
                                        await DatabaseService.db
                                            .writeTxn(() async {
                                          await DatabaseService
                                              .db.userProfilesIsars
                                              .delete(userProfile.id);
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  void _addOrEditUserProfile({UserProfilesIsar? userProfile}) async {
    final nameController = TextEditingController(text: userProfile?.name ?? "");
    DateTime selectedStartDate = userProfile?.startDate ?? DateTime.now();
    DateTime? selectedEndDate = userProfile?.endDate;

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        final allowances = context.watch<UserAllowancesProvider>();

        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text(userProfile != null
                  ? '${'edit'.tr()} ${'screen_userProfile_type'.tr()}'
                  : '${'new'.tr()} ${'screen_userProfile_type'.tr()}'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            labelText: 'screen_userProfile_name'.tr()),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'required_field'.tr();
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12.0),
                      CustomDateRangePicker(
                        startDate: selectedStartDate,
                        endDate: selectedEndDate,
                        onStartDateChanged: (newStart) {
                          setModalState(() {
                            selectedStartDate = newStart;
                          });
                        },
                        onEndDateChanged: (newEnd) {
                          setModalState(() {
                            selectedEndDate = newEnd;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                      allowances.canWrite('user_access_settings_user_profiles')
                          ? 'cancel'.tr()
                          : 'close'.tr()),
                  onPressed: () => Navigator.pop(context),
                ),
                if (allowances.canWrite('user_access_settings_user_profiles'))
                  TextButton(
                    child: Text('save'.tr()),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final name = nameController.text.trim();

                        final updatedProfile =
                            userProfile ?? UserProfilesIsar();
                        updatedProfile.name = name;
                        updatedProfile.startDate = selectedStartDate;
                        updatedProfile.endDate = selectedEndDate;
                        updatedProfile.lastUpdatedAt = DateTime.now();
                        updatedProfile.isSynced = false;

                        await DatabaseService.db.writeTxn(() async {
                          await DatabaseService.db.userProfilesIsars
                              .put(updatedProfile);
                        });

                        Navigator.of(context).pop();
                      }
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _editUserAccessAllowances(UserProfilesIsar profile) async {
    final originalAllowances = await DatabaseService
        .db.userProfileAccessAllowanceIsars
        .filter()
        .userProfile((q) => q.idEqualTo(profile.id))
        .sortByKey()
        .findAll();

    final editableAllowances =
        originalAllowances.map((a) => a.copyWith()).toList();

    await showDialog(
      context: context,
      builder: (_) {
        final allowances = context.watch<UserAllowancesProvider>();
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                  '${'tooltip_edit_user_allowances'.tr()} - ${profile.name}'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: UserAccessEditor(
                  allowances: editableAllowances,
                  onChanged: (edited, newType) {
                    setState(() {
                      edited.accessTypeIndex = newType;
                      edited.lastUpdatedAt = DateTime.now();
                    });
                  },
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                      allowances.canWrite('user_access_settings_user_profiles')
                          ? 'cancel'.tr()
                          : 'close'.tr()),
                  onPressed: () => Navigator.pop(context),
                ),
                if (allowances.canWrite('user_access_settings_user_profiles'))
                  TextButton(
                    child: Text('save'.tr()),
                    onPressed: () async {
                      await DatabaseService.db.writeTxn(() async {
                        for (final edited in editableAllowances) {
                          await DatabaseService
                              .db.userProfileAccessAllowanceIsars
                              .put(edited);
                        }
                      });

                      profile.isSynced = false;
                      profile.lastUpdatedAt = DateTime.now();
                      await DatabaseService.db.writeTxn(() async {
                        await DatabaseService.db.userProfilesIsars.put(profile);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
