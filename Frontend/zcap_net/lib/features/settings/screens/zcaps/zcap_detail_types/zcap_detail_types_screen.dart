import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/data_types/data_types.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/detail_type_categories/detail_type_categories_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_detail_types/zcap_detail_type_isar.dart';
import 'package:zcap_net_app/shared/shared.dart';
import 'package:zcap_net_app/widgets/text_controllers_input_form.dart';

class ZcapDetailTypesScreen extends StatefulWidget {
  const ZcapDetailTypesScreen({super.key});

  @override
  State<ZcapDetailTypesScreen> createState() => _ZcapDetailTypesScreenState();
}

class _ZcapDetailTypesScreenState extends State<ZcapDetailTypesScreen> {
  List<ZcapDetailTypeIsar> zcapDetailTypes = [];
  StreamSubscription? zcapDetailTypesStream;

  bool _isLoading = true;
  final _searchController = TextEditingController();
  String _searchTerm = '';

  bool _isSearchingByName = true;

  @override
  void initState() {
    super.initState();
    zcapDetailTypesStream = DatabaseService.db.zcapDetailTypeIsars
        .buildQuery<ZcapDetailTypeIsar>()
        .watch(fireImmediately: true)
        .listen((data) async {
      for (var item in data) {
        if (!item.detailTypeCategory.isLoaded)
          await item.detailTypeCategory.load();
      }
      setState(() {
        zcapDetailTypes = data;
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
    zcapDetailTypesStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('screen_settings_detail_types'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              await syncServiceV3.syncAllPending(
                  DatabaseService.db.zcapDetailTypeIsars,
                  'zcap-detail-types',
                  'zcapDetailTypeId');
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
    final filteredList = zcapDetailTypes.where((e) {
      if (_isSearchingByName) {
        return e.name.toLowerCase().contains(_searchTerm);
      } else {
        return e.detailTypeCategory.value!.name
            .toLowerCase()
            .contains(_searchTerm);
      }
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
              onAddPressed: () => _addOrEditZcapDetailType(null),
              dropDownFilter: customDropdownSearch(
                  items: [
                    'name'.tr(),
                    'screen_settings_detail_category_name'.tr()
                  ],
                  selectedItem: _isSearchingByName
                      ? 'name'.tr()
                      : 'screen_settings_detail_category_name'.tr(),
                  onSelected: (value) =>
                      setState(() => _isSearchingByName = value == 'name'.tr()),
                  validator: (value) => null,
                  label: 'search_by'.tr(),
                  justLabel: true)),
          const SizedBox(height: 10.0),
          _isLoading
              ? const CircularProgressIndicator()
              : buildListView(
                  filteredList,
                  getLabelsList(filteredList),
                  (zdt) {
                    syncServiceV3.synchronize(
                        zdt,
                        DatabaseService.db.zcapDetailTypeIsars,
                        'zcap-detail-types',
                        'zcapDetailTypeId');
                  },
                  (zdt) => _addOrEditZcapDetailType(zdt),
                  (zdt) async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        title: 'confirm_delete'.tr(),
                        content: 'confirm_delete_message'.tr(),
                      ),
                    );
                    if (confirm == true) {
                      await DatabaseService.db.writeTxn(() async {
                        await DatabaseService.db.zcapDetailTypeIsars
                            .delete(zdt.id);
                      });
                    }
                  },
                ),
        ],
      ),
    );
  }

  List<List<String>> getLabelsList(List<ZcapDetailTypeIsar> filteredList) {
    List<List<String>> labelsList = [];
    for (var zdt in filteredList) {
      labelsList.add([
        "${'name'.tr()}: ${zdt.name}",
        "${'screen_settings_detail_category_name'.tr()}: ${zdt.detailTypeCategory.value!.name}",
        '${'start'.tr()}: ${zdt.startDate.toLocal().toString().split(' ')[0]}',
        '${'end'.tr()}: ${zdt.endDate?.toLocal().toString().split(' ')[0] ?? 'no_end_date'.tr()}'
      ]);
    }
    return labelsList;
  }

