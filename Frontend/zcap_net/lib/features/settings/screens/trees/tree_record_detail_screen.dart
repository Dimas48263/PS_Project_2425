import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/shared/data_types.dart';
import 'package:zcap_net_app/features/settings/models/trees/treeLevelDetailType/tree_level_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_detail_types/tree_record_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_details/tree_record_detail_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree_isar.dart';
import '../../../../shared/shared.dart';

class TreeRecordDetailsScreen extends StatefulWidget {
  const TreeRecordDetailsScreen({super.key});

  @override
  State<TreeRecordDetailsScreen> createState() =>
      _TreeRecordDetailsScreenState();
}

class _TreeRecordDetailsScreenState extends State<TreeRecordDetailsScreen> {
  List<TreeRecordDetailIsar> details = [];
  StreamSubscription? detailsStream;

  bool _isLoading = true;
  final _searchController = TextEditingController();
  String _searchTerm = '';

  late final Map<String, String> searchOptionsMap;
  late final List<String> searchKeys;

  String selectedSearchOption = 'value';

  late UserAllowancesProvider allowances;
  late bool canWrite;

  @override
  void initState() {
    super.initState();

    searchOptionsMap = {
      'value': 'value'.tr(),
      'detailType': 'screen_detail_type'.tr(),
      'tree': 'tree'.tr(),
    };

    searchKeys = searchOptionsMap.keys.toList();

    detailsStream = DatabaseService.db.treeRecordDetailIsars
        .buildQuery<TreeRecordDetailIsar>()
        .watch(fireImmediately: true)
        .listen((data) async {
      for (var item in data) {
        if (!item.detailType.isLoaded) await item.detailType.load();
        if (!item.tree.isLoaded) await item.tree.load();
      }
      setState(() {
        details = data;
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
    detailsStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    allowances = context.watch<UserAllowancesProvider>();
    canWrite = allowances.canWrite('user_access_settings_tree_details');
    return Scaffold(
      appBar: AppBar(
        title: Text('screen_settings_details'.tr()),
        actions: [SyncButton()],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    final filteredList = details.where((e) {
      switch (selectedSearchOption) {
        case 'detailType':
          return e.detailType.value!.name.toLowerCase().contains(_searchTerm);
        case 'tree':
          return e.tree.value!.name.toLowerCase().contains(_searchTerm);
        default:
          return e.valueCol.toLowerCase().contains(_searchTerm);
      }
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          CustomSearchAndAddBar(
              canWrite: canWrite,
              controller: _searchController,
              onSearchChanged: (value) => setState(() {
                    _searchTerm = value.toLowerCase();
                  }),
              onIconPressed: () => _addOrEditDetail(null),
              dropDownFilter: customDropdownSearch(
                  items: searchKeys,
                  selectedItem: selectedSearchOption,
                  onSelected: (value) =>
                      setState(() => selectedSearchOption = value ?? 'value'),
                  validator: (value) => null,
                  label: 'search_by'.tr(),
                  justLabel: true,
                  itemLabelBuilder: (item) => searchOptionsMap[item] ?? item)),
          const SizedBox(height: 10.0),
          _isLoading
              ? const CircularProgressIndicator()
              : buildListViewV2<TreeRecordDetailIsar>(
                  canWrite: canWrite,
                  getLabelsListV2(filteredList),
                  () async => await syncService.synchronizeAll(),
                  (detail) => _addOrEditDetail(detail),
                  (detail) async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        title: 'confirm_delete'.tr(),
                        content: 'confirm_delete_message'.tr(),
                      ),
                    );
                    if (confirm == true) {
                      await DatabaseService.db.writeTxn(() async {
                        await DatabaseService.db.treeRecordDetailIsars
                            .delete(detail.id);
                      });
                    }
                  },
                ),
        ],
      ),
    );
  }

  List<List<String>> getLabelsList(List<TreeRecordDetailIsar> filteredList) {
    List<List<String>> labelsList = [];
    for (var tree in filteredList) {
      labelsList.add([
        '${'value'.tr()}: ${tree.valueCol}',
        '${'screen_detail_type'.tr()}: ${tree.detailType.value!.name}',
        '${'tree'.tr()}: ${tree.tree.value!.name}',
        '${'start'.tr()}: ${tree.startDate.toLocal().toString().split(' ')[0]}',
        '${'end'.tr()}: ${tree.endDate?.toLocal().toString().split(' ')[0] ?? 'no_end_date'.tr()}'
      ]);
    }
    return labelsList;
  }

  List<CustomElementListView> getLabelsListV2(
      List<TreeRecordDetailIsar> filteredList) {
    List<CustomElementListView> labelsList = [];
    for (var tree in filteredList) {
      final title = tree.detailType.value!.unit == DataTypes.boolean
          ? tree.valueCol == '1'
              ? 'true'.tr()
              : 'false'.tr()
          : tree.valueCol;
      labelsList.add(
        CustomElementListView(tree, '[${tree.remoteId}] $title', [
          [
            '${'screen_detail_type'.tr()}: ${tree.detailType.value!.name}',
            '${'tree'.tr()}: ${tree.tree.value!.name}'
          ],
          [
            '${'start'.tr()}: ${tree.startDate.toLocal().toString().split(' ')[0]}',
            '${'end'.tr()}: ${tree.endDate?.toLocal().toString().split(' ')[0] ?? 'no_end_date'.tr()}'
          ]
        ]),
      );
    }
    return labelsList;
  }

  void _addOrEditDetail(TreeRecordDetailIsar? detail) async {
    final formKey = GlobalKey<FormState>();
    final availableTrees = await DatabaseService.db.treeIsars
        .filter()
        .startDateLessThan(DateTime.now())
        .and()
        .group((q) => q.endDateIsNull().or().endDateGreaterThan(DateTime.now()))
        .findAll();
    final treeLevelDetailTypes = await DatabaseService
        .db.treeLevelDetailTypeIsars
        .filter()
        .startDateLessThan(DateTime.now())
        .and()
        .group((q) => q.endDateIsNull().or().endDateGreaterThan(DateTime.now()))
        .findAll();
    final availableDetailTypes = await DatabaseService
        .db.treeRecordDetailTypeIsars
        .filter()
        .startDateLessThan(DateTime.now())
        .and()
        .group((q) => q.endDateIsNull().or().endDateGreaterThan(DateTime.now()))
        .findAll();

    final valueController = TextEditingController(text: detail?.valueCol ?? '');
    TreeIsar? tree = detail?.tree.value;
    TreeRecordDetailTypeIsar? detailType = detail?.detailType.value;
    DateTime startDate = detail?.startDate ?? DateTime.now();
    DateTime? endDate = detail?.endDate;

    List<int> availableTreeLevelIds = detailType != null
        ? treeLevelDetailTypes
            .where((e) => e.detailType.value!.id == detailType!.id)
            .map((element) => element.treeLevel.value!.id)
            .toList()
        : [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return AlertDialog(
            title: Text(detail == null
                ? '${'new'.tr()} ${'detail'.tr()}'
                : '${'edit'.tr()} ${'detail'.tr()}'),
            content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    customDropdownSearch<TreeRecordDetailTypeIsar>(
                        enabled: canWrite,
                        label: 'screen_detail_type'.tr(),
                        items: availableDetailTypes,
                        selectedItem: detailType,
                        onSelected: (TreeRecordDetailTypeIsar? value) {
                          setModalState(() {
                            detailType = value;
                            tree = null;
                            valueController.text = ''; 
                            availableTreeLevelIds = treeLevelDetailTypes
                                .where((e) =>
                                    e.detailType.value!.id == detailType!.id)
                                .map((element) => element.treeLevel.value!.id)
                                .toList();
                          });
                        },
                        validator: (value) =>
                            value == null ? 'required_field'.tr() : null),
                    if (detailType != null) ...[
                      if (detailType!.unit == DataTypes.boolean)
                        FormField<bool>(
                          initialValue: valueController.text != ''
                              ? valueController.text == '1'
                              : null,
                          validator: (value) {
                            if (value == null) return 'required_field'.tr();
                            return null;
                          },
                          builder: (field) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('${'value'.tr()}*'),
                                    Checkbox(
                                      value: field.value == true,
                                      onChanged: (val) {
                                        if (!canWrite) return;
                                        final newValue =
                                            field.value == true ? null : true;
                                        field.didChange(newValue);
                                        valueController.text =
                                            newValue != null ? '1' : '';
                                      },
                                    ),
                                    Text("true".tr()),
                                    const SizedBox(width: 20),
                                    Checkbox(
                                      value: field.value == false,
                                      onChanged: (val) {
                                        if (!canWrite) return;
                                        final newValue =
                                            field.value == false ? null : false;
                                        field.didChange(newValue);
                                        valueController.text =
                                            newValue != null ? '0' : '';
                                      },
                                    ),
                                    Text("false".tr()),
                                  ],
                                ),
                                if (field.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      field.errorText!,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                  )
                              ],
                            );
                          },
                        )
                      else
                        TextFormField(
                          enabled: canWrite,
                          controller: valueController,
                          decoration: InputDecoration(
                            labelText: "${'value'.tr()}*",
                            hintText:
                                "${'example_abbreviation'.tr()} ${detailType!.unit.example}",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'required_field'.tr();
                            }
                            if (detailType!.unit.validate(value)) return null;
                            return 'wrong_format'.tr();
                          },
                        )
                    ],
                    customDropdownSearch<TreeIsar>(
                        label: 'screen_settings_tree_elements'.tr(),
                        enabled: canWrite && detailType != null,
                        items: detailType != null
                            ? availableTrees
                                .where((t) => availableTreeLevelIds
                                    .contains(t.treeLevel.value!.id))
                                .toList()
                            : [],
                        selectedItem: tree,
                        onSelected: (TreeIsar? value) {
                          setModalState(() {
                            tree = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'required_field'.tr() : null),
                  ],
                )),
            actions: [
              TextButton(
                child: Text(canWrite ? 'cancel'.tr() : 'close'.tr()),
                onPressed: () => Navigator.pop(context),
              ),
              if (canWrite)
                TextButton(
                  child: Text('save'.tr()),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final isValid = DateUtilsService().validateStartEndDate(
                        startDate: startDate,
                        endDate: endDate,
                        context: context,
                      );
                      if (!isValid) return;
                      await DatabaseService.db.writeTxn(() async {
                        final newDetail = detail ?? TreeRecordDetailIsar();
                        newDetail.remoteId = detail?.remoteId ?? 0;
                        newDetail.valueCol = valueController.text;
                        newDetail.detailType.value = detailType;
                        newDetail.tree.value = tree;
                        newDetail.startDate = startDate;
                        newDetail.endDate = endDate;
                        newDetail.isSynced = false;
                        await DatabaseService.db.treeRecordDetailIsars
                            .put(newDetail);
                        await newDetail.detailType.save();
                        await newDetail.tree.save();
                      });
                      // ignore: use_build_context_synchronously
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
