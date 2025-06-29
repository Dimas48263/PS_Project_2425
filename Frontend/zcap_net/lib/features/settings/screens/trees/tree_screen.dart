import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/widgets/text_controllers_input_form.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_levels/tree_level_isar.dart';
import 'dart:async';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree_isar.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/shared/shared.dart';

class TreesScreen extends StatefulWidget {
  const TreesScreen({super.key});

  @override
  State<TreesScreen> createState() => _TreesScreenState();
}

class _TreesScreenState extends State<TreesScreen> {
  List<TreeIsar> trees = [];
  StreamSubscription? treesStream;

  bool _isLoading = true;
  final _searchController = TextEditingController();
  String _searchTerm = '';

  late final Map<String, String> searchOptionsMap;
  late final List<String> searchKeys;

  String selectedSearchOption = 'name';

  @override
  void initState() {
    super.initState();

    searchOptionsMap = {
      'name': 'name'.tr(),
      'level': 'level'.tr(),
      'parent': 'parent'.tr(),
    };

    searchKeys = searchOptionsMap.keys.toList();

    treesStream = DatabaseService.db.treeIsars
        .buildQuery<TreeIsar>()
        .watch(fireImmediately: true)
        .listen((data) async {
      for (var element in data) {
        if (!element.treeLevel.isLoaded) await element.treeLevel.load();
        if (!element.parent.isLoaded) await element.parent.load();
      }
      setState(() {
        trees = data;
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
    treesStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tree'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              await syncServiceV3.syncAllPending(
                  DatabaseService.db.treeIsars, 'trees', 'treeRecordId');
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
    final filteredList = trees.where((e) {
      switch (selectedSearchOption) {
        case 'level':
          return e.treeLevel.value!.name.toLowerCase().contains(_searchTerm);
        case 'parent':
          if (e.parent.value == null) return false;
          return e.parent.value!.name.toLowerCase().contains(_searchTerm);
        default:
          return e.name.toLowerCase().contains(_searchTerm);
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
            onAddPressed: () => _addOrEditTree(null),
            dropDownFilter: customDropdownSearch(
                items: searchKeys,
                selectedItem: selectedSearchOption,
                onSelected: (value) =>
                    setState(() => selectedSearchOption = value ?? 'name'),
                validator: (value) => null,
                label: 'search_by'.tr(),
                justLabel: true,
                itemLabelBuilder: (item) => searchOptionsMap[item] ?? item),
          ),
          const SizedBox(height: 10.0),
          _isLoading
              ? const CircularProgressIndicator()
              : buildListView(
                  filteredList,
                  getLabelsList(filteredList),
                  (tree) {
                    syncServiceV3.synchronize(tree,
                        DatabaseService.db.treeIsars, 'trees', 'treeRecordId');
                  },
                  (tree) => _addOrEditTree(tree),
                  (tree) async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        title: 'confirm_delete'.tr(),
                        content: 'confirm_delete_message'.tr(),
                      ),
                    );
                    if (confirm == true) {
                      await DatabaseService.db.writeTxn(() async {
                        await DatabaseService.db.treeIsars.delete(tree.id);
                      });
                    }
                  },
                ),
        ],
      ),
    );
  }

  List<List<String>> getLabelsList(List<TreeIsar> filteredList) {
    List<List<String>> labelsList = [];
    for (var tree in filteredList) {
      labelsList.add([
        '${'name'.tr()}: ${tree.name}',
        '${'level'.tr()}: ${tree.treeLevel.value!.name}',
        '${'parent'.tr()}: ${tree.parent.value?.name ?? 'no_parent'.tr()}',
        '${'start'.tr()}: ${tree.startDate.toLocal().toString().split(' ')[0]}',
        '${'end'.tr()}: ${tree.endDate?.toLocal().toString().split(' ')[0] ?? 'no_end_date'.tr()}'
      ]);
    }
    return labelsList;
  }

  void _addOrEditTree(TreeIsar? tree) async {
    final formKey = GlobalKey<FormState>();
    final availableTreeLevels =
        await DatabaseService.db.treeLevelIsars.where().findAll();
    final nameController = TextEditingController(text: tree?.name ?? '');
    TreeLevelIsar? treeLevel = tree?.treeLevel.value;
    TreeIsar? parent = tree?.parent.value;
    DateTime? startDate = tree?.startDate ?? DateTime.now();
    DateTime? endDate = tree?.endDate;

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
            title: Text(tree == null
                ? '${'new'.tr()} ${'tree_element'.tr()}'
                : '${'edit'.tr()} ${'screen_settings_structure'.tr()}'),
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
              customDropdownSearch<TreeLevelIsar>(
                  items: availableTreeLevels,
                  selectedItem: treeLevel,
                  onSelected: (TreeLevelIsar? value) {
                    setModalState(() {
                      treeLevel = value;
                      parent = null;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'required_field'.tr() : null,
                  label: 'level'.tr()),
              customDropdownSearch<TreeIsar>(
                label: 'parent'.tr(),
                enabled: treeLevel != null && treeLevel!.levelId > 1,
                items: treeLevel == null
                    ? trees
                    : trees
                        .where((t) =>
                            t.treeLevel.value!.levelId + 1 ==
                            treeLevel!.levelId)
                        .toList(),
                selectedItem: parent,
                onSelected: (TreeIsar? value) {
                  setModalState(() {
                    parent = value;
                  });
                },
                validator: (value) {
                  return value == null &&
                          treeLevel != null &&
                          treeLevel!.levelId > 1
                      ? 'required_field'.tr()
                      : null;
                },
              )
            ]),
            actions: [
              TextButton(
                child: Text(
                    allowances.canWrite('user_access_settings_tree_elements')
                        ? 'cancel'.tr()
                        : 'close'.tr()),
                onPressed: () => Navigator.pop(context),
              ),
              if (allowances.canWrite('user_access_settings_tree_elements'))
                TextButton(
                  child: Text('save'.tr()),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final now = DateTime.now();
                      await DatabaseService.db.writeTxn(() async {
                        final newTree = tree ?? TreeIsar();
                        newTree.remoteId = tree?.remoteId ?? 0;
                        newTree.name = nameController.text;
                        newTree.treeLevel.value = treeLevel;
                        newTree.parent.value = parent;
                        newTree.startDate = startDate ?? now;
                        newTree.endDate = endDate;
                        newTree.isSynced = false;
                        await DatabaseService.db.treeIsars.put(newTree);
                        await newTree.treeLevel.save();
                        if (newTree.parent.value != null) {
                          await newTree.parent.save();
                        }
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
