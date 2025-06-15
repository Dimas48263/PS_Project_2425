import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
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
        title: const Text("Utilizadores"),
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
                            title: Text(
                              '${user.remoteId != null ? "[${user.remoteId}] " : ""}${user.userName}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.name),
                                FutureBuilder(
                                  future: user.userProfile.load(),
                                  builder: (context, snapshot) {
                                    final userProfileName =
                                        snapshot.connectionState ==
                                                ConnectionState.done
                                            ? user.userProfile.value?.name ??
                                                'Perfil desconhecido'
                                            : 'Carregando perfil...';
                                    return Text('Perfil: $userProfileName');
                                  },
                                ),
                                Text(
                                    'Início: ${user.startDate.toLocal().toString().split(' ')[0]}'),
                                Text(
                                  'Fim: ${user.endDate != null ? user.endDate!.toLocal().toString().split(' ')[0] : "Sem data"}',
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (!user.isSynced)
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.sync_problem,
                                      color: Colors.amberAccent,
                                    ),
                                  ),
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
                                      builder: (context) => const ConfirmDialog(
                                        title: 'Confirmar eliminação',
                                        content:
                                            'Tem certeza que deseja eliminar este utilizador?',
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
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title:
                  Text(user != null ? 'Editar Utilizador' : 'Novo Utilizador'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: userNameController,
                        decoration: const InputDecoration(
                            labelText: 'Nome de utilizador'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Nome'),
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
                              labelText: 'Pesquisar Perfil de utilizador',
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
                            return 'Por favor, selecione o perfil de utilizador';
                          }
                          return null;
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Perfil de Utilizador',
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
                CancelTextButton(),
                TextButton(
                  onPressed: () async {
                    //already treated at CustomDateRangePicker
/*                    final hasValidDates = DateUtilsService.validateStartEndDate(
                      startDate: selectedStartDate,
                      endDate: selectedEndDate,
                      context: context,
                    );
                    if (!hasValidDates) return;*/

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
                        editedUser.updatedAt = now;
                        editedUser.isSynced = false;
                        if (user == null) {
                          editedUser.password =
                              encryptPassword(passwordController.text.trim());
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
                            title: 'Dados inválidos',
                            content: 'Não é possível gravar',
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
