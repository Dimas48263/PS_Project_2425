import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcaps/zcap_isar.dart';
import 'package:zcap_net_app/shared/shared.dart';
import 'package:zcap_net_app/widgets/status_bar.dart';

class ZcapsScreen extends StatefulWidget {
  final String? userName;
  const ZcapsScreen({super.key, required this.userName});

  @override
  State<ZcapsScreen> createState() => _ZcapsScreenState();
}

class _ZcapsScreenState extends State<ZcapsScreen> {
  List<ZcapIsar> zcaps = [];
  StreamSubscription? zcapsStream;

  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    zcapsStream = DatabaseService.db.zcapIsars
        .buildQuery<ZcapIsar>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        zcaps = data;
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
    zcapsStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredZcaps = zcaps.where((zcap) {
      final name = zcap.name.toLowerCase();
      return name.contains(_searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('screen_zcaps'.tr()),
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: Center(
            child: SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  CustomSearchAndAddBar(
                    controller: _searchController,
                    onSearchChanged: (value) => setState(() {
                      _searchTerm = value.toLowerCase();
                    }),
                    onAddPressed: _addOrEditZcap,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: filteredZcaps.length,
                            itemBuilder: (context, index) {
                              final zcap = filteredZcaps[index];
                              return Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(
                                    left: 10.0,
                                  ),
                                  title: Text(
                                    '${zcap.remoteId > 0 ? "[${zcap.remoteId}] " : " "}${zcap.name}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${'start'.tr()}: ${zcap.startDate.toLocal().toString().split(' ')[0]}'),
                                      Text(
                                        '${'end'.tr()}: ${zcap.endDate != null ? zcap.endDate!.toLocal().toString().split(' ')[0] : 'no_end_date'.tr()}',
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (!zcap.isSynced) CustomUnsyncedIcon(),
                                      IconButton(
                                        onPressed: () {
                                          _addOrEditZcap(zcap: zcap);
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          final confirm =
                                              await showDialog<bool>(
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
                                              await DatabaseService.db.zcapIsars
                                                  .delete(zcap.id);
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
          )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: StatusBar(userName: widget.userName),
          ),
        ],
      ),
    );
  }

  void _addOrEditZcap({ZcapIsar? zcap}) async {
    final nameController = TextEditingController(text: zcap?.name ?? "");
    DateTime selectedStartDate = zcap?.startDate ?? DateTime.now();
    DateTime? selectedEndDate = zcap?.endDate;

    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return AlertDialog(
                title: Text(zcap != null
                    ? '${'edit'.tr()} ${'screen_zcap'.tr()}'
                    : '${'new'.tr()} ${'screen_zcap'.tr()}'),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              labelText: 'screen_zcap_name'.tr()),
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
                          final editedZcap = zcap ?? ZcapIsar();

                          editedZcap.name = nameController.text.trim();
                          editedZcap.startDate = selectedStartDate;
                          editedZcap.endDate = selectedEndDate;
                          editedZcap.lastUpdatedAt = now;
                          editedZcap.isSynced = false;
                          if (zcap == null) {
                            editedZcap.createdAt = now;
                          }

                          await DatabaseService.db.zcapIsars.put(editedZcap);
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
