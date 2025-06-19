import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
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
        title: Text('screen_settings_building_types'.tr()),
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
                                      '${'start'.tr()}: ${buildingType.startDate.toLocal().toString().split(' ')[0]}'),
                                  Text(
                                    '${'end'.tr()}: ${buildingType.endDate != null ? buildingType.endDate!.toLocal().toString().split(' ')[0] : 'no_end_date'.tr()}',
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

    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return AlertDialog(
                title: Text(buildingType != null
                    ? '${'edit'.tr()} ${'screen_building_type'.tr()}'
                    : '${'new'.tr()} ${'screen_building_type'.tr()}'),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              labelText: 'screen_building_type_name'.tr()),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'required_field'.tr();
                            }
                            return null;
                          },
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

                        await DatabaseService.db.writeTxn(() async {
                          final editedBuildingType =
                              buildingType ?? BuildingTypesIsar();

                          editedBuildingType.name = nameController.text.trim();
                          editedBuildingType.startDate = selectedStartDate;
                          editedBuildingType.endDate = selectedEndDate;
                          editedBuildingType.lastUpdatedAt = now;
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
                    child: Text('save'.tr()),
                  ),
                ],
              );
            },
          );
        });
  }
}
