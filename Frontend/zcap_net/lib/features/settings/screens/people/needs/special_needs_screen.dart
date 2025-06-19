import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/features/settings/models/people/special_needs/special_needs_isar.dart';

import 'package:zcap_net_app/shared/shared.dart';

class SpecialNeedsScreen extends StatefulWidget {
  const SpecialNeedsScreen({super.key});

  @override
  State<SpecialNeedsScreen> createState() => _SpecialNeedsScreenState();
}

class _SpecialNeedsScreenState extends State<SpecialNeedsScreen> {
  List<SpecialNeedIsar> specialNeeds = [];
  StreamSubscription? specialNeedsStream;

  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    specialNeedsStream = DatabaseService.db.specialNeedIsars
        .buildQuery<SpecialNeedIsar>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        specialNeeds = data;
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
    specialNeedsStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSpecialNeeds = specialNeeds.where((specialNeed) {
      final name = specialNeed.name.toLowerCase();
      return name.contains(_searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('screen_settings_special_need_types'.tr()),
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
                onAddPressed: _addOrEditSpecialNeed,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: filteredSpecialNeeds.length,
                        itemBuilder: (context, index) {
                          final specialNeed = filteredSpecialNeeds[index];
                          return Card(
                            child: ListTile(
                              contentPadding: EdgeInsets.only(
                                left: 10.0,
                              ),
                              title: Text(
                                '${specialNeed.remoteId != null ? "[${specialNeed.remoteId}] " : ""}${specialNeed.name}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${'start'.tr()}: ${specialNeed.startDate.toLocal().toString().split(' ')[0]}'),
                                  Text(
                                    '${'end'.tr()}: ${specialNeed.endDate != null ? specialNeed.endDate!.toLocal().toString().split(' ')[0] : 'no_end_date'.tr()}',
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (!specialNeed.isSynced)
                                    CustomUnsyncedIcon(),
                                  IconButton(
                                    onPressed: () {
                                      _addOrEditSpecialNeed(
                                          specialNeed: specialNeed);
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
                                              .db.specialNeedIsars
                                              .delete(specialNeed.id);
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

  void _addOrEditSpecialNeed({SpecialNeedIsar? specialNeed}) async {
    final nameController = TextEditingController(text: specialNeed?.name ?? "");
    DateTime selectedStartDate = specialNeed?.startDate ?? DateTime.now();
    DateTime? selectedEndDate = specialNeed?.endDate;

    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return AlertDialog(
                title: Text(specialNeed != null
                    ? '${'edit'.tr()} ${'screen_special_need_type'.tr()}'
                    : '${'new'.tr()} ${'screen_special_need_type'.tr()}'),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              labelText: 'screen_special_need_name'.tr()),
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
                          final editedSpecialNeed =
                              specialNeed ?? SpecialNeedIsar();

                          editedSpecialNeed.name = nameController.text.trim();
                          editedSpecialNeed.startDate = selectedStartDate;
                          editedSpecialNeed.endDate = selectedEndDate;
                          editedSpecialNeed.lastUpdatedAt = now;
                          editedSpecialNeed.isSynced = false;
                          if (specialNeed == null) {
                            editedSpecialNeed.createdAt = now;
                          }

                          await DatabaseService.db.specialNeedIsars
                              .put(editedSpecialNeed);
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
