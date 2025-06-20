import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/features/settings/models/people/support/support_needed_isar.dart';

import 'package:zcap_net_app/shared/shared.dart';

class SupportNeededScreen extends StatefulWidget {
  const SupportNeededScreen({super.key});

  @override
  State<SupportNeededScreen> createState() => _SupportNeededScreenState();
}

class _SupportNeededScreenState extends State<SupportNeededScreen> {
  List<SupportNeededIsar> supportNeeded = [];
  StreamSubscription? supportNeededStream;

  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    supportNeededStream = DatabaseService.db.supportNeededIsars
        .buildQuery<SupportNeededIsar>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        supportNeeded = data;
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
    supportNeededStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSupportNeeded = supportNeeded.where((supportNeeded) {
      final name = supportNeeded.name.toLowerCase();
      return name.contains(_searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('screen_settings_support_need_types'.tr()),
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
                onAddPressed: _addOrEditSupportNeeded,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: filteredSupportNeeded.length,
                        itemBuilder: (context, index) {
                          final supportNeeded = filteredSupportNeeded[index];
                          return Card(
                            child: ListTile(
                              contentPadding: EdgeInsets.only(
                                left: 10.0,
                              ),
                              title: Text(
                                '${supportNeeded.remoteId != null ? "[${supportNeeded.remoteId}] " : ""}${supportNeeded.name}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${'start'.tr()}: ${supportNeeded.startDate.toLocal().toString().split(' ')[0]}'),
                                  Text(
                                    '${'end'.tr()}: ${supportNeeded.endDate != null ? supportNeeded.endDate!.toLocal().toString().split(' ')[0] : 'no_end_date'.tr()}',
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (!supportNeeded.isSynced)
                                    CustomUnsyncedIcon(),
                                  IconButton(
                                    onPressed: () {
                                      _addOrEditSupportNeeded(
                                          supportNeeded: supportNeeded);
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
                                              .db.supportNeededIsars
                                              .delete(supportNeeded.id);
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

  void _addOrEditSupportNeeded({SupportNeededIsar? supportNeeded}) async {
    final nameController =
        TextEditingController(text: supportNeeded?.name ?? "");
    DateTime selectedStartDate = supportNeeded?.startDate ?? DateTime.now();
    DateTime? selectedEndDate = supportNeeded?.endDate;

    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return AlertDialog(
                title: Text(supportNeeded != null
                    ? '${'edit'.tr()} ${'screen_support_needed_type'.tr()}'
                    : '${'new'.tr()} ${'screen_support_needed_type'.tr()}'),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              labelText: 'screen_support_needed_name'.tr()),
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
                        final navigator = Navigator.of(context);

                        await DatabaseService.db.writeTxn(() async {
                          final editedSupportNeeded =
                              supportNeeded ?? SupportNeededIsar();

                          editedSupportNeeded.name = nameController.text.trim();
                          editedSupportNeeded.startDate = selectedStartDate;
                          editedSupportNeeded.endDate = selectedEndDate;
                          editedSupportNeeded.lastUpdatedAt = now;
                          editedSupportNeeded.isSynced = false;
                          if (supportNeeded == null) {
                            editedSupportNeeded.createdAt = now;
                          }

                          await DatabaseService.db.supportNeededIsars
                              .put(editedSupportNeeded);
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
