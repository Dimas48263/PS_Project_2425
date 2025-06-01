import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities_isar.dart';
import 'package:zcap_net_app/features/settings/models/entity_types/entity_type_isar.dart';
import 'package:zcap_net_app/shared/shared.dart';

class EntitiesScreen extends StatefulWidget {
  const EntitiesScreen({super.key});

  @override
  State<EntitiesScreen> createState() => _EntitiesScreenState();
}

class _EntitiesScreenState extends State<EntitiesScreen> {
  List<EntitiesIsar> entities = [];
  StreamSubscription? entitiesStream;

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
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Pesquisar',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredEntities.length,
                      itemBuilder: (context, index) {
                        final entity = filteredEntities[index];
                        return Card(
                          child: ListTile(
                            contentPadding: EdgeInsets.only(left: 10.0),
                            title: Text(
                              '${entity.remoteId != null ? "[${entity.remoteId}] " : ""}${entity.name}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder(
                                  future: entity.entityType.load(),
                                  builder: (context, snapshot) {
                                    final entityTypeName =
                                        snapshot.connectionState ==
                                                ConnectionState.done
                                            ? entity.entityType.value?.name ??
                                                'Tipo desconhecido'
                                            : 'Carregando tipo...';
                                    return Text('Tipo: $entityTypeName');
                                  },
                                ),
                                Text(
                                    'Início: ${entity.startDate.toLocal().toString().split(' ')[0]}'),
                                Text(
                                  'Fim: ${entity.endDate != null ? entity.endDate!.toLocal().toString().split(' ')[0] : "Sem data"}',
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (!entity.isSynced)
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.sync_problem,
                                      color: Colors.amberAccent,
                                    ),
                                  ),
                                IconButton(
                                  onPressed: () {
                                    _addOrEditEntity(entity: entity);
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
                                            'Tem certeza que deseja eliminar esta entidade?',
                                      ),
                                    );
                                    if (confirm == true) {
                                      await DatabaseService.db
                                          .writeTxn(() async {
                                        await DatabaseService.db.entitiesIsars
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addOrEditEntity,
        child: Icon(Icons.add),
      ),
    );
  }

  void _addOrEditEntity({EntitiesIsar? entity}) async {
    final availableEntityTypes =
        await DatabaseService.db.entityTypeIsars.where().findAll();

    final nameController = TextEditingController(text: entity?.name ?? "");
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
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            labelText: 'Nome da entidade'),
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
                            return 'Por favor, selecione o tipo de entidade';
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
                      ListTile(
                        title: Text(
                            "Início: ${selectedStartDate.toLocal().toString().split(' ')[0]}"),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedStartDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setModalState(() {
                              selectedStartDate = picked;
                            });
                          }
                        },
                      ),
                      ListTile(
                        title: Text(
                            "Fim: ${selectedEndDate != null ? selectedEndDate!.toLocal().toString().split(' ')[0] : 'Sem data'}"),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedEndDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setModalState(() {
                              selectedEndDate = picked;
                            });
                          }
                        },
                        onLongPress: () {
                          setModalState(() {
                            selectedEndDate = null;
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
