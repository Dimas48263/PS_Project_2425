import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/features/settings/models/tree_levels/tree_level_isar.dart';
import 'package:zcap_net_app/features/settings/models/tree_levels/tree_level.dart';
import 'package:zcap_net_app/shared/shared.dart';
import 'package:zcap_net_app/widgets/custom_list_view.dart';
import 'package:zcap_net_app/widgets/custom_form.dart';
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

  @override
  void initState() {
    super.initState();
    treeLevelsStream = DatabaseService.db.treeLevelIsars
        .buildQuery<TreeLevelIsar>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        treeLevels = data;
      });
    });
    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text.toLowerCase();
      });
    });

    _loadTreeLevels();
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
        title: const Text("Nível de Arvore"),
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
    final filteredList = treeLevels.where((e) {
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
              onAddPressed: () => _addOrEditTreeLevel(null)),
/*          Row(
            children: [
              // Campo de pesquisa expandido para ocupar o espaço disponível
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Pesquisar',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchTerm = value.toLowerCase();
                    });
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              // Botão adicionar ao lado
              ElevatedButton(
                onPressed: () => _addOrEditTreeLevel(null),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  minimumSize: Size(50.0, 50.0),
                ),
                child: const Icon(Icons.add),
              ),
            ],
          ),*/
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
                    print('update pressed');
                  },
                  (treeLevel) => _addOrEditTreeLevel(treeLevel),
                ),
        ],
      ),
    );
  }

  List<List<String>> getLabelsList(List<TreeLevelIsar> filteredList) {
    List<List<String>> labelsList = [];
    for (var treeLevel in filteredList) {
      labelsList.add([
        treeLevel.name,
        'Inicio: ${treeLevel.startDate}',
        'Fim: ${treeLevel.endDate}'
      ]);
    }
    return labelsList;
  }

  void _addOrEditTreeLevel(TreeLevelIsar? treeLevel) {
    final levelIdController =
        TextEditingController(text: treeLevel?.levelId.toString() ?? '');
    final nameController = TextEditingController(text: treeLevel?.name ?? '');
    final descriptionController =
        TextEditingController(text: treeLevel?.description ?? '');
    DateTime? startDate = treeLevel?.startDate ?? DateTime.now();
    DateTime? endDate = treeLevel?.endDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return AlertDialog(
            title: Text(treeLevel == null ? 'Novo Nível' : 'Editar Nível'),
            content: buildForm(
                [levelIdController, nameController, descriptionController],
                ['Nível', 'Nome', 'Descrição'],
                startDate,
                endDate, () async {
              final picked = await _selectDate(startDate);
              if (picked != null) {
                setState(() => startDate = picked);
                setModalState(() {}); // Atualiza o dialog
              }
            }, () async {
              final picked = await _selectDate(endDate);
              if (picked != null) {
                setState(() => endDate = picked);
                setModalState(() {}); // Atualiza o dialog
              }
            }),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('Guardar'),
                onPressed: () async {
                  if (levelIdController.text.isNotEmpty &&
                      nameController.text.isNotEmpty) {
                    final now = DateTime.now();
                    await DatabaseService.db.writeTxn(() async {
                      final newTreeLevel = treeLevel ?? TreeLevelIsar();
                      newTreeLevel.remoteId = treeLevel?.remoteId ?? 0;
                      newTreeLevel.levelId = int.parse(levelIdController.text);
                      newTreeLevel.name = nameController.text;
                      newTreeLevel.description = descriptionController.text;
                      newTreeLevel.startDate = startDate ?? now;
                      newTreeLevel.endDate = endDate;
                      newTreeLevel.isSynced = false;

                      await DatabaseService.db.treeLevelIsars.put(newTreeLevel);
                    });
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

  Future<DateTime?> _selectDate(DateTime? initial) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2500),
    );
    return picked;
  }

  Future<void> _loadTreeLevels() async {
    if (await syncServiceV3.isApiReachable()) {
      await syncServiceV3.updateLocalData(
          DatabaseService.db.treeLevelIsars,
          "tree-levels",
          TreeLevel.fromJson,
          (TreeLevel treeLevel) async => TreeLevelIsar.toRemote(treeLevel));
    }
    setState(() {
      _isLoading = false;
    });
  }
}
