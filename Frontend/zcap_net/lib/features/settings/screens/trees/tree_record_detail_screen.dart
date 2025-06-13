import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/features/settings/models/text_controllers_input_form.dart';
import 'package:zcap_net_app/features/settings/models/tree_record_detail_types/tree_record_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/tree_record_details/tree_record_detail.dart';
import 'package:zcap_net_app/features/settings/models/tree_record_details/tree_record_detail_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_isar.dart';
import 'package:zcap_net_app/widgets/confirm_dialog.dart';
import 'package:zcap_net_app/widgets/custom_cancel_text_button.dart';
import 'package:zcap_net_app/widgets/custom_dropdown_search.dart';
import 'package:zcap_net_app/widgets/custom_form.dart';
import 'package:zcap_net_app/widgets/custom_list_view.dart';
import 'package:zcap_net_app/widgets/custom_search_and_add_bar.dart';

class TreeRecordDetailsScreen extends StatefulWidget {
  const TreeRecordDetailsScreen({super.key});

  @override
  State<TreeRecordDetailsScreen> createState() =>
      _TreeRecordDetailsScreenState();
}

class _TreeRecordDetailsScreenState extends State<TreeRecordDetailsScreen> {
  List<TreeRecordDetailIsar> details = [];
  StreamSubscription? detailsStream;

  bool _isLoading = true;
  final _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    detailsStream = DatabaseService.db.treeRecordDetailIsars
        .buildQuery<TreeRecordDetailIsar>()
        .watch(fireImmediately: true)
        .listen((data) async {
      setState(() {
        details = data;
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
                  DatabaseService.db.treeRecordDetailIsars,
                  'tree-record-details',
                  'detailId');
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
    final filteredList = details.where((e) {
      return e.valueCol.toLowerCase().contains(_searchTerm);
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
            onAddPressed: () => _addOrEditDetail(null),
          ),
          const SizedBox(height: 10.0),
          _isLoading
              ? const CircularProgressIndicator()
              : buildListView(
                  filteredList,
                  getLabelsList(filteredList),
                  (detail) {
                    syncServiceV3.synchronize(
                        detail,
                        DatabaseService.db.treeRecordDetailIsars,
                        'tree-record-details',
                        'detailId');
                    print('update pressed');
                  },
                  (detail) => _addOrEditDetail(detail),
                  (detail) async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => const ConfirmDialog(
                        title: 'Confirmar eliminação',
                        content:
                            'Tem certeza que deseja eliminar este detalhe?',
                      ),
                    );
                    if (confirm == true) {
                      await DatabaseService.db.writeTxn(() async {
                        await DatabaseService.db.treeRecordDetailIsars
                            .delete(detail.id);
                      });
                    }
                  },
                ),
        ],
      ),
    );
  }

  List<List<String>> getLabelsList(List<TreeRecordDetailIsar> filteredList) {
    List<List<String>> labelsList = [];
    for (var tree in filteredList) {
      labelsList.add([
        'Valor: ${tree.valueCol}',
        'Inicio: ${tree.startDate.toLocal().toString().split(' ')[0]}',
        'Fim: ${tree.endDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}'
      ]);
    }
    return labelsList;
  }

  void _addOrEditDetail(TreeRecordDetailIsar? detail) async {
    final formKey = GlobalKey<FormState>();
    if (detail != null) {
      if (!detail.detailType.isLoaded) await detail.detailType.load();
      if (!detail.tree.isLoaded) await detail.tree.load();
    }
    final availableTrees = await DatabaseService.db.treeIsars.where().findAll();

    final availableDetailTypes = await DatabaseService.db.treeRecordDetailTypeIsars.where().findAll();

    final valueController = TextEditingController(text: detail?.valueCol ?? '');
    TreeIsar? tree = detail?.tree.value;
    TreeRecordDetailTypeIsar? detailType = detail?.detailType.value;
    DateTime? startDate = detail?.startDate ?? DateTime.now();
    DateTime? endDate = detail?.endDate;

    List<TextControllersInputFormConfig> textControllersConfig = [
      TextControllersInputFormConfig(controller: valueController, label: 'Valor'),
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return AlertDialog(
            title: Text(detail == null ? 'Novo Detalhe' : 'Editar Detalhe'),
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
              customDropdownSearch<TreeRecordDetailTypeIsar>(
                  items: availableDetailTypes,
                  selectedItem: detailType,
                  onSelected: (TreeRecordDetailTypeIsar? value) {
                    setModalState(() {
                      detailType = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Campo obrigatório' : null),
              customDropdownSearch<TreeIsar>(
                items: availableTrees,
                selectedItem: tree,
                onSelected: (TreeIsar? value) {
                  setModalState(() {
                    tree = value;
                  });
                },
                validator: (value) =>
                      value == null ? 'Campo obrigatório' : null),
            ]),
            actions: [
              CancelTextButton(),
              TextButton(
                child: const Text('Guardar'),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final now = DateTime.now();
                    await DatabaseService.db.writeTxn(() async {
                      final newDetail = detail ?? TreeRecordDetailIsar();
                      newDetail.remoteId = detail?.remoteId ?? 0;
                      newDetail.valueCol = valueController.text;
                      newDetail.detailType.value = detailType;
                      newDetail.tree.value = tree;
                      newDetail.startDate = startDate ?? now;
                      newDetail.endDate = endDate;
                      newDetail.isSynced = false;
                      await DatabaseService.db.treeRecordDetailIsars.put(newDetail);
                      await newDetail.detailType.save();
                      await newDetail.tree.save();
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
          .updateLocalData<TreeRecordDetailIsar, TreeRecordDetail>(
        DatabaseService.db.treeRecordDetailIsars,
        "tree-record-details",
        TreeRecordDetail.fromJson,
        (detail) async => TreeRecordDetailIsar.toRemote(detail),
        (collection, remoteId) =>
            collection.where().remoteIdEqualTo(remoteId).findFirst(),
        saveLinksAfterPut: (detail) async {
          await detail.detailType.save();
          await detail.tree.save();
        },
      );
    }
    setState(() {
      _isLoading = false;
    });
  }
}
