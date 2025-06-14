import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/features/settings/models/entity_types/entity_type_isar.dart';

import 'package:zcap_net_app/shared/shared.dart';

class EntityTypesScreen extends StatefulWidget {
  const EntityTypesScreen({super.key});

  @override
  State<EntityTypesScreen> createState() => _EntityTypesScreenState();
}

class _EntityTypesScreenState extends State<EntityTypesScreen> {
  List<EntityTypeIsar> entityTypes = [];
  StreamSubscription? entitieTypesStream;

  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    entitieTypesStream = DatabaseService.db.entityTypeIsars
        .buildQuery<EntityTypeIsar>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        entityTypes = data;
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
    entitieTypesStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredEntityTypes = entityTypes.where((entity) {
      final name = entity.name.toLowerCase();
      return name.contains(_searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tipo de Entidades"),
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
                onAddPressed: _addOrEditEntityType,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: filteredEntityTypes.length,
                        itemBuilder: (context, index) {
                          final entityType = filteredEntityTypes[index];
                          return Card(
                            child: ListTile(
                              contentPadding: EdgeInsets.only(
                                left: 10.0,
                              ),
                              title: Text(
                                '${entityType.remoteId != null ? "[${entityType.remoteId}] " : ""}${entityType.name}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Início: ${entityType.startDate.toLocal().toString().split(' ')[0]}'),
                                  Text(
                                    'Fim: ${entityType.endDate != null ? entityType.endDate!.toLocal().toString().split(' ')[0] : "Sem data"}',
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (!entityType.isSynced)
                                    CustomUnsyncedIcon(),
                                  IconButton(
                                    onPressed: () {
                                      _addOrEditEntityType(
                                          entityType: entityType);
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) =>
                                            const ConfirmDialog(
                                          title: 'Confirmar eliminação',
                                          content:
                                              'Tem certeza que deseja eliminar este tipo de entidade?',
                                        ),
                                      );
                                      if (confirm == true) {
                                        await DatabaseService.db
                                            .writeTxn(() async {
                                          await DatabaseService
                                              .db.entityTypeIsars
                                              .delete(entityType.id);
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

  void _addOrEditEntityType({EntityTypeIsar? entityType}) async {
    final nameController = TextEditingController(text: entityType?.name ?? "");
    DateTime selectedStartDate = entityType?.startDate ?? DateTime.now();
    DateTime? selectedEndDate = entityType?.endDate;

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return AlertDialog(
                title: Text(entityType != null
                    ? 'Editar Tipo de Entidade'
                    : 'Novo Tipo de Entidade'),
                content: Form(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                              labelText: 'Nome do tipo de entidade'),
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
                          final editedEntityType =
                              entityType ?? EntityTypeIsar();

                          editedEntityType.name = nameController.text.trim();
                          editedEntityType.startDate = selectedStartDate;
                          editedEntityType.endDate = selectedEndDate;
                          editedEntityType.updatedAt = now;
                          editedEntityType.isSynced = false;
                          if (entityType == null) {
                            editedEntityType.createdAt = now;
                          }

                          await DatabaseService.db.entityTypeIsars
                              .put(editedEntityType);
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
