import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/widgets/text_controllers_input_form.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_levels/tree_level_isar.dart';
import 'package:zcap_net_app/shared/shared.dart';
import 'package:zcap_net_app/core/services/database_service.dart';

class TreeLevelsScreen extends StatefulWidget {
  const TreeLevelsScreen({super.key});

  @override
  State<TreeLevelsScreen> createState() => _TreeLevelsScreenState();
}

class _TreeLevelsScreenState extends State<TreeLevelsScreen> {
  List<TreeLevelIsar> treeLevels = [];
  StreamSubscription? treeLevelsStream;

  bool _isLoading = true;
  final _searchController = TextEditingController();
  String _searchTerm = '';

  bool _isSearchingByName = true;

  @override
  void initState() {
    super.initState();
    treeLevelsStream = DatabaseService.db.treeLevelIsars
        .buildQuery<TreeLevelIsar>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        treeLevels = data;
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
    treeLevelsStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('screen_settings_tree_levels'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              await syncServiceV3.syncAllPending(
                  DatabaseService.db.treeLevelIsars,
                  'tree-levels',
                  'treeLevelId');
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
    final filteredList = treeLevels.where((e) {
      if (_isSearchingByName) {
        return e.name.toLowerCase().contains(_searchTerm);
      } else {
        return e.levelId.toString().toLowerCase().contains(_searchTerm);
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
              onAddPressed: () => _addOrEditTreeLevel(null),
              dropDownFilter: customDropdownSearch(
                  items: ['name'.tr(), 'level'.tr()],
                  selectedItem: _isSearchingByName ? 'name'.tr() : 'level'.tr(),
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
                  (treeLevel) {
                    syncServiceV3.synchronize(
                        treeLevel,
                        DatabaseService.db.treeLevelIsars,
                        'tree-levels',
                        'treeLevelId');
                  },
                  (treeLevel) => _addOrEditTreeLevel(treeLevel),
                  (treeLevel) async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        title: 'confirm_delete'.tr(),
                        content: 'confirm_delete_message'.tr(),
                      ),
                    );
                    if (confirm == true) {
                      await DatabaseService.db.writeTxn(() async {
                        await DatabaseService.db.treeLevelIsars
                            .delete(treeLevel.id);
                      });
                    }
                  },
                ),
        ],
      ),
    );
  }

  List<List<String>> getLabelsList(List<TreeLevelIsar> filteredList) {
    List<List<String>> labelsList = [];
    for (var treeLevel in filteredList) {
      labelsList.add([
        '${'name'.tr()}: ${treeLevel.name}',
        '${'level'.tr()}: ${treeLevel.levelId}',
        '${'start'.tr()}: ${treeLevel.startDate.toLocal().toString().split(' ')[0]}',
        '${'end'.tr()}: ${treeLevel.endDate?.toLocal().toString().split(' ')[0] ?? 'no_end_date'.tr()}'
      ]);
    }
    return labelsList;
  }

  void _addOrEditTreeLevel(TreeLevelIsar? treeLevel) {
    final formKey = GlobalKey<FormState>();
    final levelIdController =
        TextEditingController(text: treeLevel?.levelId.toString() ?? '');
    final nameController = TextEditingController(text: treeLevel?.name ?? '');
    final descriptionController =
        TextEditingController(text: treeLevel?.description ?? '');
    DateTime? startDate = treeLevel?.startDate ?? DateTime.now();
    DateTime? endDate = treeLevel?.endDate;

    List<TextControllersInputFormConfig> textControllersConfig = [
      TextControllersInputFormConfig(
          controller: levelIdController,
          label: 'level'.tr(),
          validator: (value) {
            if (value == null || value.isEmpty) return 'required_field'.tr();
            if (int.tryParse(value) == null) return 'invalid_data'.tr();
            return null;
          }),
      TextControllersInputFormConfig(
          controller: nameController, label: 'name'.tr()),
      TextControllersInputFormConfig(
          controller: descriptionController,
          label: 'description'.tr(),
          validator: (value) {
            return null;
          }),
    ];

    showDialog(
      context: context,
      builder: (context) {
        final allowances = context.watch<UserAllowancesProvider>();

        return StatefulBuilder(builder: (context, setModalState) {
          return AlertDialog(
            title: Text(treeLevel == null
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
                    allowances.canWrite('user_access_settings_tree_levels')
                        ? 'cancel'.tr()
                        : 'close'.tr()),
                onPressed: () => Navigator.pop(context),
              ),
              if (allowances.canWrite('user_access_settings_tree_levels'))
                TextButton(
                  child: Text('save'.tr()),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final now = DateTime.now();
                      await DatabaseService.db.writeTxn(() async {
                        final newTreeLevel = treeLevel ?? TreeLevelIsar();
                        newTreeLevel.remoteId = treeLevel?.remoteId ?? 0;
                        newTreeLevel.levelId =
                            int.parse(levelIdController.text);
                        newTreeLevel.name = nameController.text;
                        newTreeLevel.description =
                            descriptionController.text.isEmpty
                                ? null
                                : descriptionController.text;
                        newTreeLevel.startDate = startDate ?? now;
                        newTreeLevel.endDate = endDate;
                        newTreeLevel.isSynced = false;

                        await DatabaseService.db.treeLevelIsars
                            .put(newTreeLevel);
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
