import 'dart:async';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/core/utils/app_colors.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_types/incident_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incidents/incidents_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_levels/tree_level_isar.dart';
import 'package:zcap_net_app/features/zcap_tree/tree_wrapper.dart';
import 'package:zcap_net_app/widgets/confirm_dialog.dart';
import 'package:zcap_net_app/widgets/custom_app_refrence_date_picker.dart';
import 'package:zcap_net_app/widgets/custom_dropdown_search.dart';
import 'package:zcap_net_app/widgets/custom_form.dart';
import 'package:zcap_net_app/widgets/custom_label_value_text.dart';
import 'package:zcap_net_app/widgets/custom_search_and_add_bar.dart';
import 'package:zcap_net_app/widgets/custom_unsynced_icon.dart';

class IncidentsTreeScreen extends StatefulWidget {
  const IncidentsTreeScreen({super.key});

  @override
  State<IncidentsTreeScreen> createState() => _IncidentsTreeScreenState();
}

class _IncidentsTreeScreenState extends State<IncidentsTreeScreen> {
  late TreeNode<dynamic> root;
  List<IncidentsIsar> incidents = [];
  StreamSubscription? incidentsStream;

  String _searchTerm = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    incidentsStream = DatabaseService.db.incidentsIsars
        .buildQuery<IncidentsIsar>()
        .watch(fireImmediately: true)
        .listen((data) async {
      incidents = data;
      await buildTree();
    });

