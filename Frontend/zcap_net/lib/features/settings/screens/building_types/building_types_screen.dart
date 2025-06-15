import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/features/settings/models/building_types/building_types_isar.dart';
import 'package:zcap_net_app/shared/shared.dart';

class BuildingTypesScreen extends StatefulWidget {
  const BuildingTypesScreen({super.key});

  @override
  State<BuildingTypesScreen> createState() => _BuildingTypesScreenState();
}

class _BuildingTypesScreenState extends State<BuildingTypesScreen> {
  List<BuildingTypesIsar> buildingTypes = [];
  StreamSubscription? buildingTypesStream;

  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    buildingTypesStream = DatabaseService.db.buildingTypesIsars
        .buildQuery<BuildingTypesIsar>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        buildingTypes = data;
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
    buildingTypesStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredBuildingTypes = buildingTypes.where((building) {
      final name = building.name.toLowerCase();
      return name.contains(_searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tipos de Edificio"),
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
                onAddPressed: _addOrEditBuildingType,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: filteredBuildingTypes.length,
                        itemBuilder: (context, index) {
                          final buildingType = filteredBuildingTypes[index];
                          return Card(
                            child: ListTile(
                              contentPadding: EdgeInsets.only(
                                left: 10.0,
                              ),
                              title: Text(
                                '${buildingType.remoteId > 0 ? "[${buildingType.remoteId}] " : " "}${buildingType.name}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Início: ${buildingType.startDate.toLocal().toString().split(' ')[0]}'),
                                  Text(
                                    'Fim: ${buildingType.endDate != null ? buildingType.endDate!.toLocal().toString().split(' ')[0] : "Sem data"}',
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (!buildingType.isSynced)
                                    CustomUnsyncedIcon(),
                                  IconButton(
                                    onPressed: () {
                                      _addOrEditBuildingType(
                                          buildingType: buildingType);
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
                                              'Tem certeza que deseja eliminar este tipo de edificio?',
                                        ),
                                      );
                                      if (confirm == true) {
                                        await DatabaseService.db
                                            .writeTxn(() async {
                                          await DatabaseService
                                              .db.buildingTypesIsars
                                              .delete(buildingType.id);
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

  void _addOrEditBuildingType({BuildingTypesIsar? buildingType}) async {
    final nameController =
        TextEditingController(text: buildingType?.name ?? "");
    DateTime selectedStartDate = buildingType?.startDate ?? DateTime.now();
    DateTime? selectedEndDate = buildingType?.endDate;

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return AlertDialog(
                title: Text(buildingType != null
                    ? 'Editar Tipo de Edificio'
                    : 'Novo Tipo de Edificio'),
                content: Form(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                              labelText: 'Nome do tipo de edificio'),
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
                          final editedBuildingType =
                              buildingType ?? BuildingTypesIsar();

                          editedBuildingType.name = nameController.text.trim();
                          editedBuildingType.startDate = selectedStartDate;
                          editedBuildingType.endDate = selectedEndDate;
                          editedBuildingType.updatedAt = now;
                          editedBuildingType.isSynced = false;
                          if (buildingType == null) {
                            editedBuildingType.createdAt = now;
                          }

                          await DatabaseService.db.buildingTypesIsars
                              .put(editedBuildingType);
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
