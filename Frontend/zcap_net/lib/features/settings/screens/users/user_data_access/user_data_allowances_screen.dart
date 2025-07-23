import 'dart:async';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_data_profiles/user_data_profile_allowance_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_data_profiles/user_data_profiles_isar.dart';
import 'package:zcap_net_app/shared/shared.dart';

class UserDataAllowancesScreen extends StatefulWidget {
  final UserDataProfilesIsar profile;

  const UserDataAllowancesScreen({super.key, required this.profile});

  @override
  State<UserDataAllowancesScreen> createState() =>
      _UserDataAllowancesScreenState();
}

class _UserDataAllowancesScreenState extends State<UserDataAllowancesScreen> {
  TreeNode<dynamic> root = TreeNode<dynamic>.root(data: 'tree_root'.tr());
  TreeViewController<dynamic, TreeNode<dynamic>>? _controller;

  Set<int> checkedTreeIds = {};

  String _searchTerm = '';
  final TextEditingController _searchController = TextEditingController();

  List<TreeIsar> allTreeRecords = [];
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = isarDb.treeIsars
        .buildQuery<TreeIsar>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        allTreeRecords = data;
      });
      buildTree();
    });
    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text.toLowerCase();
      });
      buildTree();
    });

    buildTree();
  }

  Future<void> buildTree() async {
    for (final t in allTreeRecords) {
      await t.parent.load();
    }

    final allowances = await isarDb.userDataProfileAllowanceIsars
        .filter()
        .localProfileIdEqualTo(widget.profile.id)
        .findAll();

    checkedTreeIds = allowances.map((a) => a.treeRecordId).toSet();

    LogService.log('Profile id: ${widget.profile.id}');
    LogService.log('Checked Ids: ${checkedTreeIds.join(', ')}');

    final Map<int, TreeIsar> treeMap = {
      for (var tree in allTreeRecords) tree.id: tree,
    };

    final roots = allTreeRecords.where((t) => t.parent.value == null);
    final rootNode = TreeNode<dynamic>.root(data: 'tree_root'.tr());

    for (var rootTree in roots) {
      final node = await buildTreeNode(rootTree, treeMap);
      if (node != null) {
        rootNode.add(node);
      }
    }

    setState(() {
      root = rootNode;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller?.expandAllChildren(root, recursive: true);
    });
  }

  Future<TreeNode<dynamic>?> buildTreeNode(
    TreeIsar tree,
    Map<int, TreeIsar> treeMap,
  ) async {
    final children =
        treeMap.values.where((t) => t.parent.value?.id == tree.id).toList();

    final List<TreeNode<dynamic>> matchingChildren = [];
    for (var child in children) {
      final childNode = await buildTreeNode(child, treeMap);
      if (childNode != null) {
        matchingChildren.add(childNode);
      }
    }

    final matchesSearch =
        _searchTerm.isEmpty || tree.name.toLowerCase().contains(_searchTerm);

    if (matchesSearch || matchingChildren.isNotEmpty) {
      final node = TreeNode<dynamic>(data: tree);
      for (var c in matchingChildren) {
        node.add(c);
      }
      return node;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('screen_data_alowances'.tr()),
        actions: [SyncButton()],
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
              onIconPressed: _saveAllowances,
              trailingIcon: Icons.save_outlined,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TreeView.simple(
                tree: root,
                onTreeReady: (controller) {
                  _controller = controller;
                  _controller?.expandAllChildren(root, recursive: true);
                },
                indentation: const Indentation(style: IndentStyle.squareJoint),
                showRootNode: false,
                expansionIndicatorBuilder: noExpansionIndicatorBuilder,
                builder: (context, node) {
                  final data = node.data;
                  if (data is TreeIsar) {
                    final isChecked = checkedTreeIds.contains(data.id);
                    return Row(
                      children: [
                        if (node.children.isNotEmpty)
                          ChevronIndicator.rightDown(tree: node),
                        Checkbox(
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              final treeId = data.id;
                              if (value == true) {
                                checkedTreeIds.add(treeId);
                                checkOrUnckeckAllChildren(treeId, true);
                              } else {
                                checkedTreeIds.remove(treeId);
                                checkOrUnckeckAllChildren(treeId, false);
                              }
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(data.name),
                        )
                      ],
                    );
                  } else if (data is String) {
                    return Text(data);
                  } else {
                    return Text('unknown'.tr());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void checkOrUnckeckAllChildren(int treeId, bool isCheck) {
    List<TreeIsar> list = allTreeRecords;
    for (var t in list) {
      if (t.parent.value?.id == treeId) {
        if (isCheck) {
          checkedTreeIds.add(t.id);
        }
        else {
          checkedTreeIds.remove(t.id);
        }
        checkOrUnckeckAllChildren(t.id, isCheck);
      }
    }
  }

  Future<void> _saveAllowances() async {
    try {
      final profileId = widget.profile.id;

      await isarDb.writeTxn(() async {
        await isarDb.userDataProfileAllowanceIsars
            .filter()
            .localProfileIdEqualTo(profileId)
            .deleteAll();

        final newAllowances = checkedTreeIds.map((treeId) {
          return UserDataProfileAllowanceIsar()
            ..localProfileId = profileId
            ..userDataProfileId = widget.profile.remoteId ?? -profileId
            ..treeRecordId = treeId
            ..isNew = true
            ..markedForDelete = false;
        }).toList();

        await isarDb.userDataProfileAllowanceIsars.putAll(newAllowances);

        final updatedProfile = widget.profile..isSynced = false;
        await isarDb.userDataProfilesIsars.put(updatedProfile);
      });

      if (mounted) {
        CustomOkSnackBar.show(context, 'success'.tr());
      }
    } catch (e, stack) {
      LogService.log('Erro ao gravar permissões: $e\n$stack');
      if (mounted) {
        CustomNOkSnackBar.show(
          context,
          'save_error'.tr(),
        );
      }
    }
  }
}