    root = TreeNode<String>(data: 'screen_incidents'.tr());
  }

  Future<void> buildTree() async {
    final isar = DatabaseService.db;
    final Map<int, List<IncidentsIsar>> incidentsByTree = {};

    for (final i in incidents) {
      await i.incidentType.load();
      await i.treeRecord.load();

      final treeId = i.treeRecord.value?.id;
      if (treeId != null) {
        incidentsByTree.putIfAbsent(treeId, () => []).add(i);
      }
    }

    final allTrees = await isar.treeIsars.where().findAll();
    for (final t in allTrees) {
      await t.parent.load();
    }

    final Map<int, TreeIsar> treeMap = {
      for (var tree in allTrees) tree.id: tree,
    };

    final roots = allTrees.where((t) => t.parent.value == null);
    final rootNode = TreeNode<dynamic>.root(data: 'screen_incidents'.tr());

    for (var rootTree in roots) {
      final node = await buildTreeNode(rootTree, incidentsByTree, treeMap);
      if (node.children.isNotEmpty) {
        rootNode.add(node);
      }
    }

    setState(() {
      root = rootNode;
    });
  }

  Future<TreeNode<dynamic>> buildTreeNode(
    TreeIsar tree,
    Map<int, List<IncidentsIsar>> incidentsByTree,
    Map<int, TreeIsar> treeMap,
  ) async {
    final children =
        treeMap.values.where((t) => t.parent.value?.id == tree.id).toList();

    final incidentsByTreeeList = incidentsByTree[tree.id] ?? [];
    int totalIncidents = incidentsByTreeeList.length;

    final node = TreeNode<dynamic>(data: null);

    for (var child in children) {
      final childNode = await buildTreeNode(child, incidentsByTree, treeMap);
      node.add(childNode);

      if (childNode.data is TreeWrapper) {
        totalIncidents += (childNode.data as TreeWrapper).zcapCount;
      }
    }

    for (var z in incidentsByTreeeList) {
      node.add(TreeNode<dynamic>(data: z));
    }

    node.data = TreeWrapper(tree, totalIncidents);

    return node;
  }

  void printAll(TreeNode<dynamic> node, [int depth = 0]) {
    final indent = '  ' * depth;
    if (node.data is TreeWrapper) {
      print('$indent${(node.data as TreeWrapper).tree.name}');
    } else {
      print('$indent${node.data}');
    }
    for (final child in node.children.values) {
      printAll(child as TreeNode<dynamic>, depth + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('screen_incidents'.tr()),
          actions: [
            AppReferenceDateWidget(),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomSearchAndAddBar(
                controller: _searchController,
                onSearchChanged: (value) => setState(() {
                  _searchTerm = value.toLowerCase();
                }),
                onAddPressed: () => _addOrEditIncident(context),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TreeView.simple(
                key: ValueKey(root),
                tree: root,
                expansionIndicatorBuilder: (context, node) =>
                    ChevronIndicator.rightDown(tree: node),
                indentation: const Indentation(style: IndentStyle.squareJoint),
                builder: (context, node) {
                  final data = node.data;
                  final level = node.level;

                  final maxDepth = 12;
                  final t = (level / maxDepth).clamp(0.0, 1.0);
                  final bgColor = Color.lerp(AppColors.gradiantStartColor,
                      AppColors.gradiantEndColor, t);
                  if (data is IncidentsIsar) {
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(
                          '${(data.remoteId != null && data.remoteId! > 0) ? "[${data.remoteId}] " : ""}${data.incidentType.value!.name}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          children: [
                            Expanded(
                              child: CustomLabelValueText(
                                label: 'start'.tr(),
                                value: data.startDate
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0],
                              ),
                            ),
                            Expanded(
                              child: CustomLabelValueText(
                                label: 'end'.tr(),
                                value: data.endDate != null
                                    ? data.endDate!
                                        .toLocal()
                                        .toString()
                                        .split(' ')[0]
                                    : 'no_end_date'.tr(),
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!data.isSynced) CustomUnsyncedIcon(),
                            IconButton(
                              onPressed: () {
                                _addOrEditIncident(context, incident: data);
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => ConfirmDialog(
                                    title: 'confirm_delete'.tr(),
                                    content: 'confirm_delete_message'.tr(),
                                  ),
                                );
                                if (confirm == true) {
                                  await DatabaseService.db.writeTxn(() async {
                                    await DatabaseService.db.incidentsIsars
                                        .delete(data.id);
                                  });
                                }
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (data is TreeWrapper) {
                    if (data.zcapCount <= 0) return const SizedBox.shrink();
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: bgColor,
                      child: ListTile(
                        title: Text('${data.tree.name} (${data.zcapCount})'),
                      ),
                    );
                  } else {
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: bgColor,
                      child: ListTile(
                        title: Text(data ?? 'Sem nome'),
                      ),
                    );
                  }
                },
              ),
            ))
          ],
        ));
  }

  void _addOrEditIncident(BuildContext context, {IncidentsIsar? incident}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    IncidentTypesIsar? incidentType = incident?.incidentType.value;
    TreeIsar? treeRecord = incident?.treeRecord.value;
    TreeLevelIsar? treeLevel = incident?.treeRecord.value?.treeLevel.value;

    DateTime startDate = incident?.startDate ?? DateTime.now();
    DateTime? endDate = incident?.endDate;

    final formKey = GlobalKey<FormState>();

    final availableIncidentTypes = await DatabaseService.db.incidentTypesIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();

    final availableTreeLevels = await DatabaseService.db.treeLevelIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();
    
    final availableTrees = await DatabaseService.db.treeIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();

    showDialog(
        context: context,
        builder: (context) {
          final allowances = context.watch<UserAllowancesProvider>();

          return StatefulBuilder(builder: (context, setModalState) {
            return AlertDialog(
              title: Text(incident == null
                  ? '${'new'.tr()} ${'incident'.tr()}'
                  : '${'edit'.tr()} ${'incident'.tr()}'),
              content: buildForm(
                  formKey, context, [], startDate, endDate,
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
                        treeRecord = null;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'required_field'.tr() : null,
                    label: 'level'.tr()),
                customDropdownSearch<TreeIsar>(
                  label: 'tree'.tr(),
                  enabled: treeLevel != null,
                  items: treeLevel == null
                      ? availableTrees
                      : availableTrees
                          .where((t) =>
                              t.treeLevel.value!.levelId ==
                              treeLevel!.levelId)
                          .toList(),
                  selectedItem: treeRecord,
                  onSelected: (TreeIsar? value) {
                    setModalState(() {
                      treeRecord = value;
                    });
                  },
                  validator: (value) {
                    return value == null
                        ? 'required_field'.tr()
                        : null;
                  },
                ),
                customDropdownSearch<IncidentTypesIsar>(
                  itemLabelBuilder: (item) => item.name,
                  label: "screen_incident_type".tr(),
                  items: availableIncidentTypes,
                  selectedItem: incidentType,
                  onSelected: (IncidentTypesIsar? value) {
                    setModalState(() {
                      incidentType = value;
                    });
                  },
                  validator: (value) {
                    return value == null
                        ? 'required_field'.tr()
                        : null;
                  },
                )
              ]),
              actions: [
                TextButton(
                  child: Text(
                      allowances.canWrite('user_access_settings_tree_elements') //TODO
                          ? 'cancel'.tr()
                          : 'close'.tr()),
                  onPressed: () => Navigator.pop(context),
                ),
                if (allowances.canWrite('user_access_settings_tree_elements')) //TODO
                  TextButton(
                    child: Text('save'.tr()),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final now = DateTime.now();
                        await DatabaseService.db.writeTxn(() async {
                          final newIncident = incident ?? IncidentsIsar();
                          newIncident.remoteId = incident?.remoteId ?? 0;
                          newIncident.incidentType.value = incidentType;
                          newIncident.treeRecord.value = treeRecord;
                          newIncident.startDate = startDate;
                          newIncident.endDate = endDate;
                          newIncident.createdAt = incident?.createdAt ?? now;
                          newIncident.lastUpdatedAt = now;
                          newIncident.isSynced = false;
                          await DatabaseService.db.incidentsIsars.put(newIncident);
                          await newIncident.incidentType.save();
                          await newIncident.treeRecord.save();
                        });
                        Navigator.pop(context);
                      }
                    },
                  ),
              ],
            );
          });
        });
  }
}
