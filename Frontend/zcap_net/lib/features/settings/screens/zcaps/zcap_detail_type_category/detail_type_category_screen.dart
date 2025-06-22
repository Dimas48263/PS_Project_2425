import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_detail_type_category/detail_type_category_isar.dart';
import 'package:zcap_net_app/shared/shared.dart';

class DetailTypeCategoryScreen extends StatefulWidget {
  const DetailTypeCategoryScreen({super.key});

  @override
  State<DetailTypeCategoryScreen> createState() =>
      _DetailTypeCategoryScreenState();
}

class _DetailTypeCategoryScreenState extends State<DetailTypeCategoryScreen> {
  List<DetailTypeCategoryIsar> detailCategories = [];
  StreamSubscription? detailCategoriesStream;

  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    detailCategoriesStream = DatabaseService.db.detailTypeCategoryIsars
        .buildQuery<DetailTypeCategoryIsar>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        detailCategories = data;
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
    detailCategoriesStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = detailCategories.where((category) {
      final name = category.name.toLowerCase();
      return name.contains(_searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('screen_settings_detail_category'.tr()),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Shared Custom Search and Add Bar
                  CustomSearchAndAddBar(
                    controller: _searchController,
                    onSearchChanged: (value) => setState(() {
                      _searchTerm = value.toLowerCase();
                    }),
                    onAddPressed: _addOrEditDetailCategory,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: filteredCategories.length,
                            itemBuilder: (context, index) {
                              final category = filteredCategories[index];
                              return Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(left: 10.0),
                                  title: Text(
                                    '${category.remoteId != null ? "[${category.remoteId}] " : ""}${category.name}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                                '${'start'.tr()}: ${category.startDate.toLocal().toString().split(' ')[0]}'),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${'end'.tr()}: ${category.endDate != null ? category.endDate!.toLocal().toString().split(' ')[0] : 'no_end_date'.tr()}',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (!category.isSynced)
                                        CustomUnsyncedIcon(),
                                      IconButton(
                                        onPressed: () {
                                          _addOrEditDetailCategory(
                                              category: category);
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
                                              await DatabaseService
                                                  .db.detailTypeCategoryIsars
                                                  .delete(category.id);
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
    );
  }

  void _addOrEditDetailCategory({DetailTypeCategoryIsar? category}) async {
    final nameController = TextEditingController(text: category?.name ?? "");
    DateTime selectedStartDate = category?.startDate ?? DateTime.now();
    DateTime? selectedEndDate = category?.endDate;

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text(category != null
                  ? '${'edit'.tr()} ${'screen_settings_detail_category_name'.tr()}'
                  : '${'new'.tr()} ${'screen_settings_detail_category_name'.tr()}'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            labelText:
                                'screen_settings_detail_category_name'.tr()),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'required_field'.tr();
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
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
                        final editedCategory =
                            category ?? DetailTypeCategoryIsar();

                        editedCategory.name = nameController.text.trim();
                        editedCategory.startDate = selectedStartDate;
                        editedCategory.endDate = selectedEndDate;
                        editedCategory.lastUpdatedAt = now;
                        editedCategory.isSynced = false;
                        if (category == null) {
                          editedCategory.createdAt = now;
                        }

                        await DatabaseService.db.detailTypeCategoryIsars
                            .put(editedCategory);
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
      },
    );
  }
}
