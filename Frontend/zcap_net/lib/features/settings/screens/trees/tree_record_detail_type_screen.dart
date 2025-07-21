import 'dart:async';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/shared/data_types.dart';
import 'package:zcap_net_app/shared/models.dart';
import 'package:zcap_net_app/widgets/text_controllers_input_form.dart';
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

  late UserAllowancesProvider allowances;
  late bool canWrite;

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
    allowances = context.watch<UserAllowancesProvider>();
    canWrite = allowances.canWrite('user_access_settings_tree_detail_types');
    return Scaffold(
      appBar: AppBar(
        title: Text('screen_settings_detail_types'.tr()),
        actions: [SyncButton()],
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
              canWrite: canWrite,
              controller: _searchController,
              onSearchChanged: (value) => setState(() {
                    _searchTerm = value.toLowerCase();
                  }),
              onIconPressed: () => _addOrEditTreerRecordDetailType(null)),
          const SizedBox(height: 10.0),
          _isLoading
              ? const CircularProgressIndicator()
              : buildListView(
                  canWrite: canWrite,
                  filteredList,
                  getLabelsList(filteredList),
                  () async => await syncService.synchronizeAll(),
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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final availableTreeLevels = await isarDb.treeLevelIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();
    final treeLevelDetailType = await isarDb.treeLevelDetailTypeIsars
        .filter()
        .detailType((q) => q.idEqualTo(detailType?.id ?? 0))
        .findFirst();

    final nameController = TextEditingController(text: detailType?.name ?? '');
    DataTypes? unitController = detailType?.unit;
    TreeLevelIsar? treeLevelController = treeLevelDetailType?.treeLevel.value;
    DateTime startDate = detailType?.startDate ?? DateTime.now();
    DateTime? endDate = detailType?.endDate;

    List<TextControllersInputFormConfig> textControllersConfig = [
      TextControllersInputFormConfig(
          controller: nameController, label: 'name'.tr()),
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return AlertDialog(
            title: Text(detailType == null
                ? '${'new'.tr()} ${'screen_detail_type'.tr()}'
                : '${'edit'.tr()} ${'screen_detail_type'.tr()}'),
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
              customDropdownSearch(
                  enabled: canWrite,
                  itemLabelBuilder: (value) => value.label,
                  label: 'data_type'.tr(),
                  items: DataTypes.values.toList()
                    ..sort((a, b) => a.label.compareTo(b.label)),
                  selectedItem: unitController,
                  onSelected: (value) => setState(() => unitController = value),
                  validator: (value) =>
                      value == null ? 'required_field'.tr() : null),
              customDropdownSearch(
                  enabled: canWrite,
                  itemLabelBuilder: (value) => value.name,
                  label: 'level'.tr(),
                  items: availableTreeLevels,
                  selectedItem: treeLevelController,
                  onSelected: (value) =>
                      setState(() => treeLevelController = value),
                  validator: (value) =>
                      value == null ? 'required_field'.tr() : null),
            ], canWrite: canWrite),
            actions: [
              TextButton(
                child: Text(canWrite ? 'cancel'.tr() : 'close'.tr()),
                onPressed: () => Navigator.pop(context),
              ),
              if (canWrite)
                TextButton(
                  child: Text('save'.tr()),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final isValid = DateUtilsService().validateStartEndDate(
                        startDate: startDate,
                        endDate: endDate,
                        context: context,
                      );
                      if (!isValid) return;

                      await DatabaseService.db.writeTxn(() async {
                        final newDetailType =
                            detailType ?? TreeRecordDetailTypeIsar();
                        newDetailType.remoteId = detailType?.remoteId ?? 0;
                        newDetailType.name = nameController.text;
                        newDetailType.unit = unitController!;
                        newDetailType.startDate = startDate;
                        newDetailType.endDate = endDate;
                        newDetailType.isSynced = false;
                        await DatabaseService.db.treeRecordDetailTypeIsars
                            .put(newDetailType);

                        final newTreeLevelDetailType =
                            treeLevelDetailType ?? TreeLevelDetailTypeIsar();
                        newTreeLevelDetailType.remoteId =
                            treeLevelDetailType?.remoteId ?? 0;
                        newTreeLevelDetailType.detailType.value = newDetailType;
                        newTreeLevelDetailType.treeLevel.value =
                            treeLevelController!;
                        newTreeLevelDetailType.startDate = startDate;
                        newTreeLevelDetailType.endDate = endDate;
                        newTreeLevelDetailType.createdAt =
                            treeLevelDetailType?.createdAt ?? now;
                        newTreeLevelDetailType.lastUpdatedAt = now;
                        newTreeLevelDetailType.isSynced = false;
                        await DatabaseService.db.treeLevelDetailTypeIsars
                            .put(newTreeLevelDetailType);
                        await newTreeLevelDetailType.detailType.save();
                        await newTreeLevelDetailType.treeLevel.save();
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
