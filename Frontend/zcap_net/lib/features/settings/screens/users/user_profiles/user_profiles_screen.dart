import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';

import 'package:zcap_net_app/shared/shared.dart';

class UserProfilesScreen extends StatefulWidget {
  const UserProfilesScreen({super.key});

  @override
  State<UserProfilesScreen> createState() => _UserProfilesScreenState();
}

class _UserProfilesScreenState extends State<UserProfilesScreen> {
  List<UserProfilesIsar> userProfiles = [];
  StreamSubscription? userProfilesStream;

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
        title: const Text("Perfis de Utilizador"),
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
                              title: 'Aviso',
                              content:
                                  'A funcionalidade não está implementada.',
                            ));
                    _addOrEditUserProfile();
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: userProfiles.length,
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
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.sync_problem,
                                    color: Colors.amberAccent,
                                  ),
                                ),
                              IconButton(
                                onPressed: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) => CustomAlertDialog(
                                            title: 'Aviso',
                                            content:
                                                'A funcionalidade não está implementada',
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
                                      builder: (context) => CustomAlertDialog(
                                            title: 'Aviso',
                                            content:
                                                'A funcionalidade não está implementada.',
                                          ));
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => const ConfirmDialog(
                                      title: 'Confirmar eliminação',
                                      content:
                                          'Tem certeza que deseja eliminar este perfil de utilizador?',
                                    ),
                                  );

                                  if (confirm == true) {
                                    await DatabaseService.db.writeTxn(() async {
                                      await DatabaseService.db.userProfilesIsars
                                          .delete(userProfile.id);
                                    });
                                  }
                                },
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
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

  void _addOrEditUserProfile({UserProfilesIsar? userProfile}) {
    final nameController = TextEditingController(text: userProfile?.name ?? "");
    DateTime selectedStartDate = userProfile?.startDate ?? DateTime.now();
    DateTime? selectedEndDate = userProfile?.endDate;

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return AlertDialog(
                title: Text(userProfile != null
                    ? 'Editar Perfil de Utilizador'
                    : 'Novo Perfil de utilizador'),
                content: Form(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration:
                              InputDecoration(labelText: 'Nome do Perfil'),
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
                      if (nameController.text.isNotEmpty) {
                        final now = DateTime.now();

                        await DatabaseService.db.writeTxn(() async {
                          final editedUserProfile =
                              userProfile ?? UserProfilesIsar();

                          editedUserProfile.name = nameController.text.trim();
                          editedUserProfile.startDate = selectedStartDate;
                          editedUserProfile.endDate = selectedEndDate;
                          editedUserProfile.updatedAt = now;
                          editedUserProfile.isSynced = false;
                          if (userProfile == null) {
                            editedUserProfile.createdAt = now;
                          }

                          await DatabaseService.db.userProfilesIsars
                              .put(editedUserProfile);
                        });

                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              );
            },
          );
        });
  }
}
