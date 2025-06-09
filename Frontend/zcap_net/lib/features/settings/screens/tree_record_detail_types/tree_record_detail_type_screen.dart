import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/features/settings/models/text_controllers_input_form.dart';
import 'package:zcap_net_app/features/settings/models/tree_record_detail_types/tree_record_detail_type.dart';
import 'package:zcap_net_app/features/settings/models/tree_record_detail_types/tree_record_detail_type_isar.dart';
import 'package:zcap_net_app/shared/shared.dart';
import 'package:zcap_net_app/widgets/custom_cancel_text_button.dart';
import 'package:zcap_net_app/widgets/custom_form.dart';
import 'package:zcap_net_app/widgets/custom_list_view.dart';
import 'package:zcap_net_app/widgets/custom_search_bar.dart';

class TreeRecordDetailTypesScreen extends StatefulWidget {
  const TreeRecordDetailTypesScreen({super.key});

  @override
  State<TreeRecordDetailTypesScreen> createState() =>
      _TreeRecordDetailTypesScreenState();
}

class _TreeRecordDetailTypesScreenState
    extends State<TreeRecordDetailTypesScreen> {
  List<TreeRecordDetailTypeIsar> treeRecordDetailTypes = [];
  StreamSubscription? detailsStream;

  bool _isLoading = true;
  final _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    detailsStream = DatabaseService.db.treeRecordDetailTypeIsars
        .buildQuery<TreeRecordDetailTypeIsar>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        treeRecordDetailTypes = data;
      });
    });
    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text.toLowerCase();
      });
    });

    _loadDetails();
  }

  @override
  void dispose() {
    detailsStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tipos de Detalhe"),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              await syncServiceV3.syncAllPending(
                  DatabaseService.db.treeRecordDetailTypeIsars,
                  'tree-record-detail-types',
                  'detailTypeId');
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
    final filteredList = treeRecordDetailTypes.where((e) {
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
              onAddPressed: () => _addOrEditTreerRecordDetailType(null)),
/*          Row(
            children: [
              customSearchBar(
                  _searchController,
                  (value) => setState(() {
                        _searchTerm = value.toLowerCase();
                      })),
              // Campo de pesquisa expandido para ocupar o espaço disponível
              const SizedBox(width: 8.0),
              // Botão adicionar ao lado
              ElevatedButton(
                onPressed: () => _addOrEditTreerRecordDetailType(null),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
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
                  (detailType) {
                    syncServiceV3.synchronize(
                        detailType,
                        DatabaseService.db.treeRecordDetailTypeIsars,
                        'tree-record-detail-types',
                        'detailTypeId');
                    print('update pressed');
                  },
                  (detailType) => _addOrEditTreerRecordDetailType(detailType),
                ),
        ],
      ),
    );
  }

  void _addOrEditTreerRecordDetailType(
      TreeRecordDetailTypeIsar? detailType) async {
    final nameController = TextEditingController(text: detailType?.name ?? '');
    final unitController = TextEditingController(text: detailType?.unit ?? '');
    DateTime? startDate = detailType?.startDate ?? DateTime.now();
    DateTime? endDate = detailType?.endDate;

    List<TextControllersInputFormConfig> textControllersConfig = [
      TextControllersInputFormConfig(controller: nameController, label: 'Nome'),
      TextControllersInputFormConfig(
          controller: unitController, label: 'Unidade'),
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return AlertDialog(
            title:
                Text(detailType == null ? 'Novo Elemento' : 'Editar Estrutura'),
            content: buildForm2(
                context, textControllersConfig, startDate, endDate, (value) {
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
              CancelTextButton(),
              TextButton(
                child: const Text('Guardar'),
                onPressed: () async {
                  if (nameController.text.isNotEmpty &&
                      unitController.text.isNotEmpty) {
                    final now = DateTime.now();
                    await DatabaseService.db.writeTxn(() async {
                      final newDetailType =
                          detailType ?? TreeRecordDetailTypeIsar();
                      newDetailType.remoteId = detailType?.remoteId ?? 0;
                      newDetailType.name = nameController.text;
                      newDetailType.unit = unitController.text;
                      newDetailType.startDate = startDate ?? now;
                      newDetailType.endDate = endDate;
                      newDetailType.isSynced = false;
                      await DatabaseService.db.treeRecordDetailTypeIsars
                          .put(newDetailType);
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

  Future<void> _loadDetails() async {
    if (await syncServiceV3.isApiReachable()) {
      await syncServiceV3
          .updateLocalData<TreeRecordDetailTypeIsar, TreeRecordDetailType>(
              DatabaseService.db.treeRecordDetailTypeIsars,
              "tree-record-detail-types",
              TreeRecordDetailType.fromJson,
              (tree) async => TreeRecordDetailTypeIsar.toRemote(tree));
    }
    setState(() {
      _isLoading = false;
    });
  }

  List<List<String>> getLabelsList(
      List<TreeRecordDetailTypeIsar> filteredList) {
    List<List<String>> labelsList = [];
    for (var detailType in filteredList) {
      labelsList.add([
        detailType.name,
        'Inicio: ${detailType.startDate}',
        'Fim: ${detailType.endDate}'
      ]);
    }
    return labelsList;
  }
}
