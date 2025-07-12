import 'dart:async';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/core/utils/app_colors.dart';
import 'package:zcap_net_app/data/app_date_provider.dart';
import 'package:zcap_net_app/features/incidents_tree/persons_screen.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities/entities_isar.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_types/incident_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_zcaps/incident_zcaps_isar.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incidents/incidents_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_levels/tree_level_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcaps/zcap_isar.dart';
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

  List<IncidentZcapsIsar> incidentsZcaps = [];
  StreamSubscription? incidentsZcapsStream;

  Map<int, List<IncidentZcapsIsar>> zcapsByIncident = {};

  DateTime? _currentReferenceDate;

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
    incidentsZcapsStream = DatabaseService.db.incidentZcapsIsars
        .buildQuery<IncidentZcapsIsar>()
        .watch(fireImmediately: true)
        .listen((data) async {
      incidentsZcaps = data;
      zcapsByIncident = {};
      for (var iz in incidentsZcaps) {
        await iz.zcap.load();
        await iz.incident.load();
        await iz.entity.load();
        final list = zcapsByIncident[iz.incident.value!.id];
        if (list == null) {
          zcapsByIncident[iz.incident.value!.id] = [];
        }
        zcapsByIncident[iz.incident.value!.id]!.add(iz);
      }
      await buildTree();
    });
    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text.toLowerCase();
      });
      buildTree();
    });

    root = TreeNode<String>(data: 'screen_incidents'.tr());
  }

  @override
  void dispose() {
    incidentsStream?.cancel();
    incidentsZcapsStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> buildTree() async {
    final referenceDate = context.read<AppReferenceDateProvider>();
    final isar = DatabaseService.db;
    final Map<int, List<IncidentsIsar>> incidentsByTree = {};

    for (final i in incidents) {
      if (i.startDate.isAfter(referenceDate.endOfMonth) ||
          (i.endDate != null &&
              i.endDate!.isBefore(referenceDate.startOfMonth))) {
        continue;
      }
      await i.incidentType.load();
      await i.treeRecord.load();

      if (_searchTerm.isNotEmpty &&
          !i.incidentType.value!.name.toLowerCase().contains(_searchTerm)) {
        continue;
      }
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

    for (var i in incidentsByTreeeList) {
      final incidentNode = TreeNode<IncidentsIsar>(data: i);
      for (var iz in zcapsByIncident[i.id] ?? []) {
        incidentNode.add(TreeNode<IncidentZcapsIsar>(data: iz));
      }
      node.add(incidentNode);
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newReferenceDate =
        context.watch<AppReferenceDateProvider>().referenceDate;
    if (_currentReferenceDate != newReferenceDate) {
      _currentReferenceDate = newReferenceDate;
      buildTree();
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
                          '${(data.remoteId != null && data.remoteId! > 0) ? "[${data.remoteId}] " : ""}${data.incidentType.value!.name} (${zcapsByIncident[data.id]?.length ?? 0})',
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
                            ElevatedButton(onPressed: () {_addZcap(data);}, child: Text('${'add'.tr()} ZCAP')),
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
                  if (data is IncidentZcapsIsar) {
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(data.zcap.value!.name),
                        trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PersonsScreen(incidentZcapIsar: data)));
                              }, child: Text('Persons')),
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

  void _addOrEditIncident(BuildContext context,
      {IncidentsIsar? incident}) async {
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
                              t.treeLevel.value!.levelId == treeLevel!.levelId)
                          .toList(),
                  selectedItem: treeRecord,
                  onSelected: (TreeIsar? value) {
                    setModalState(() {
                      treeRecord = value;
                    });
                  },
                  validator: (value) {
                    return value == null ? 'required_field'.tr() : null;
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
                    return value == null ? 'required_field'.tr() : null;
                  },
                )
              ]),
              actions: [
                TextButton(
                  child: Text(allowances
                          .canWrite('user_access_settings_tree_elements') //TODO
                      ? 'cancel'.tr()
                      : 'close'.tr()),
                  onPressed: () => Navigator.pop(context),
                ),
                if (allowances
                    .canWrite('user_access_settings_tree_elements')) //TODO
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
                          await DatabaseService.db.incidentsIsars
                              .put(newIncident);
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

  void _addZcap(IncidentsIsar incident) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final formKey = GlobalKey<FormState>();
    final allZcaps = await DatabaseService.db.zcapIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();
    final zcapsAlreadyInIncident = zcapsByIncident[incident.id]?.map((e) => e.zcap.value!.id).toList();
    final availableZcaps = zcapsAlreadyInIncident == null ? allZcaps : allZcaps.where((z) => !zcapsAlreadyInIncident.contains(z.id)).toList();
    ZcapIsar? selectedZcap;

    final availableEntities = await DatabaseService.db.entitiesIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();
    EntitiesIsar? selectedEntity;

    showDialog(context: context, builder: (context) {
      final allowances = context.watch<UserAllowancesProvider>();

          return StatefulBuilder(builder: (context, setModalState) {
            return AlertDialog(
              title: Text('${'add'.tr()} ZCAP'),
              content: Form(
                key: formKey, 
                child: Column(children: [
                  customDropdownSearch<ZcapIsar>(
                    itemLabelBuilder: (item) => item.name,
                    items: availableZcaps, 
                    selectedItem: selectedZcap, 
                    onSelected: (zcap) => setModalState(() => selectedZcap = zcap), 
                    validator: (value) => value == null ? 'required_field'.tr() : null,
                    label: 'ZCAP'
                  ),
                  customDropdownSearch<EntitiesIsar>(
                    itemLabelBuilder: (item) => item.name,
                    items: availableEntities, 
                    selectedItem: selectedEntity, 
                    onSelected: (entity) => setModalState(() =>  selectedEntity= entity), 
                    validator: (value) => value == null ? 'required_field'.tr() : null,
                    label: 'screen_entity'.tr()
                  ),
                ],)),
              actions: [
                TextButton(
                  child: Text(allowances
                          .canWrite('user_access_settings_tree_elements') //TODO
                      ? 'cancel'.tr()
                      : 'close'.tr()),
                  onPressed: () => Navigator.pop(context),
                ),
                if (allowances
                    .canWrite('user_access_settings_tree_elements')) //TODO
                  TextButton(
                    child: Text('save'.tr()),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final navigator = Navigator.of(context);
                        final now = DateTime.now();
                        await DatabaseService.db.writeTxn(() async {
                          final newIncidentZcap = IncidentZcapsIsar();
                          newIncidentZcap.remoteId = 0;
                          newIncidentZcap.incident.value = incident;
                          newIncidentZcap.zcap.value = selectedZcap;
                          newIncidentZcap.entity.value = selectedEntity;
                          newIncidentZcap.startDate = now;
                          newIncidentZcap.endDate = null;
                          newIncidentZcap.createdAt = now;
                          newIncidentZcap.lastUpdatedAt = now;
                          newIncidentZcap.isSynced = false;
                          await DatabaseService.db.incidentZcapsIsars
                              .put(newIncidentZcap);
                          await newIncidentZcap.incident.save();
                          await newIncidentZcap.zcap.save();
                          await newIncidentZcap.entity.save();
                        });
                        navigator.pop();
                      }
                    },
                  ),
              ],
            );
          });
    });
  }
}



              