import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_levels/tree_level_isar.dart';

class TreeItemPicker extends StatefulWidget {
  final TreeIsar? initialTree;
  final Function(TreeIsar?) onChanged;
  final bool canWrite;

  const TreeItemPicker({
    super.key,
    this.initialTree,
    required this.onChanged,
    this.canWrite = true,
  });

  @override
  State<TreeItemPicker> createState() => _TreeItemPickerState();
}

class _TreeItemPickerState extends State<TreeItemPicker> {
  TreeLevelIsar? selectedTreeLevel;
  TreeIsar? selectedTreeItem;
  List<TreeLevelIsar> availableTreeLevels = [];
  List<TreeIsar> availableTreeItems = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final today = DateTime.now();
    availableTreeLevels = await isarDb.treeLevelIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();

    if (widget.initialTree != null) {
      selectedTreeItem = widget.initialTree;
      selectedTreeLevel = selectedTreeItem!.treeLevel.value;

      availableTreeItems = await isarDb.treeIsars
          .filter()
          .treeLevel((q) => q.idEqualTo(selectedTreeLevel!.id))
          .and()
          .startDateLessThan(today.add(const Duration(days: 1)))
          .and()
          .group((q) => q
              .endDateIsNull()
              .or()
              .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
          .findAll();
    }

    setState(() {});
  }

  Future<void> _onLevelChanged(TreeLevelIsar? level) async {
    final today = DateTime.now();
    selectedTreeLevel = level;
    selectedTreeItem = null;
    widget.onChanged(null);

    if (level != null) {
      availableTreeItems = await isarDb.treeIsars
          .filter()
          .treeLevel((q) => q.idEqualTo(level.id))
          .and()
          .startDateLessThan(today.add(const Duration(days: 1)))
          .and()
          .group((q) => q
              .endDateIsNull()
              .or()
              .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
          .findAll();
    } else {
      availableTreeItems = [];
    }

    setState(() {});
  }

  void _onTreeChanged(TreeIsar? tree) {
    selectedTreeItem = tree;
    widget.onChanged(tree);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownSearch<TreeLevelIsar>(
            enabled: widget.canWrite,
            selectedItem: selectedTreeLevel,
            popupProps: PopupProps.menu(showSearchBox: true),
            itemAsString: (t) => t.name,
            items: availableTreeLevels,
            onChanged: _onLevelChanged,
            validator: (TreeLevelIsar? value) {
              if (value == null) {
                return 'required_field'.tr();
              }
              return null;
            },
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: 'tree_level'.tr(),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6.0),
        if (availableTreeItems.isNotEmpty)
          Expanded(
            child: DropdownSearch<TreeIsar>(
              enabled: widget.canWrite,
              selectedItem: selectedTreeItem,
              popupProps: PopupProps.menu(showSearchBox: true),
              itemAsString: (t) => t.name,
              items: availableTreeItems,
              onChanged: _onTreeChanged,
              validator: (TreeIsar? value) {
                if (value == null) {
                  return 'required_field'.tr();
                }
                return null;
              },
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: 'tree'.tr(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
