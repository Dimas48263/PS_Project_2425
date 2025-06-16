import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/features/settings/models/text_controllers_input_form.dart';
import 'package:zcap_net_app/features/settings/models/tree_record_detail_types/tree_record_detail_type_isar.dart';
import 'package:zcap_net_app/shared/shared.dart';

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
                  (detailType) async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => const ConfirmDialog(
                        title: 'Confirmar eliminação',
                        content:
                            'Tem certeza que deseja eliminar este tipo de detalhe?',
                      ),
                    );
                    if (confirm == true) {
                      await DatabaseService.db.writeTxn(() async {
                        await DatabaseService.db.treeRecordDetailTypeIsars
                            .delete(detailType.id);
                      });
                    }
                  }),
        ],
      ),
    );
  }

  void _addOrEditTreerRecordDetailType(
      TreeRecordDetailTypeIsar? detailType) async {
    final formKey = GlobalKey<FormState>();
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
              CancelTextButton(),
              TextButton(
                child: const Text('Guardar'),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
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

  List<List<String>> getLabelsList(
      List<TreeRecordDetailTypeIsar> filteredList) {
    List<List<String>> labelsList = [];
    for (var detailType in filteredList) {
      labelsList.add([
        detailType.name,
        'Inicio: ${detailType.startDate.toLocal().toString().split(' ')[0]}',
        'Fim: ${detailType.endDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}'
      ]);
    }
    return labelsList;
  }
}