  void _addOrEditZcapDetailType(ZcapDetailTypeIsar? zcapDetailType) async {
    final formKey = GlobalKey<FormState>();
    final availableDetailTypeCategory = await DatabaseService
        .db.detailTypeCategoriesIsars
        .filter()
        .startDateLessThan(DateTime.now())
        .and()
        .group((q) => q.endDateIsNull().or().endDateGreaterThan(DateTime.now()))
        .findAll();

    final nameController =
        TextEditingController(text: zcapDetailType?.name ?? '');
    DetailTypeCategoriesIsar? detailTypeCategory =
        zcapDetailType?.detailTypeCategory.value;
    DataTypes? dataType = zcapDetailType?.dataType;
    bool? isMandatory = zcapDetailType?.isMandatory;
    DateTime? startDate = zcapDetailType?.startDate ?? DateTime.now();
    DateTime? endDate = zcapDetailType?.endDate;
    String? selectedItemLabel;
    if (isMandatory == true) {
      selectedItemLabel = 'is_mandatory'.tr();
    } else if (isMandatory == false) {
      selectedItemLabel = 'is_optional'.tr();
    } else {
      selectedItemLabel = null;
    }

    List<TextControllersInputFormConfig> textControllersConfig = [
      TextControllersInputFormConfig(
          controller: nameController, label: 'name'.tr()),
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return AlertDialog(
            title: Text(zcapDetailType == null
                ? '${'new'.tr()} ${'zcap_detail_type'.tr()}'
                : '${'edit'.tr()} ${'screen_detail_types'.tr()}'),
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
            }, [
              customDropdownSearch<DetailTypeCategoriesIsar>(
                  items: availableDetailTypeCategory,
                  selectedItem: detailTypeCategory,
                  onSelected: (DetailTypeCategoriesIsar? value) {
                    setModalState(() {
                      detailTypeCategory = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'required_field'.tr() : null,
                  label: 'screen_settings_detail_category_name'.tr()),
              customDropdownSearch<DataTypes>(
                  items: DataTypes.values,
                  selectedItem: dataType,
                  onSelected: (DataTypes? value) {
                    setModalState(() {
                      dataType = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'required_field'.tr() : null,
                  label: 'data_type'.tr()),
              customDropdownSearch<String>(
                  items: ['is_mandatory'.tr(), 'is_optional'.tr()],
                  selectedItem: selectedItemLabel,
                  onSelected: (String? value) {
                    setModalState(() {
                      selectedItemLabel = value;
                      isMandatory = selectedItemLabel == 'is_mandatory'.tr();
                    });
                  },
                  validator: (value) =>
                      value == null ? 'required_field'.tr() : null,
                  label: 'mandatory_optional'.tr())
            ]),
            actions: [
              CancelTextButton(),
              TextButton(
                child: Text('save'.tr()),
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  if (formKey.currentState!.validate()) {
                    final now = DateTime.now();
                    await DatabaseService.db.writeTxn(() async {
                      final newZcapDetailType =
                          zcapDetailType ?? ZcapDetailTypeIsar();
                      newZcapDetailType.remoteId =
                          zcapDetailType?.remoteId ?? 0;
                      newZcapDetailType.name = nameController.text;
                      newZcapDetailType.detailTypeCategory.value =
                          detailTypeCategory;
                      newZcapDetailType.dataType = dataType!;
                      newZcapDetailType.isMandatory = isMandatory!;
                      newZcapDetailType.startDate = startDate ?? now;
                      newZcapDetailType.endDate = endDate;
                      newZcapDetailType.createdAt =
                          zcapDetailType?.createdAt ?? now;
                      newZcapDetailType.lastUpdatedAt = now;
                      newZcapDetailType.isSynced = false;
                      await DatabaseService.db.zcapDetailTypeIsars
                          .put(newZcapDetailType);
                      await newZcapDetailType.detailTypeCategory.save();
                    });
                    navigator.pop();
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
