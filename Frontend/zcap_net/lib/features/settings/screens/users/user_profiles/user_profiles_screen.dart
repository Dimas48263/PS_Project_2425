/*
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/acess_type.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_access_keys.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_detail_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';
import 'package:zcap_net_app/features/settings/screens/users/user_profiles/user_access_screen.dart';

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
    final filteredUserProfiles = userProfiles.where((userProfile) {
      final name = userProfile.name.toLowerCase();
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
            child: Column(
              children: [
                CustomSearchAndAddBar(
                  controller: _searchController,
                  onSearchChanged: (value) => setState(() {
                    _searchTerm = value.toLowerCase();
                  }),
                  onAddPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => CustomAlertDialog(
                              title: 'warning'.tr(),
                              content: 'not_implemented'.tr(),
                            ));
                    _addOrEditUserProfile();
                  },
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
                                    Text(
                                        'Início: ${userProfile.startDate.toLocal().toString().split(' ')[0]}'),
                                    Text(
                                      'Fim: ${userProfile.endDate != null ? userProfile.endDate!.toLocal().toString().split(' ')[0] : "Sem data"}',
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (!userProfile.isSynced)
                                      CustomUnsyncedIcon(),
                                    IconButton(
                                      onPressed: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (context) =>
                                                CustomAlertDialog(
                                                  title: 'warning'.tr(),
                                                  content:
                                                      'not_implemented'.tr(),
                                                ));
                                        _addOrEditUserProfile(
                                            userProfile: userProfile);
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (context) =>
                                                CustomAlertDialog(
                                                  title: 'warning'.tr(),
                                                  content:
                                                      'not_implemented'.tr(),
                                                ));
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addOrEditUserProfile({UserProfilesIsar? userProfile}) async {
    final nameController = TextEditingController(text: userProfile?.name ?? "");
    DateTime selectedStartDate = userProfile?.startDate ?? DateTime.now();
    DateTime? selectedEndDate = userProfile?.endDate;
    List<UserProfileDetail> profileDetails = [];

    if (userProfile != null) {
      profileDetails = await DatabaseService.db.userProfileDetails
          .filter()
          .userProfile((q) => q.idEqualTo(userProfile.id))
          .findAll();
    } else {
      // Default "none" for all access
      profileDetails = UserAcccess.values.map((access) {
        final detail = UserProfileDetail()
          ..permissionKey = access
          ..accessType = AccessType.none;
        return detail;
      }).toList();
    }

    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return AlertDialog(
                title: Text(userProfile != null
                    ? '${'edit'.tr()} ${'user_profile'.tr()}'
                    : '${'new'.tr()} ${'user_profile'.tr()}'),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              labelText: 'screen_profiles_profilename'.tr()),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'required_field'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12.0),
                        TextButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('user_access_definitions'.tr()),
                                  content: SizedBox(
                                    height: 400, // ou outro valor adequado
                                    width:
                                        500, // opcional, para evitar overflow horizontal
                                    child: UserAccessEditor(
                                      details: profileDetails,
                                      onChanged: (detail, newType) {
                                        detail.accessType = newType;
                                      },
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('close'.tr()),
                                    ),
                                  ],
                                );
                              },
                            );
                            setModalState(() {});
                          },
                          child: Text('user_access_definitions'.tr()),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
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
                  CancelTextButton(),
                  TextButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate() &&
                          nameController.text.isNotEmpty) {
                        final now = DateTime.now();
                        final navigator = Navigator.of(context);

                        await DatabaseService.db.writeTxn(() async {
                          final editedUserProfile =
                              userProfile ?? UserProfilesIsar();

                          editedUserProfile.name = nameController.text.trim();
                          editedUserProfile.startDate = selectedStartDate;
                          editedUserProfile.endDate = selectedEndDate;
                          editedUserProfile.lastUpdatedAt = now;
                          editedUserProfile.isSynced = false;
                          if (userProfile == null) {
                            editedUserProfile.createdAt = now;
                          }

                          await DatabaseService.db.userProfilesIsars
                              .put(editedUserProfile);

                          if (userProfile != null) {
                            final oldDetails = await DatabaseService
                                .db.userProfileDetails
                                .filter()
                                .userProfile(
                                    (q) => q.idEqualTo(userProfile.id))
                                .findAll();

                            for (final d in oldDetails) {
                              await DatabaseService.db.userProfileDetails
                                  .delete(d.id);
                            }
                          }

                          for (var detail in profileDetails) {
                            detail.userProfile.value = editedUserProfile;
                            await DatabaseService.db.userProfileDetails
                                .put(detail);
                            await detail.userProfile.save();
                          }
                        });

                        navigator.pop();
                      }
                    },
                    child: Text('save'.tr()),
                  ),
                ],
              );
            },
          );
        });
  }
}
*/