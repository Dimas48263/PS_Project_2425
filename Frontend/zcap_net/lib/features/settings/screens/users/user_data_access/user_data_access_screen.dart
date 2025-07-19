import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/features/settings/models/users/user_data_profiles/user_data_profiles_isar.dart';
import 'package:zcap_net_app/features/settings/screens/users/user_data_access/user_data_allowances_screen.dart';
import 'package:zcap_net_app/shared/shared.dart';

class UserDataAccessScreen extends StatefulWidget {
  const UserDataAccessScreen({super.key});

  @override
  State<UserDataAccessScreen> createState() => _UserDataAccessScreenState();
}

class _UserDataAccessScreenState extends State<UserDataAccessScreen> {
  List<UserDataProfilesIsar> userDataProfiles = [];
  StreamSubscription? userDataProfilesStream;

  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  late UserAllowancesProvider allowances;
  late bool canWrite;

  @override
  void initState() {
    super.initState();
    userDataProfilesStream = isarDb.userDataProfilesIsars
        .buildQuery<UserDataProfilesIsar>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        userDataProfiles = data;
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
    userDataProfilesStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    allowances = context.watch<UserAllowancesProvider>();
    canWrite = allowances.canWrite('user_access_settings_users_data');
    final filteredUserDataProfiles = userDataProfiles.where((entity) {
      final name = entity.name.toLowerCase();
      return name.contains(_searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('screen_settings_user_access_data'.tr()),
        actions: [SyncButton()],
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              CustomSearchAndAddBar(
                canWrite: canWrite,
                controller: _searchController,
                onSearchChanged: (value) => setState(() {
                  _searchTerm = value.toLowerCase();
                }),
                onIconPressed: _addOrEditUserDataProfile,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: filteredUserDataProfiles.length,
                        itemBuilder: (context, index) {
                          final userDataProfile =
                              filteredUserDataProfiles[index];
                          return Card(
                            child: ListTile(
                              contentPadding: EdgeInsets.only(
                                left: 10.0,
                              ),
                              title: Text(
                                '${userDataProfile.remoteId != null ? "[${userDataProfile.remoteId}] " : ""}${userDataProfile.name}',
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
                                            value: userDataProfile.startDate
                                                .toLocal()
                                                .toString()
                                                .split(' ')[0]),
                                      ),
                                      Expanded(
                                        child: CustomLabelValueText(
                                          label: 'end'.tr(),
                                          value: userDataProfile.endDate != null
                                              ? userDataProfile.endDate!
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
                                    icon: const Icon(Icons.account_tree),
                                    tooltip: 'tooltip_edit_user_data_allowances'
                                        .tr(),
                                    onPressed: () {
                                      _editUserDataAllowances(userDataProfile);
                                    },
                                  ),
                                  if (!userDataProfile.isSynced)
                                    CustomUnsyncedIcon(),
                                  if (canWrite) ...[
                                    IconButton(
                                      onPressed: () {
                                        _addOrEditUserDataProfile(
                                            userDataProfile: userDataProfile);
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
                                          await isarDb.writeTxn(() async {
/*                                          final allowances = await isarDb
                                              .userDataProfileAllowanceIsars
                                              .filter()
                                              .userDataProfileIdEqualTo(
                                                  userDataProfile.id)
                                              .findAll();

                                          for (final allowance in allowances) {
                                            allowance.markedForDelete = true;
                                          }
                                          await isarDb
                                              .userDataProfileAllowanceIsars
                                              .putAll(allowances);*/
                                            await isarDb.userDataProfilesIsars
                                                .delete(userDataProfile.id);
                                          });
                                        }
                                      },
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                    ),
                                  ] else
                                    IconButton(
                                      icon: const Icon(
                                        Icons.info_outline,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () =>
                                          _addOrEditUserDataProfile(
                                              userDataProfile: userDataProfile),
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

  void _addOrEditUserDataProfile(
      {UserDataProfilesIsar? userDataProfile}) async {
    final nameController =
        TextEditingController(text: userDataProfile?.name ?? "");
    DateTime selectedStartDate = userDataProfile?.startDate ?? DateTime.now();
    DateTime? selectedEndDate = userDataProfile?.endDate;

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text(userDataProfile != null
                  ? '${'edit'.tr()} ${'screen_userDataProfile_type'.tr()}'
                  : '${'new'.tr()} ${'screen_userDataProfile_type'.tr()}'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        enabled: canWrite,
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
                        canWrite: canWrite,
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
                  child: Text(canWrite ? 'cancel'.tr() : 'close'.tr()),
                  onPressed: () => Navigator.pop(context),
                ),
                if (canWrite)
                  TextButton(
                    child: Text('save'.tr()),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final name = nameController.text.trim();

                        final updatedProfile =
                            userDataProfile ?? UserDataProfilesIsar();
                        updatedProfile.name = name;
                        updatedProfile.startDate = selectedStartDate;
                        updatedProfile.endDate = selectedEndDate;
                        updatedProfile.lastUpdatedAt = DateTime.now();
                        updatedProfile.isSynced = false;

                        await isarDb.writeTxn(() async {
                          await isarDb.userDataProfilesIsars
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

  Future<void> _editUserDataAllowances(UserDataProfilesIsar profile) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserDataAllowancesScreen(profile: profile),
      ),
    );
  }
}
