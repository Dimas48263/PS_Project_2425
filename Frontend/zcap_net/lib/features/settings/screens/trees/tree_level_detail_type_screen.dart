import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/features/settings/models/trees/treeLevelDetailType/tree_level_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_levels/tree_level_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_detail_types/tree_record_detail_type_isar.dart';
import 'package:zcap_net_app/shared/shared.dart';

class TreeLevelDetailTypeScreen extends StatefulWidget {
  const TreeLevelDetailTypeScreen({super.key});

  @override
  State<TreeLevelDetailTypeScreen> createState() =>
      _TreeLevelDetailTypeScreenState();
}

class _TreeLevelDetailTypeScreenState extends State<TreeLevelDetailTypeScreen> {
  List<TreeLevelDetailTypeIsar> tldt = [];
  StreamSubscription? tldtStream;

  bool _isLoading = true;
  final _searchController = TextEditingController();
  String _searchTerm = '';

  bool _isSearchingBylevel = true;

  @override
  void initState() {
    super.initState();
    tldtStream = DatabaseService.db.treeLevelDetailTypeIsars
        .buildQuery<TreeLevelDetailTypeIsar>()
        .watch(fireImmediately: true)
        .listen((data) async {
      for (var element in data) {
        await element.treeLevel.load();
        await element.detailType.load();
      }
      setState(() {
        tldt = data;
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
    tldtStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('screen_settings_tree_level_detail_type'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              await syncServiceV3.syncAllPending(
                  DatabaseService.db.treeLevelDetailTypeIsars,
                  'tree-level-detail-type',
                  'treeLevelDetailTypeId');
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
    final filteredList = tldt.where((e) {
      if (_isSearchingBylevel) {
        return e.treeLevel.value!.name.toLowerCase().contains(_searchTerm);
      } else {
        return e.detailType.value!.name.toLowerCase().contains(_searchTerm);
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
            onAddPressed: () => _addOrEditTreeLevelDetailType(null),
            dropDownFilter: customDropdownSearch(
                items: ['level'.tr(), 'screen_detail_type'.tr()],
                selectedItem: _isSearchingBylevel
                    ? 'level'.tr()
                    : 'screen_detail_type'.tr(),
                onSelected: (value) =>
                    setState(() => _isSearchingBylevel = value == 'level'.tr()),
                validator: (value) => null,
                label: 'search_by'.tr()),
          ),
          const SizedBox(height: 10.0),
          _isLoading
              ? const CircularProgressIndicator()
              : buildListView(
                  filteredList,
                  getLabelsList(filteredList),
                  (detail) {
                    syncServiceV3.synchronize(
                        detail,
                        DatabaseService.db.treeLevelDetailTypeIsars,
                        'tree-level-detail-type',
                        'treeLevelDetailTypeId');
                  },
                  (detail) => _addOrEditTreeLevelDetailType(detail),
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
                        await DatabaseService.db.treeLevelDetailTypeIsars
                            .delete(detail.id);
                      });
                    }
                  },
                ),
        ],
      ),
    );
  }

  List<List<String>> getLabelsList(List<TreeLevelDetailTypeIsar> filteredList) {
    List<List<String>> labelsList = [];
    for (var t in filteredList) {
      labelsList.add([
        '${'level'.tr()}: ${t.treeLevel.value!.name}',
        '${'screen_detail_type'.tr()}: ${t.detailType.value!.name}',
        '${'start'.tr()}: ${t.startDate.toLocal().toString().split(' ')[0]}',
        '${'end'.tr()}: ${t.endDate?.toLocal().toString().split(' ')[0] ?? 'no_end_date'.tr()}'
      ]);
    }
    return labelsList;
  }

  void _addOrEditTreeLevelDetailType(TreeLevelDetailTypeIsar? t) async {
    final formKey = GlobalKey<FormState>();

    final availableTreeLevels = await DatabaseService.db.treeLevelIsars
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

    TreeLevelIsar? treeLevel = t?.treeLevel.value;
    TreeRecordDetailTypeIsar? detailType = t?.detailType.value;
    DateTime? startDate = t?.startDate ?? DateTime.now();
    DateTime? endDate = t?.endDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          final allowances = context.watch<UserAllowancesProvider>();
          return AlertDialog(
            title: Text(t == null
                ? '${'new'.tr()} ${'detail'.tr()}'
                : '${'edit'.tr()} ${'detail'.tr()}'),
            content:
                buildForm(formKey, context, [], startDate, endDate, (value) {
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
              customDropdownSearch<TreeRecordDetailTypeIsar>(
                  items: availableDetailTypes,
                  selectedItem: detailType,
                  onSelected: (TreeRecordDetailTypeIsar? value) {
                    setModalState(() {
                      detailType = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'required_field'.tr() : null),
              customDropdownSearch<TreeLevelIsar>(
                  items: availableTreeLevels,
                  selectedItem: treeLevel,
                  onSelected: (TreeLevelIsar? value) {
                    setModalState(() {
                      treeLevel = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'required_field'.tr() : null),
            ]),
            actions: [
              TextButton(
                child: Text(allowances.canWrite(
                        'user_access_settings_tree_detail_association')
                    ? 'cancel'.tr()
                    : 'close'.tr()),
                onPressed: () => Navigator.pop(context),
              ),
              if (allowances
                  .canWrite('user_access_settings_tree_detail_association'))
                TextButton(
                  child: Text('save'.tr()),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final now = DateTime.now();
                      await DatabaseService.db.writeTxn(() async {
                        final newTreeLevelDetailType =
                            t ?? TreeLevelDetailTypeIsar();
                        newTreeLevelDetailType.remoteId = t?.remoteId ?? 0;
                        newTreeLevelDetailType.detailType.value = detailType;
                        newTreeLevelDetailType.treeLevel.value = treeLevel;
                        newTreeLevelDetailType.startDate = startDate ?? now;
                        newTreeLevelDetailType.endDate = endDate;
                        newTreeLevelDetailType.isSynced = false;
                        await DatabaseService.db.treeLevelDetailTypeIsars
                            .put(newTreeLevelDetailType);
                        await newTreeLevelDetailType.detailType.save();
                        await newTreeLevelDetailType.treeLevel.save();
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
