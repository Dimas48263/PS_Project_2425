import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/data/app_date_provider.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities/entities_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/building_types/building_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/detail_type_categories/detail_type_categories_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_detail_types/zcap_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_details/zcap_details_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcaps/zcap_isar.dart';
import 'package:zcap_net_app/features/zcap_tree/tree_wrapper.dart';
import 'package:zcap_net_app/shared/shared.dart';
import 'package:zcap_net_app/widgets/custom_app_refrence_date_picker.dart';
import 'package:zcap_net_app/widgets/tree_item_picker.dart';

class ZcapTreeScreen extends StatefulWidget {
  const ZcapTreeScreen({super.key});

  @override
  State<ZcapTreeScreen> createState() => _ZcapTreeScreenState();
}

class _ZcapTreeScreenState extends State<ZcapTreeScreen> {
  TreeNode<dynamic> root = TreeNode<dynamic>.root(data: 'screen_zcaps'.tr());

  String _searchTerm = '';
  final TextEditingController _searchController = TextEditingController();
  DateTime? _currentReferenceDate;

  List<ZcapIsar> zcaps = [];
  List<ZcapDetailsIsar> allDetails = [];
  Map<int, List<ZcapDetailsIsar>> zcapDetailsByZcapId = {};

  StreamSubscription? zcapsStream;
  StreamSubscription? detailsStream;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text.toLowerCase();
      });
      buildTree();
    });

    zcapsStream = DatabaseService.db.zcapIsars
        .buildQuery<ZcapIsar>()
        .watch(fireImmediately: true)
        .listen((data) async {
      zcaps = data;
      await _loadZcapDetails();
      await buildTree();
    });

    detailsStream = DatabaseService.db.zcapDetailsIsars
        .buildQuery<ZcapDetailsIsar>()
        .watch(fireImmediately: true)
        .listen((data) async {
      allDetails = data;
      await _loadZcapDetails();
      await buildTree();
    });
  }

  Future<void> _loadZcapDetails() async {
    zcapDetailsByZcapId.clear();
    for (var detail in allDetails) {
      final zcapId = detail.zcap.value?.id;
      if (zcapId != null) {
        zcapDetailsByZcapId.putIfAbsent(zcapId, () => []).add(detail);
      }
    }
  }

  Future<void> buildTree() async {
    final referenceDate =
        context.read<AppReferenceDateProvider>();
    final isar = DatabaseService.db;

    for (final z in zcaps) {
      await z.tree.load();
      await z.tree.value?.parent.load();
    }

    final Map<int, List<ZcapIsar>> zcapsByTree = {};
    for (var z in zcaps) {
      //App reference date validation
      if (z.startDate.isAfter(referenceDate.endOfMonth) ||
          (z.endDate != null && z.endDate!.isBefore(referenceDate.startOfMonth))) {
        continue;
      }

      if (_searchTerm.isNotEmpty &&
          !z.name.toLowerCase().contains(_searchTerm)) {
        continue;
      }
      final treeId = z.tree.value?.id;
      if (treeId != null) {
        zcapsByTree.putIfAbsent(treeId, () => []).add(z);
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
    final rootNode = TreeNode<dynamic>.root(data: 'screen_zcaps'.tr());

    for (var rootTree in roots) {
      final node = await buildTreeNode(rootTree, zcapsByTree, treeMap);
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
    Map<int, List<ZcapIsar>> zcapsByTree,
    Map<int, TreeIsar> treeMap,
  ) async {
    final children =
        treeMap.values.where((t) => t.parent.value?.id == tree.id).toList();

    final zcaps = zcapsByTree[tree.id] ?? [];
    int totalZcaps = zcaps.length;

    final node = TreeNode<dynamic>(data: null);

    for (var child in children) {
      final childNode = await buildTreeNode(child, zcapsByTree, treeMap);
      node.add(childNode);

      if (childNode.data is TreeWrapper) {
        totalZcaps += (childNode.data as TreeWrapper).zcapCount;
      }
    }

    for (var z in zcaps) {
      node.add(TreeNode<dynamic>(data: z));
    }

    node.data = TreeWrapper(tree, totalZcaps);

    return node;
  }

  @override
  void dispose() {
    _searchController.dispose();
    zcapsStream?.cancel();
    detailsStream?.cancel();
    super.dispose();
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
        title: Text('screen_zcaps'.tr()),
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
              onAddPressed: () => _addOrEditZcap(context),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TreeView.simple(
                tree: root,
                expansionIndicatorBuilder: (context, node) =>
                    ChevronIndicator.rightDown(tree: node),
                indentation: const Indentation(
                  style: IndentStyle.squareJoint,
                ),
                builder: (context, node) {
                  final data = node.data;
                  final level = node.level;

                  final maxDepth = 12;
                  final t = (level / maxDepth).clamp(0.0, 1.0);
                  final bgColor = Color.lerp(AppColors.gradiantStartColor,
                      AppColors.gradiantEndColor, t);

                  // ZCAP
                  if (data is ZcapIsar) {
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(
                          '${(data.remoteId != null && data.remoteId! > 0) ? "[${data.remoteId}] " : ""}${data.name}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomLabelValueText(
                                    label: 'zcap_screen_buildingType'.tr(),
                                    value: data.buildingType.value?.name ?? '',
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomLabelValueText(
                                        label: 'screen_entity'.tr(),
                                        value:
                                            data.zcapEntity.value?.name ?? '',
                                      ),
                                      CustomLabelValueText(
                                        label: 'contact'.tr(),
                                        value:
                                            '${data.zcapEntity.value?.phone1 ?? ''}'
                                            '${(data.zcapEntity.value?.phone2?.isNotEmpty ?? false) ? ' \\ ${data.zcapEntity.value?.phone2}' : ''}',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
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
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (data.latitude != null && data.longitude != null)
                              CustomGMapsLocationButton(
                                latitude: data.latitude.toString(),
                                longitude: data.longitude.toString(),
                              ),
                            if (!data.isSynced) CustomUnsyncedIcon(),
                            IconButton(
                              onPressed: () {
                                _addOrEditZcap(context, zcap: data);
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
                                    await DatabaseService.db.zcapIsars
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
                  } else if (data is TreeWrapper) {
                    // Tree Level
                    if (data.zcapCount <= 0) {
                      return const SizedBox.shrink();
                    }
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
            ),
          ),
        ],
      ),
    );
  }
}

void _addOrEditZcap(BuildContext context, {ZcapIsar? zcap}) async {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final nameController = TextEditingController(text: zcap?.name ?? "");
  final addressController = TextEditingController(text: zcap?.address ?? "");
  final latitudeController =
      TextEditingController(text: zcap?.latitude?.toString() ?? '');
  final longitudeController =
      TextEditingController(text: zcap?.longitude?.toString() ?? '');
  BuildingTypesIsar? buildingType = zcap?.buildingType.value;
  EntitiesIsar? zcapEntity = zcap?.zcapEntity.value;
  TreeIsar? selectedTree = zcap?.tree.value;

  DateTime selectedStartDate = zcap?.startDate ?? DateTime.now();
  DateTime? selectedEndDate = zcap?.endDate;

  final availableBuildingTypes = await DatabaseService.db.buildingTypesIsars
      .filter()
      .startDateLessThan(today.add(const Duration(days: 1)))
      .and()
      .group((q) => q
          .endDateIsNull()
          .or()
          .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
      .findAll();

  final availableEntities = await DatabaseService.db.entitiesIsars
      .filter()
      .startDateLessThan(today.add(const Duration(days: 1)))
      .and()
      .group((q) => q
          .endDateIsNull()
          .or()
          .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
      .findAll();

  final availableCategories = await DatabaseService.db.detailTypeCategoriesIsars
      .filter()
      .startDateLessThan(today.add(const Duration(days: 1)))
      .and()
      .group((q) => q
          .endDateIsNull()
          .or()
          .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
      .findAll();

  final availableDetailTypes = await DatabaseService.db.zcapDetailTypeIsars
      .filter()
      .startDateLessThan(today.add(const Duration(days: 1)))
      .and()
      .group((q) => q
          .endDateIsNull()
          .or()
          .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
      .findAll();

  List<ZcapDetailsIsar> zcapDetails = [];
  if (zcap != null) {
    zcapDetails = await DatabaseService.db.zcapDetailsIsars
        .filter()
        .zcap((q) => q.idEqualTo(zcap.id))
        .findAll();
  }

  Map<ZcapDetailTypeIsar, ZcapDetailsIsar?> zcapDetailsMap = {};

  for (var availableDetailType in availableDetailTypes) {
    ZcapDetailsIsar? search;
    try {
      search = zcapDetails.firstWhere((element) =>
          element.zcapDetailType.value!.id == availableDetailType.id);
    } catch (e) {
      search = null;
    }
    zcapDetailsMap[availableDetailType] = search;
  }

  final formKey = GlobalKey<FormState>();
  final detailsFormKey = GlobalKey<FormState>();

  showDialog(
      context: context,
      builder: (context) {
        bool detailsFormValidated = false;
        bool showDetailsError = false;
        return StatefulBuilder(
          builder: (buiderContext, setModalState) {
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
                        decoration:
                            InputDecoration(labelText: 'screen_zcap_name'.tr()),
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
                      DropdownSearch<EntitiesIsar>(
                        selectedItem: zcapEntity,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              labelText:
                                  '${'search'.tr()} ${'screen_entity'.tr()}',
                            ),
                          ),
                        ),
                        itemAsString: (EntitiesIsar? e) => e?.name ?? '',
                        items: availableEntities,
                        onChanged: (EntitiesIsar? value) {
                          setModalState(() {
                            zcapEntity = value;
                          });
                        },
                        validator: (EntitiesIsar? value) {
                          if (value == null) {
                            return 'required_field'.tr();
                          }
                          return null;
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'screen_entity'.tr(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      DropdownSearch<BuildingTypesIsar>(
                        selectedItem: buildingType,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              labelText:
                                  '${'search'.tr()} ${'zcap_screen_buildingType'.tr()}',
                            ),
                          ),
                        ),
                        itemAsString: (BuildingTypesIsar? e) => e?.name ?? '',
                        items: availableBuildingTypes,
                        onChanged: (BuildingTypesIsar? value) {
                          setModalState(() {
                            buildingType = value;
                          });
                        },
                        validator: (BuildingTypesIsar? value) {
                          if (value == null) {
                            return 'required_field'.tr();
                          }
                          return null;
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'zcap_screen_buildingType'.tr(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      TreeItemPicker(
                        initialTree: selectedTree,
                        onChanged: (tree) {
                          setModalState(() {
                            selectedTree = tree;
                          });
                        },
                      ),
                      const SizedBox(height: 12.0),
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                            labelText: 'zcap_screen_address'.tr()),
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
                      CustomLocationInputField(
                        latitudeController: latitudeController,
                        longitudeController: longitudeController,
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
                      const SizedBox(
                        height: 12.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            //centrar,
                            onPressed: () {
                              showDetails(
                                context,
                                availableCategories,
                                detailsFormKey,
                                zcapDetailsMap,
                                onValidated: () {
                                  setModalState(() {
                                    detailsFormValidated = true;
                                    showDetailsError = false;
                                  });
                                },
                              );
                            },
                            child: Text('open_details'.tr()),
                          ),
                        ],
                      ),
                      if (showDetailsError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'fill_mandatory_details_error'.tr(),
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
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
                      if (!detailsFormValidated) {
                        setModalState(() {
                          showDetailsError = true;
                        });
                        return;
                      }
                      final now = DateTime.now();
                      final navigator = Navigator.of(context);

                      final editedZcap = zcap ?? ZcapIsar();

                      editedZcap.name = nameController.text.trim();
                      editedZcap.address = addressController.text.trim();
                      editedZcap.buildingType.value = buildingType;
                      editedZcap.zcapEntity.value = zcapEntity;
                      editedZcap.latitude =
                          double.tryParse(latitudeController.text);
                      editedZcap.longitude =
                          double.tryParse(longitudeController.text);
                      editedZcap.tree.value = selectedTree;
                      editedZcap.startDate = selectedStartDate;
                      editedZcap.endDate = selectedEndDate;
                      editedZcap.lastUpdatedAt = now;
                      editedZcap.isSynced = false;
                      if (zcap == null) {
                        editedZcap.createdAt = now;
                      }
                      DatabaseService.db.writeTxn(() async {
                        await DatabaseService.db.zcapIsars.put(editedZcap);
                        await editedZcap.buildingType.save();
                        await editedZcap.zcapEntity.save();
                        await editedZcap.tree.save();
                        for (var m in zcapDetailsMap.keys) {
                          final detail = zcapDetailsMap[m];
                          if (detail != null) {
                            detail.zcap.value = editedZcap;
                            await DatabaseService.db.zcapDetailsIsars
                                .put(detail);
                            await detail.zcap.save();
                            await detail.zcapDetailType.save();
                          }
                        }
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

Future<void> showDetails(
    BuildContext context,
    List<DetailTypeCategoriesIsar> categories,
    GlobalKey<FormState> formKey,
    Map<ZcapDetailTypeIsar, ZcapDetailsIsar?> typeDetailMap,
    {VoidCallback? onValidated}) async {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  final form = await detailsForm(
    categories,
    () => overlayEntry.remove(),
    formKey,
    context,
    typeDetailMap,
    onValidated: onValidated,
  );
  overlayEntry = OverlayEntry(
    builder: (context) => GestureDetector(
      onTap: () => overlayEntry.remove(),
      child: Material(
        color: Colors.black54,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Impede fechar ao clicar no form
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  form /*_DetailsForm(
                  category: category,
                  onClose: () => overlayEntry.remove(),
                )*/
              ,
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
}

bool validateValue(String type, String value) {
  switch (type) {
    case 'string':
      if (value.isEmpty) return false;
      return true;
    case 'int':
      return int.tryParse(value) != null;
    case 'double':
      return double.tryParse(value) != null;
    case 'boolean':
      return value == '0' || value == '1';
    case 'char':
      return value.length == 1;
    case 'float':
      return double.tryParse(value) != null;
    default:
      return true;
  }
}

Future<Widget> detailsForm(
    List<DetailTypeCategoriesIsar> categories,
    VoidCallback onClose,
    GlobalKey<FormState> formKey,
    BuildContext context,
    Map<ZcapDetailTypeIsar, ZcapDetailsIsar?> typeDetailMap,
    {VoidCallback? onValidated}) async {
  Map<DetailTypeCategoriesIsar, List<ZcapDetailTypeIsar>> detailsByCategory =
      {};

  final detailTypeKeys = typeDetailMap.keys.toList();

  final Map<int, TextEditingController> detailControllers = {};

  for (var detailType in detailTypeKeys) {
    final existingDetail = typeDetailMap[detailType];

    detailControllers[detailType.id] = TextEditingController(
      text: existingDetail?.valueCol ?? '',
    );
  }
  for (var category in categories) {
    final detailTypes = detailTypeKeys.where((e) {
      return e.detailTypeCategory.value!.id == category.id;
    }).toList();
    detailsByCategory[category] = detailTypes;
  }
  return Form(
    key: formKey,
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('edit_detail'.tr(),
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          for (int i = 0; i < categories.length; i++)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                if (i > 0) const Divider(),
                const SizedBox(height: 10),
                Text(categories[i].name,
                    style: Theme.of(context).textTheme.titleSmall),
                for (var detailType in detailsByCategory[categories[i]]!)
                  Column(
                    children: [
                      detailType.dataType.name != 'boolean'
                          ? TextFormField(
                              controller: detailControllers[detailType.id],
                              decoration: InputDecoration(
                                labelText: detailType.isMandatory
                                    ? '${detailType.name}*'
                                    : detailType.name,
                                hintText:
                                    "${'example_abbreviation'.tr()} ${detailType.dataType.example}",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              validator: (value) {
                                if (!detailType.isMandatory) {
                                  if (value != null && value.isNotEmpty) {
                                    if (validateValue(
                                        detailType.dataType.name, value)) {
                                      return null;
                                    } else {
                                      return 'wrong_format'.tr();
                                    }
                                  }
                                  return null;
                                } else {
                                  if (value == null || value.isEmpty) {
                                    return 'required_field'.tr();
                                  }
                                  if (validateValue(
                                      detailType.dataType.name, value)) {
                                    return null;
                                  }
                                  return 'wrong_format'.tr();
                                }
                              })
                          : FormField<bool>(
                              initialValue:
                                  detailControllers[detailType.id]?.text != ''
                                      ? detailControllers[detailType.id]
                                              ?.text ==
                                          '1'
                                      : null,
                              validator: (value) {
                                if (detailType.isMandatory && value == null) {
                                  return 'required_field'.tr();
                                }
                                return null;
                              },
                              builder: (field) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(detailType.isMandatory
                                        ? '${detailType.name}*'
                                        : detailType.name),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: field.value == true,
                                          onChanged: (val) {
                                            final newValue = field.value == true
                                                ? null
                                                : true;
                                            field.didChange(newValue);
                                            detailControllers[detailType.id]!
                                                    .text =
                                                newValue != null ? '1' : '';
                                          },
                                        ),
                                        Text("true".tr()),
                                        const SizedBox(width: 20),
                                        Checkbox(
                                          value: field.value == false,
                                          onChanged: (val) {
                                            final newValue =
                                                field.value == false
                                                    ? null
                                                    : false;
                                            field.didChange(newValue);
                                            detailControllers[detailType.id]!
                                                    .text =
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
                            ),
                      const SizedBox(height: 10),
                    ],
                  ),
              ],
            ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onClose,
                  child: Text('cancel'.tr()),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      for (var detailType in detailTypeKeys) {
                        final controller = detailControllers[detailType.id];
                        final detail = typeDetailMap[detailType];
                        if (detail == null) {
                          typeDetailMap[detailType] = ZcapDetailsIsar()
                            ..isSynced = false
                            ..remoteId = 0
                            ..valueCol = controller?.text ?? ''
                            ..zcapDetailType.value = detailType
                            ..startDate = DateTime.now()
                            ..createdAt = DateTime.now()
                            ..lastUpdatedAt = DateTime.now();
                        } else {
                          if (detail.valueCol != controller?.text) {
                            typeDetailMap[detailType] = ZcapDetailsIsar()
                              ..isSynced = false
                              ..remoteId = detail.remoteId
                              ..valueCol = controller?.text ?? ''
                              ..zcapDetailType.value = detailType
                              ..startDate = DateTime.now()
                              ..createdAt = DateTime.now()
                              ..lastUpdatedAt = DateTime.now();
                          }
                        }
                      }
                      onValidated?.call();
                      onClose();
                    }
                  },
                  child: Text('save'.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
