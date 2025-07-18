import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/features/settings/models/users/user_data_profiles/user_data_profiles_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/users/users_isar.dart';
import 'package:zcap_net_app/features/settings/screens/users/users/user_service.dart';
import 'package:zcap_net_app/shared/security_utils.dart';
import 'package:zcap_net_app/shared/shared.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<UsersIsar> users = [];
  StreamSubscription? usersStream;

  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  late UserAllowancesProvider allowances;
  late bool canWrite;

  @override
  void initState() {
    super.initState();
    usersStream = isarDb.usersIsars
        .buildQuery<UsersIsar>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        users = data;
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
    usersStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    allowances = context.watch<UserAllowancesProvider>();
    canWrite = allowances.canWrite('user_access_settings_users');
    final filteredUsers = users.where((user) {
      final userName = user.userName.toLowerCase();
      return userName.contains(_searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('users'.tr()),
        actions: [SyncButton()],
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomSearchAndAddBar(
                    canWrite: canWrite,
                    controller: _searchController,
                    onSearchChanged: (value) => setState(() {
                      _searchTerm = value.toLowerCase();
                    }),
                    onIconPressed: _addOrEditUser,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return Card(
                          child: ListTile(
                            contentPadding: EdgeInsets.only(left: 10.0),
                            title: CustomLabelValueText(
                                label: 'username'.tr(), value: user.userName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  CustomLabelValueText(
                                      label: 'name'.tr(), value: user.name),
                                ]),
                                Row(
                                  children: [
                                    Expanded(
                                        child: FutureBuilder(
                                      future: user.userProfile.load(),
                                      builder: (context, snapshot) {
                                        final userProfileName = snapshot
                                                    .connectionState ==
                                                ConnectionState.done
                                            ? user.userProfile.value?.name ??
                                                'unknown_profile'.tr()
                                            : 'loading'.tr();
                                        return CustomLabelValueText(
                                            label: 'profile'.tr(),
                                            value: userProfileName);
                                      },
                                    )),
                                    Expanded(
                                      child: FutureBuilder(
                                        future: user.userDataProfile.load(),
                                        builder: (context, snapshot) {
                                          final userDataProfileName =
                                              snapshot.connectionState ==
                                                      ConnectionState.done
                                                  ? user.userDataProfile.value
                                                          ?.name ??
                                                      'unknown_profile'.tr()
                                                  : 'loading'.tr();
                                          return CustomLabelValueText(
                                              label: 'data_profile'.tr(),
                                              value: userDataProfileName);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomLabelValueText(
                                          label: 'start'.tr(),
                                          value: user.startDate
                                              .toLocal()
                                              .toString()
                                              .split(' ')[0]),
                                    ),
                                    Expanded(
                                      child: CustomLabelValueText(
                                        label: 'end'.tr(),
                                        value: user.endDate != null
                                            ? user.endDate!
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
                                if (!user.isSynced) CustomUnsyncedIcon(),
                                if (canWrite)
                                  IconButton(
                                    onPressed: () {
                                      _addOrEditUser(user: user);
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                if (allowances
                                    .canWrite('user_access_reset_passwords'))
                                  IconButton(
                                    onPressed: () =>
                                        _showResetPasswordDialog(context, user),
                                    icon: const Icon(Icons.lock_reset),
                                    tooltip: 'reset_password'.tr(),
                                  ),
                                if (canWrite)
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
                                          await isarDb.usersIsars
                                              .delete(user.id);
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                  )
                                else
                                  IconButton(
                                    icon: const Icon(
                                      Icons.info_outline,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => _addOrEditUser(user: user),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void _addOrEditUser({UsersIsar? user}) async {
    final availableUserProfiles =
        await isarDb.userProfilesIsars.where().findAll();
    final availableUserDataProfiles =
        await isarDb.userDataProfilesIsars.where().findAll();

    final userNameController =
        TextEditingController(text: user?.userName ?? "");
    final nameController = TextEditingController(text: user?.name ?? "");
    final passwordController = TextEditingController(text: "");
    final passwordConfirmationController = TextEditingController(text: "");
    UserProfilesIsar? userProfile = user?.userProfile.value;
    UserDataProfilesIsar? userDataProfile = user?.userDataProfile.value;
    DateTime selectedStartDate = user?.startDate ?? DateTime.now();
    DateTime? selectedEndDate = user?.endDate;

    final formKey = GlobalKey<FormState>();
    bool passwordsMatch = false;

    showDialog(
      context: context,
      builder: (context) {
        final allowances = context.watch<UserAllowancesProvider>();

        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text(user != null
                  ? '${'edit'.tr()} ${'user'.tr()}'
                  : '${'new'.tr()} ${'user'.tr()}'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        enabled: canWrite,
                        controller: userNameController,
                        decoration: InputDecoration(
                            labelText: 'screen_user_username'.tr()),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'required_field'.tr();
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        enabled: canWrite,
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'name'.tr()),
                      ),
                      const SizedBox(height: 12),
                      if (user == null)
                        CustomPasswordConfirmation(
                          passwordController: passwordController,
                          passwordConfirmationController:
                              passwordConfirmationController,
                          onValidationChanged: (value) {
                            setModalState(
                              () {
                                passwordsMatch = value;
                              },
                            );
                          },
                        ),
                      const SizedBox(height: 12),
                      DropdownSearch<UserProfilesIsar>(
                        enabled: canWrite,
                        selectedItem: userProfile,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              labelText: 'search'.tr(),
                            ),
                          ),
                        ),
                        itemAsString: (UserProfilesIsar? e) => e?.name ?? '',
                        items: availableUserProfiles,
                        onChanged: (UserProfilesIsar? value) {
                          setModalState(() {
                            userProfile = value;
                          });
                        },
                        validator: (UserProfilesIsar? value) {
                          if (value == null) {
                            return 'required_field'.tr();
                          }
                          return null;
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'user_profile'.tr(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownSearch<UserDataProfilesIsar>(
                        enabled: canWrite,
                        selectedItem: userDataProfile,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              labelText: 'search'.tr(),
                            ),
                          ),
                        ),
                        itemAsString: (UserDataProfilesIsar? e) =>
                            e?.name ?? '',
                        items: availableUserDataProfiles,
                        onChanged: (UserDataProfilesIsar? value) {
                          setModalState(() {
                            userDataProfile = value;
                          });
                        },
                        validator: (UserDataProfilesIsar? value) {
                          if (value == null) {
                            return 'required_field'.tr();
                          }
                          return null;
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'user_data_profile'.tr(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
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
                    onPressed: () async {
                      final isUniqueUserName =
                          await UserService.validateUniqueUserName(
                        userName: userNameController.text,
                        context: context,
                        ownUserId: user?.id,
                      );
                      if (!isUniqueUserName) return;

                      if (formKey.currentState!.validate() &&
                          userNameController.text.isNotEmpty &&
                          (user != null || passwordsMatch)) {
                        final now = DateTime.now();

                        await isarDb.writeTxn(() async {
                          final editedUser = user ?? UsersIsar();

                          editedUser.userName =
                              userNameController.text.trim().toLowerCase();
                          editedUser.name = nameController.text.trim();
                          editedUser.startDate = selectedStartDate;
                          editedUser.endDate = selectedEndDate;
                          editedUser.lastUpdatedAt = now;
                          editedUser.isSynced = false;
                          if (user == null) {
                            editedUser.password =
                                hashPassword(passwordController.text.trim());
                            editedUser.createdAt = now;
                          }

                          editedUser.userProfile.value = userProfile;
                          editedUser.userDataProfile.value = userDataProfile;

                          await isarDb.usersIsars.put(editedUser);
                          await editedUser.userProfile.save();
                          await editedUser.userDataProfile.save();
                        });

                        Navigator.pop(context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              title: 'invalid_data'.tr(),
                              content: 'save_error'.tr(),
                            );
                          },
                        );
                      }
                    },
                    child: Text('save'.tr()),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void _showResetPasswordDialog(BuildContext context, UsersIsar user) {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool passwordsMatch = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('reset_password'.tr()),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomPasswordConfirmation(
                      passwordController: passwordController,
                      passwordConfirmationController: confirmPasswordController,
                      onValidationChanged: (valid) {
                        setState(() {
                          passwordsMatch = valid;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('cancel'.tr()),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text('save'.tr()),
                  onPressed: () async {
                    if (!formKey.currentState!.validate() || !passwordsMatch) {
                      return;
                    }

                    await isarDb.writeTxn(() async {
                      user.password =
                          hashPassword(passwordController.text.trim());
                      user.lastUpdatedAt = DateTime.now();
                      user.isSynced = false;
                      await isarDb.usersIsars.put(user);
                    });

                    Navigator.pop(context);

                    showDialog(
                      context: context,
                      builder: (_) => CustomAlertDialog(
                        title: 'success'.tr(),
                        content: 'password_changed'.tr(),
                      ),
                    );
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
