import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_types/incident_types_isar.dart';

import 'package:zcap_net_app/shared/shared.dart';

class IncidentTypesScreen extends StatefulWidget {
  const IncidentTypesScreen({super.key});

  @override
  State<IncidentTypesScreen> createState() => _IncidentTypesScreenState();
}

class _IncidentTypesScreenState extends State<IncidentTypesScreen> {
  List<IncidentTypesIsar> incidentTypes = [];
  StreamSubscription? incidentTypesStream;

  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    incidentTypesStream = DatabaseService.db.incidentTypesIsars
        .buildQuery<IncidentTypesIsar>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        incidentTypes = data;
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
    incidentTypesStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredIncidentTypes = incidentTypes.where((entity) {
      final name = entity.name.toLowerCase();
      return name.contains(_searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('screen_settings_incident_types'.tr()),
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
                onAddPressed: _addOrEditIncidentType,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: filteredIncidentTypes.length,
                        itemBuilder: (context, index) {
                          final incidentType = filteredIncidentTypes[index];
                          return Card(
                            child: ListTile(
                              contentPadding: EdgeInsets.only(
                                left: 10.0,
                              ),
                              title: Text(
                                '${incidentType.remoteId != null ? "[${incidentType.remoteId}] " : ""}${incidentType.name}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomLabelValueText(
                                            label: 'start'.tr(),
                                            value: incidentType.startDate
                                                .toLocal()
                                                .toString()
                                                .split(' ')[0]),
                                      ),
                                      Expanded(
                                        child: CustomLabelValueText(
                                          label: 'end'.tr(),
                                          value: incidentType.endDate != null
                                              ? incidentType.endDate!
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
                                  if (!incidentType.isSynced)
                                    CustomUnsyncedIcon(),
                                  IconButton(
                                    onPressed: () {
                                      _addOrEditIncidentType(
                                          incidentType: incidentType);
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
                                              .db.incidentTypesIsars
                                              .delete(incidentType.id);
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

  void _addOrEditIncidentType({IncidentTypesIsar? incidentType}) async {
    final nameController =
        TextEditingController(text: incidentType?.name ?? "");
    DateTime selectedStartDate = incidentType?.startDate ?? DateTime.now();
    DateTime? selectedEndDate = incidentType?.endDate;
    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          final allowances = context.watch<UserAllowancesProvider>();

          return StatefulBuilder(
            builder: (context, setModalState) {
              return AlertDialog(
                title: Text(incidentType != null
                    ? '${'edit'.tr()} ${'screen_incident_type'.tr()}'
                    : '${'new'.tr()} ${'screen_incident_type'.tr()}'),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              labelText: 'screen_entity_type_name'.tr()),
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
                  TextButton(
                    child: Text(allowances
                            .canWrite('user_access_settings_incident_types')
                        ? 'cancel'.tr()
                        : 'close'.tr()),
                    onPressed: () => Navigator.pop(context),
                  ),
                  if (allowances
                      .canWrite('user_access_settings_incident_types'))
                    TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate() &&
                            nameController.text.isNotEmpty) {
                          final now = DateTime.now();
                          final navigator = Navigator.of(context);

                          await DatabaseService.db.writeTxn(() async {
                            final editedIncidentType =
                                incidentType ?? IncidentTypesIsar();

                            editedIncidentType.name =
                                nameController.text.trim();
                            editedIncidentType.startDate = selectedStartDate;
                            editedIncidentType.endDate = selectedEndDate;
                            editedIncidentType.lastUpdatedAt = now;
                            editedIncidentType.isSynced = false;
                            if (incidentType == null) {
                              editedIncidentType.createdAt = now;
                            }

                            await DatabaseService.db.incidentTypesIsars
                                .put(editedIncidentType);
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
