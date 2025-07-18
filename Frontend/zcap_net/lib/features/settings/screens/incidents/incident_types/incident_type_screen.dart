import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_types/incident_types_isar.dart';

import 'package:zcap_net_app/shared/shared.dart';
import 'package:zcap_net_app/widgets/text_controllers_input_form.dart';

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

  late UserAllowancesProvider allowances;
  late bool canWrite;

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
    allowances = context.watch<UserAllowancesProvider>();
    canWrite = allowances.canWrite('user_access_settings_incident_types');

    final filteredIncidentTypes = incidentTypes.where((entity) {
      final name = entity.name.toLowerCase();
      return name.contains(_searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('screen_settings_incident_types'.tr()),
        actions: [SyncButton()],
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              CustomSearchAndAddBar(
                canWrite: canWrite,
                controller: _searchController,
                onSearchChanged: (value) => setState(() {
                  _searchTerm = value.toLowerCase();
                }),
                onIconPressed: _addOrEditIncidentType,
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : buildListView(
                      filteredIncidentTypes,
                      getLabelsList(filteredIncidentTypes),
                      () async => await syncService.synchronizeAll(),
                      (incidentType) =>
                          _addOrEditIncidentType(incidentType: incidentType),
                      (incidentType) async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => ConfirmDialog(
                            title: 'confirm_delete'.tr(),
                            content: 'confirm_delete_message'.tr(),
                          ),
                        );
                        if (confirm == true) {
                          await DatabaseService.db.writeTxn(() async {
                            await DatabaseService.db.incidentTypesIsars
                                .delete(incidentType.id);
                          });
                        }
                      },
                      canWrite: canWrite,
                    )
            ]),
          ),
        ),
      ),
    );
  }

  List<List<String>> getLabelsList(List<IncidentTypesIsar> filteredList) {
    List<List<String>> labelsList = [];
    for (var incidentType in filteredList) {
      labelsList.add([
        '${incidentType.remoteId != null ? "[${incidentType.remoteId}] " : ""}${incidentType.name}',
        '${'start'.tr()}: ${incidentType.startDate.toLocal().toString().split(' ')[0]}',
        '${'end'.tr()}: ${incidentType.endDate?.toLocal().toString().split(' ')[0] ?? 'no_end_date'.tr()}'
      ]);
    }
    return labelsList;
  }

  void _addOrEditIncidentType({IncidentTypesIsar? incidentType}) async {
    final nameController =
        TextEditingController(text: incidentType?.name ?? "");
    DateTime selectedStartDate = incidentType?.startDate ?? DateTime.now();
    DateTime? selectedEndDate = incidentType?.endDate;
    final formKey = GlobalKey<FormState>();

    List<TextControllersInputFormConfig> textControllersConfig = [
      TextControllersInputFormConfig(
          controller: nameController, label: 'screen_entity_type_name'.tr())
    ];

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return AlertDialog(
                title: Text(incidentType != null
                    ? '${'edit'.tr()} ${'screen_incident_type'.tr()}'
                    : '${'new'.tr()} ${'screen_incident_type'.tr()}'),
                content: buildForm(formKey, context, textControllersConfig,
                    selectedStartDate, selectedEndDate, (value) {
                  setState(() => selectedStartDate = value);
                  setModalState(() {}); // Atualiza o dialog
                }, (value) {
                  setState(() => selectedEndDate = value);
                  setModalState(() {}); // Atualiza o dialog
                }, () {
                  setModalState(() {
                    selectedEndDate = null;
                  });
                }, [], canWrite: canWrite),
                actions: [
                  TextButton(
                    child: Text(canWrite ? 'cancel'.tr() : 'close'.tr()),
                    onPressed: () => Navigator.pop(context),
                  ),
                  if (canWrite)
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
