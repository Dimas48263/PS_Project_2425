import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/widgets/text_controllers_input_form.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_detail_types/tree_record_detail_type_isar.dart';
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
        title: Text('screen_settings_detail_types'.tr()),
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
                  SnackBar(content: Text('service_sync_ok'.tr())),
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
                  },
                  (detailType) => _addOrEditTreerRecordDetailType(detailType),
                  (detailType) async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        title: 'confirm_delete'.tr(),
                        content: 'confirm_delete_message'.tr(),
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
      TextControllersInputFormConfig(
          controller: nameController, label: 'name'.tr()),
      TextControllersInputFormConfig(
          controller: unitController, label: 'unit'.tr()),
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          final allowances = context.watch<UserAllowancesProvider>();

          return AlertDialog(
            title: Text(detailType == null
                ? '${'new'.tr()} ${'tree_element'.tr()}'
                : '${'edit'.tr()} ${'screen_settings_structure'.tr()}'),
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
              TextButton(
                child: Text(allowances
                        .canWrite('user_access_settings_tree_detail_types')
                    ? 'cancel'.tr()
                    : 'close'.tr()),
                onPressed: () => Navigator.pop(context),
              ),
              if (allowances.canWrite('user_access_settings_tree_detail_types'))
                TextButton(
                  child: Text('save'.tr()),
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
        '${'start'.tr()}: ${detailType.startDate.toLocal().toString().split(' ')[0]}',
        '${'end'.tr()}: ${detailType.endDate?.toLocal().toString().split(' ')[0] ?? 'no_end_date'.tr()}'
      ]);
    }
    return labelsList;
  }
}
