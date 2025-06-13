import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities_isar.dart';
import 'package:zcap_net_app/features/settings/models/entity_types/entity_type_isar.dart';
import 'package:zcap_net_app/shared/shared.dart';
import 'package:zcap_net_app/widgets/custom_unsynced_icon.dart';

class EntitiesScreen extends StatefulWidget {
  const EntitiesScreen({super.key});

  @override
  State<EntitiesScreen> createState() => _EntitiesScreenState();
}

class _EntitiesScreenState extends State<EntitiesScreen> {
  List<EntitiesIsar> entities = [];
  StreamSubscription? entitiesStream;

  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    entitiesStream = DatabaseService.db.entitiesIsars
        .buildQuery<EntitiesIsar>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        entities = data;
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
    entitiesStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredEntities = entities.where((entity) {
      final name = entity.name.toLowerCase();
      return name.contains(_searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Entidades"),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Shared Custom Search and Add Bar
                  CustomSearchAndAddBar(
                    controller: _searchController,
                    onSearchChanged: (value) => setState(() {
                      _searchTerm = value.toLowerCase();
                    }),
                    onAddPressed: _addOrEditEntity,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: filteredEntities.length,
                            itemBuilder: (context, index) {
                              final entity = filteredEntities[index];
                              return Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(left: 10.0),
                                  title: Text(
                                    '${entity.remoteId != null ? "[${entity.remoteId}] " : ""}${entity.name}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder(
                                        future: entity.entityType.load(),
                                        builder: (context, snapshot) {
                                          final entityTypeName = snapshot
                                                      .connectionState ==
                                                  ConnectionState.done
                                              ? entity.entityType.value?.name ??
                                                  'Tipo desconhecido'
                                              : 'Carregando tipo...';
                                          return Text('Tipo: $entityTypeName');
                                        },
                                      ),
                                      Text('Email: ${entity.email}'),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                                  'Contacto: ${entity.phone1}')),
                                          Expanded(
                                              child: Text(
                                                  'Contacto alternativo: ${entity.phone2}')),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                                'Início: ${entity.startDate.toLocal().toString().split(' ')[0]}'),
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Fim: ${entity.endDate != null ? entity.endDate!.toLocal().toString().split(' ')[0] : "Sem data"}',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (!entity.isSynced)
                                        CustomUnsyncedIcon(),
                                      IconButton(
                                        onPressed: () {
                                          _addOrEditEntity(entity: entity);
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          final confirm =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (context) =>
                                                const ConfirmDialog(
                                              title: 'Confirmar eliminação',
                                              content:
                                                  'Tem certeza que deseja eliminar esta entidade?',
                                            ),
                                          );
                                          if (confirm == true) {
                                            await DatabaseService.db
                                                .writeTxn(() async {
                                              await DatabaseService
                                                  .db.entitiesIsars
                                                  .delete(entity.id);
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

  void _addOrEditEntity({EntitiesIsar? entity}) async {
    final availableEntityTypes =
        await DatabaseService.db.entityTypeIsars.where().findAll();

    final nameController = TextEditingController(text: entity?.name ?? "");
    final emailController = TextEditingController(text: entity?.email ?? "");
    final phone1Controller = TextEditingController(text: entity?.phone1 ?? "");
    final phone2Controller = TextEditingController(text: entity?.phone2 ?? "");
    EntityTypeIsar? entityType = entity?.entityType.value;
    DateTime selectedStartDate = entity?.startDate ?? DateTime.now();
    DateTime? selectedEndDate = entity?.endDate;

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text(entity != null ? 'Editar Entidade' : 'Nova Entidade'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            labelText: 'Nome da entidade'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nome inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownSearch<EntityTypeIsar>(
                        selectedItem: entityType,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              labelText: 'Pesquisar tipo de entidade',
                            ),
                          ),
                        ),
                        itemAsString: (EntityTypeIsar? e) => e?.name ?? '',
                        items: availableEntityTypes,
                        onChanged: (EntityTypeIsar? value) {
                          setModalState(() {
                            entityType = value;
                          });
                        },
                        validator: (EntityTypeIsar? value) {
                          if (value == null) {
                            return 'Seleção obrigatória';
                          }
                          return null;
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Tipo de entidade',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            final emailRegex =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value.trim())) {
                              return 'Email inválido';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: phone1Controller,
                        decoration: const InputDecoration(
                            labelText: 'Contacto principal'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'O contacto principal é obrigatório';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: phone2Controller,
                        decoration: const InputDecoration(
                            labelText: 'Contacto secundário'),
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
                    if (formKey.currentState!.validate() &&
                        nameController.text.isNotEmpty) {
                      final now = DateTime.now();

                      await DatabaseService.db.writeTxn(() async {
                        final editedEntity = entity ?? EntitiesIsar();

                        editedEntity.name = nameController.text.trim();
                        editedEntity.email = emailController.text.trim();
                        editedEntity.phone1 = phone1Controller.text.trim();
                        editedEntity.phone2 = phone2Controller.text.trim();
                        editedEntity.startDate = selectedStartDate;
                        editedEntity.endDate = selectedEndDate;
                        editedEntity.updatedAt = now;
                        editedEntity.isSynced = false;
                        if (entity == null) {
                          editedEntity.createdAt = now;
                        }

                        editedEntity.entityType.value = entityType;

                        await DatabaseService.db.entitiesIsars
                            .put(editedEntity);
                        await editedEntity.entityType.save();
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
      },
    );
  }
}
