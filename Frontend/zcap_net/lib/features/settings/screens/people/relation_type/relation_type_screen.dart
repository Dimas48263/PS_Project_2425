import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/features/settings/models/people/relation_type/relation_type_isar.dart';

import 'package:zcap_net_app/shared/shared.dart';

class RelationTypeScreen extends StatefulWidget {
  const RelationTypeScreen({super.key});

  @override
  State<RelationTypeScreen> createState() => _RelationTypesScreenState();
}

class _RelationTypesScreenState extends State<RelationTypeScreen> {
  List<RelationTypeIsar> relationTypes = [];
  StreamSubscription? relationTypesStream;

  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    relationTypesStream = DatabaseService.db.relationTypeIsars
        .buildQuery<RelationTypeIsar>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        relationTypes = data;
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
    relationTypesStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredRelationTypes = relationTypes.where((relation) {
      final name = relation.name.toLowerCase();
      return name.contains(_searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('screen_settings_relation_types'.tr()),
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
                onAddPressed: _addOrEditRelationType,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: filteredRelationTypes.length,
                        itemBuilder: (context, index) {
                          final relationType = filteredRelationTypes[index];
                          return Card(
                            child: ListTile(
                              contentPadding: EdgeInsets.only(
                                left: 10.0,
                              ),
                              title: Text(
                                '${relationType.remoteId != null ? "[${relationType.remoteId}] " : ""}${relationType.name}',
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
                                            value: relationType.startDate
                                                .toLocal()
                                                .toString()
                                                .split(' ')[0]),
                                      ),
                                      Expanded(
                                        child: CustomLabelValueText(
                                          label: 'end'.tr(),
                                          value: relationType.endDate != null
                                              ? relationType.endDate!
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
                                  if (!relationType.isSynced)
                                    CustomUnsyncedIcon(),
                                  IconButton(
                                    onPressed: () {
                                      _addOrEditRelationType(
                                          relationType: relationType);
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
                                              .db.relationTypeIsars
                                              .delete(relationType.id);
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

  void _addOrEditRelationType({RelationTypeIsar? relationType}) async {
    final nameController =
        TextEditingController(text: relationType?.name ?? "");
    DateTime selectedStartDate = relationType?.startDate ?? DateTime.now();
    DateTime? selectedEndDate = relationType?.endDate;

    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              final allowances = context.watch<UserAllowancesProvider>();

              return AlertDialog(
                title: Text(relationType != null
                    ? '${'edit'.tr()} ${'screen_relation_type'.tr()}'
                    : '${'new'.tr()} ${'screen_relation_type'.tr()}'),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              labelText: 'screen_relation_types_name'.tr()),
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
                    child: Text(allowances.canWrite(
                            'user_access_settings_people_relation_types')
                        ? 'cancel'.tr()
                        : 'close'.tr()),
                    onPressed: () => Navigator.pop(context),
                  ),
                  if (allowances
                      .canWrite('user_access_settings_people_relation_types'))
                    TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate() &&
                            nameController.text.isNotEmpty) {
                          final now = DateTime.now();
                          final navigator = Navigator.of(context);

                          await DatabaseService.db.writeTxn(() async {
                            final editedRelationType =
                                relationType ?? RelationTypeIsar();

                            editedRelationType.name =
                                nameController.text.trim();
                            editedRelationType.startDate = selectedStartDate;
                            editedRelationType.endDate = selectedEndDate;
                            editedRelationType.lastUpdatedAt = now;
                            editedRelationType.isSynced = false;
                            if (relationType == null) {
                              editedRelationType.createdAt = now;
                            }

                            await DatabaseService.db.relationTypeIsars
                                .put(editedRelationType);
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
