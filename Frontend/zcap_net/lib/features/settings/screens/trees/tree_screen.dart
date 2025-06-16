import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/features/settings/models/text_controllers_input_form.dart';
import 'package:zcap_net_app/features/settings/models/tree_levels/tree_level_isar.dart';
import 'dart:async';
import 'package:zcap_net_app/features/settings/models/trees/tree_isar.dart';
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

  @override
  void initState() {
    super.initState();
    treesStream = DatabaseService.db.treeIsars
        .buildQuery<TreeIsar>()
        .watch(fireImmediately: true)
        .listen((data) async {
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
        title: const Text("Árvores"),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              await syncServiceV3.syncAllPending(
                  DatabaseService.db.treeIsars, 'trees', 'treeRecordId');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Sincronização manual completa')),
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
      return e.name.toLowerCase().contains(_searchTerm);
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
                    print('update pressed');
                  },
                  (tree) => _addOrEditTree(tree),
                  (tree) async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => const ConfirmDialog(
                        title: 'Confirmar eliminação',
                        content:
                            'Tem certeza que deseja eliminar este elemento?',
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
        tree.name,
        'Inicio: ${tree.startDate.toLocal().toString().split(' ')[0]}',
        'Fim: ${tree.endDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}'
      ]);
    }
    return labelsList;
  }

  void _addOrEditTree(TreeIsar? tree) async {
    final formKey = GlobalKey<FormState>();
    if (tree != null) {
      if (!tree.treeLevel.isLoaded) await tree.treeLevel.load();
      if (!tree.parent.isLoaded) await tree.parent.load();
    }
    final availableTreeLevels =
        await DatabaseService.db.treeLevelIsars.where().findAll();
    final nameController = TextEditingController(text: tree?.name ?? '');
    TreeLevelIsar? treeLevel = tree?.treeLevel.value;
    TreeIsar? parent = tree?.parent.value;
    DateTime? startDate = tree?.startDate ?? DateTime.now();
    DateTime? endDate = tree?.endDate;

    List<TextControllersInputFormConfig> textControllersConfig = [
      TextControllersInputFormConfig(controller: nameController, label: 'Nome'),
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return AlertDialog(
            title: Text(tree == null ? 'Novo Elemento' : 'Editar Estrutura'),
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
                      value == null ? 'Campo obrigatório' : null),
              customDropdownSearch<TreeIsar>(
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
                  //TODO() ??
                },
              )
            ]),
            actions: [
              CancelTextButton(),
              TextButton(
                child: const Text('Guardar'),
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
