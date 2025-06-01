import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/api_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/features/settings/models/tree_levels/tree_level.dart';
import 'package:zcap_net_app/features/settings/models/tree_levels/tree_level_isar.dart';
import 'package:zcap_net_app/widgets/custom_list_view.dart';
import 'package:zcap_net_app/widgets/custom_form.dart';

class TreeLevelsScreenV2 extends StatefulWidget {
  const TreeLevelsScreenV2({super.key});

  @override
  State<TreeLevelsScreenV2> createState() => _TreeLevelsScreenStateV2();
}

class _TreeLevelsScreenStateV2 extends State<TreeLevelsScreenV2> {
  //final _formKey = GlobalKey<FormState>();
  final _levelIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  List<TreeLevelIsar> currentList = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();
  String _searchTerm = '';

  //final dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _loadTreeLevels();
  }

/*
----------------------START UI DESIGNS-----------------------
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nível de Arvore"),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              await treeLevelSyncService.synchronizeAll();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Sincronização manual completa')),
                );
                _loadTreeLevels();
              }
            },
          ),
        ],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
  final filteredList = currentList.where((e) {
    return e.name.toLowerCase().contains(_searchTerm);
  }).toList();

  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      children: [
        Row(
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
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        _isLoading
            ? const CircularProgressIndicator()
            : buildListView(
                filteredList,
                getLabelsList(filteredList),
                (treeLevel) {
                  treeLevelSyncService.sync(treeLevel);
                  _loadTreeLevels();
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
        'Nível: ${treeLevel.levelId}',
        'Atualizado a ${treeLevel.updatedAt}'
      ]);
    }
    return labelsList;
  }

  void _addOrEditTreeLevel(TreeLevelIsar? treeLevel) {
    if (treeLevel != null) {
      setState(() {
        _levelIdController.text = treeLevel.levelId.toString();
        _nameController.text = treeLevel.name;
        _descriptionController.text = treeLevel.description ?? '';
        _startDate = treeLevel.startDate;
        _endDate = treeLevel.endDate;
      });
    }
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return AlertDialog(
            title: Text(treeLevel == null ? 'Novo Nível' : 'Editar Nível'),
            content: buildForm(
                [_levelIdController, _nameController, _descriptionController],
                ['Nível', 'Nome', 'Descrição'],
                _startDate,
                _endDate, () async {
              final picked = await _selectDate(true);
              if (picked != null) {
                setState(() => _startDate = picked);
                setModalState(() {}); // Atualiza o dialog
              }
            }, () async {
              final picked = await _selectDate(false);
              if (picked != null) {
                setState(() => _endDate = picked);
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
                onPressed: () =>
                    {_saveTreeLevel(treeLevel), Navigator.pop(context)},
              ),
            ],
          );
        });
      },
    );
  }

/*
----------------------END UI DESIGNS-----------------------
*/

/*
----------------------START LOGIC FUNTIONS-----------------------
*/

  Future<void> _loadTreeLevels() async {
    List<TreeLevelIsar> localTreeLevels = await treeLevelIsarService.getAll();
    try {
      if (true /*await ApiService.ping()*/) {
        print("Loading tree levels...");
        final data = await ApiService.getList(
            'tree-levels', (json) => TreeLevel.fromJson(json));
        print("End Loading tree levels...");

        //delete all local data
        List<int> ids = localTreeLevels.map((e) => e.id).toList();
        await treeLevelIsarService.deleteAll(ids);
        localTreeLevels.clear();

        // Save to local database
        for (var treeLevel in data) {
          final newLocalTreeLevel = TreeLevelIsar.toRemote(treeLevel);
          await treeLevelIsarService.save(newLocalTreeLevel);
          localTreeLevels.add(newLocalTreeLevel);
        }
        setState(() {
          currentList = localTreeLevels;
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      currentList = localTreeLevels;
      _isLoading = false;
    });
  }

  Future<DateTime?> _selectDate(bool isStart) async {
    final initial =
        isStart ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2500),
    );
    return picked;
  }

  Future<void> _saveTreeLevel(TreeLevelIsar? treeLevel) async {
    TreeLevelIsar newTreeLevel;
    if (treeLevel == null) {
      newTreeLevel = TreeLevelIsar()
        ..entityId = 0
        ..levelId = int.parse(_levelIdController.text)
        ..name = _nameController.text
        ..description = _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null
        ..startDate = _startDate ?? DateTime.now()
        ..endDate = _endDate
        ..isSynced = false;
    } else {
      newTreeLevel = treeLevel.copyWith(
          levelId: int.parse(_levelIdController.text),
          name: _nameController.text,
          description: _descriptionController.text.isNotEmpty
              ? _descriptionController.text
              : null,
          startDate: _startDate,
          endDate: _endDate);
    }
    try {
      TreeLevel newApiTreeLevel = newTreeLevel.toEntity();
      final Map<String, dynamic> data;
      if (newTreeLevel.entityId == 0) {
        data =
            await ApiService.post("tree-levels", newApiTreeLevel.toJsonInput());
      } else {
        data = await ApiService.put("tree-levels/${newTreeLevel.entityId}",
            newApiTreeLevel.toJsonInput());
      }
      newTreeLevel.entityId = data['id'];
      newTreeLevel.isSynced = true;
    } catch (e) {
      newTreeLevel.isSynced = false;
      print(e);
    }

    await treeLevelIsarService.save(newTreeLevel);
    _clearForm();
    _loadTreeLevels();
  }

  void _clearForm() {
    setState(() {
      _levelIdController.clear();
      _nameController.clear();
      _descriptionController.clear();
      _startDate = null;
      _endDate = null;
    });
  }

/*
----------------------END LOGIC FUNTIONS-----------------------
*/
}
