import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/users/users_isar.dart';
import 'package:zcap_net_app/features/settings/screens/users/users/user_service.dart';
import 'package:zcap_net_app/shared/security_utils.dart';
import 'package:zcap_net_app/shared/shared.dart';
import 'package:zcap_net_app/widgets/custom_password_confirmation.dart';

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

  @override
  void initState() {
    super.initState();
    usersStream = DatabaseService.db.usersIsars
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
    final filteredUsers = users.where((user) {
      final userName = user.userName.toLowerCase();
      return userName.contains(_searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('users'.tr()),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomSearchAndAddBar(
                    controller: _searchController,
                    onSearchChanged: (value) => setState(() {
                      _searchTerm = value.toLowerCase();
                    }),
                    onAddPressed: _addOrEditUser,
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomLabelValueText(
                                          label: 'name'.tr(), value: user.name),
                                    ),
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
                                IconButton(
                                  onPressed: () {
                                    _addOrEditUser(user: user);
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => ConfirmDialog(
                                        title: 'confirm_delete'.tr(),
                                        content: 'confirm_delete_message'.tr(),
                                      ),
                                    );
                                    if (confirm == true) {
                                      await DatabaseService.db
                                          .writeTxn(() async {
                                        await DatabaseService.db.usersIsars
                                            .delete(user.id);
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
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void _addOrEditUser({UsersIsar? user}) async {
    final availableUserProfiles =
        await DatabaseService.db.userProfilesIsars.where().findAll();

    final userNameController =
        TextEditingController(text: user?.userName ?? "");
    final nameController = TextEditingController(text: user?.name ?? "");
    final passwordController = TextEditingController(text: "");
    final passwordConfirmationController = TextEditingController(text: "");
    UserProfilesIsar? userProfile = user?.userProfile.value;
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
                  child: Text(allowances.canWrite('user_access_settings_users')
                      ? 'cancel'.tr()
                      : 'close'.tr()),
                  onPressed: () => Navigator.pop(context),
                ),
                if (allowances.canWrite('user_access_settings_users'))
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

                        await DatabaseService.db.writeTxn(() async {
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

                          await DatabaseService.db.usersIsars.put(editedUser);
                          await editedUser.userProfile.save();
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
}
