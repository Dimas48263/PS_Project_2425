import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/detail_type_categories/detail_type_categories_isar.dart';
import 'package:zcap_net_app/shared/shared.dart';
import 'package:zcap_net_app/widgets/text_controllers_input_form.dart';

class DetailTypeCategoriesScreen extends StatefulWidget {
  const DetailTypeCategoriesScreen({super.key});

  @override
  State<DetailTypeCategoriesScreen> createState() =>
      _DetailTypeCategoriesScreenState();
}

class _DetailTypeCategoriesScreenState
    extends State<DetailTypeCategoriesScreen> {
  List<DetailTypeCategoriesIsar> detailTypeCategories = [];
  StreamSubscription? detailTypeCategoriesStream;

  bool _isLoading = true;
  final _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    detailTypeCategoriesStream = DatabaseService.db.detailTypeCategoriesIsars
        .buildQuery<DetailTypeCategoriesIsar>()
        .watch(fireImmediately: true)
        .listen((data) async {
      setState(() {
        detailTypeCategories = data;
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
    detailTypeCategoriesStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('screen_settings_detail_category'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              await syncServiceV3.syncAllPending(
                  DatabaseService.db.detailTypeCategoriesIsars,
                  'detail-type-categories',
                  'detailTypeCategoryId');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('service_sync_ok'.tr())),
                );
              }
            },
          ),
        ],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    final filteredList = detailTypeCategories.where((e) {
      return e.name.toLowerCase().contains(_searchTerm);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          CustomSearchAndAddBar(
              controller: _searchController,
              onSearchChanged: (value) => setState(() {
                    _searchTerm = value.toLowerCase();
                  }),
              onAddPressed: () => _addOrEditDetailTypeCategory(null)),
          const SizedBox(height: 10.0),
          _isLoading
              ? const CircularProgressIndicator()
              : buildListView(
                  filteredList,
                  getLabelsList(filteredList),
                  (detailTypeCategory) {
                    syncServiceV3.synchronize(
                        detailTypeCategory,
                        DatabaseService.db.detailTypeCategoriesIsars,
                        'detail-type-categories',
                        'detailTypeCategoryId');
                  },
                  (detailTypeCategory) =>
                      _addOrEditDetailTypeCategory(detailTypeCategory),
                  (detailTypeCategory) async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        title: 'confirm_delete'.tr(),
                        content: 'confirm_delete_message'.tr(),
                      ),
                    );
                    if (confirm == true) {
                      await DatabaseService.db.writeTxn(() async {
                        await DatabaseService.db.detailTypeCategoriesIsars
                            .delete(detailTypeCategory.id);
                      });
                    }
                  }),
        ],
      ),
    );
  }

  List<List<String>> getLabelsList(
      List<DetailTypeCategoriesIsar> filteredList) {
    List<List<String>> labelsList = [];
    for (var detailTypeCategory in filteredList) {
      labelsList.add([
        detailTypeCategory.name,
        '${'start'.tr()}: ${detailTypeCategory.startDate.toLocal().toString().split(' ')[0]}',
        '${'end'.tr()}: ${detailTypeCategory.endDate?.toLocal().toString().split(' ')[0] ?? 'no_end_date'.tr()}'
      ]);
    }
    return labelsList;
  }

  void _addOrEditDetailTypeCategory(
      DetailTypeCategoriesIsar? detailTypeCategory) {
    final formKey = GlobalKey<FormState>();
    final nameController =
        TextEditingController(text: detailTypeCategory?.name ?? '');
    DateTime? startDate = detailTypeCategory?.startDate ?? DateTime.now();
    DateTime? endDate = detailTypeCategory?.endDate;

    List<TextControllersInputFormConfig> textControllersConfig = [
      TextControllersInputFormConfig(
          controller: nameController, label: 'name'.tr()),
    ];

    showDialog(
      context: context,
      builder: (context) {
        final allowances = context.watch<UserAllowancesProvider>();

        return StatefulBuilder(builder: (context, setModalState) {
          return AlertDialog(
            title: Text(detailTypeCategory == null
                ? '${'new'.tr()} ${'level'.tr()}'
                : '${'edit'.tr()} ${'level'.tr()}'),
            content: buildForm(
                formKey, context, textControllersConfig, startDate, endDate,
                (value) {
              setState(() => startDate = value);
              setModalState(() {}); // Atualiza o dialog
            }, (value) {
              setState(() => endDate = value);
              setModalState(() {}); // Atualiza o dialog
            }, () {
              setModalState(() {
                endDate = null;
              });
            }, []),
            actions: [
              TextButton(
                child: Text(
                    allowances.canWrite('user_access_settings_detail_category')
                        ? 'cancel'.tr()
                        : 'close'.tr()),
                onPressed: () => Navigator.pop(context),
              ),
              if (allowances.canWrite('user_access_settings_detail_category'))
                TextButton(
                  child: Text('save'.tr()),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final now = DateTime.now();
                      await DatabaseService.db.writeTxn(() async {
                        final newDetailTypeCategory =
                            detailTypeCategory ?? DetailTypeCategoriesIsar();
                        newDetailTypeCategory.remoteId =
                            detailTypeCategory?.remoteId ?? 0;
                        newDetailTypeCategory.name = nameController.text;
                        newDetailTypeCategory.startDate = startDate ?? now;
                        newDetailTypeCategory.endDate = endDate;
                        newDetailTypeCategory.createdAt =
                            detailTypeCategory?.createdAt ?? now;
                        newDetailTypeCategory.lastUpdatedAt = now;
                        newDetailTypeCategory.isSynced = false;

                        await DatabaseService.db.detailTypeCategoriesIsars
                            .put(newDetailTypeCategory);
                      });
                      Navigator.pop(context);
                    }
                  },
                ),
            ],
          );
        });
      },
    );
  }
}
