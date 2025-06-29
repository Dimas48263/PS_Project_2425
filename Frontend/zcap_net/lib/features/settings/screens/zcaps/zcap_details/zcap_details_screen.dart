import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_detail_types/zcap_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_details/zcap_details_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcaps/zcap_isar.dart';
import 'package:zcap_net_app/shared/shared.dart';
import 'package:zcap_net_app/widgets/text_controllers_input_form.dart';

//TODO show just the detail types that the zcap doesnt have already?
class ZcapDetailsScreen extends StatefulWidget {
  const ZcapDetailsScreen({super.key});

  @override
  State<ZcapDetailsScreen> createState() => _ZcapDetailsScreenState();
}

class _ZcapDetailsScreenState extends State<ZcapDetailsScreen> {
  List<ZcapDetailsIsar> details = [];
  StreamSubscription? detailsStream;

  bool _isLoading = true;
  final _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    detailsStream = DatabaseService.db.zcapDetailsIsars
        .buildQuery<ZcapDetailsIsar>()
        .watch(fireImmediately: true)
        .listen((data) async {
      for (var item in data) {
        if (!item.zcap.isLoaded) await item.zcap.load();
        if (!item.zcapDetailType.isLoaded) await item.zcapDetailType.load();
      }
      setState(() {
        details = data;
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('screen_settings_zcap_building_details'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              await syncServiceV3.syncAllPending(
                  DatabaseService.db.zcapDetailsIsars,
                  'zcap-details',
                  'zcapDetailId');
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
              onAddPressed: () => _addOrEditDetail(null)),
          const SizedBox(height: 10.0),
          _isLoading
              ? const CircularProgressIndicator()
              : buildListView(
                  filteredList,
                  getLabelsList(filteredList),
                  (detail) {
                    syncServiceV3.synchronize(
                        detail,
                        DatabaseService.db.zcapDetailsIsars,
                        'zcap-details',
                        'zcapDetailId');
                  },
                  (detail) => _addOrEditDetail(detail),
                  (detail) async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        title: 'confirm_delete'.tr(),
                        content: 'confirm_delete_message'.tr(),
                      ),
                    );
                    if (confirm == true) {
                      await DatabaseService.db.writeTxn(() async {
                        await DatabaseService.db.zcapDetailsIsars
                            .delete(detail.id);
                      });
                    }
                  }),
        ],
      ),
    );
  }

  List<List<String>> getLabelsList(List<ZcapDetailsIsar> filteredList) {
    List<List<String>> labelsList = [];
    for (var detail in filteredList) {
      labelsList.add([
        '${'value'.tr()}: ${detail.valueCol}',
        'Zcap: ${detail.zcap.value!.name}',
        '${'screen_detail_type'.tr()}: ${detail.zcapDetailType.value!.name}',
        '${'start'.tr()}: ${detail.startDate.toLocal().toString().split(' ')[0]}',
        '${'end'.tr()}: ${detail.endDate?.toLocal().toString().split(' ')[0] ?? 'no_end_date'.tr()}'
      ]);
    }
    return labelsList;
  }

  void _addOrEditDetail(ZcapDetailsIsar? detail) async {
    final formKey = GlobalKey<FormState>();
    final valueController = TextEditingController(text: detail?.valueCol ?? '');
    ZcapIsar? zcap = detail?.zcap.value;
    ZcapDetailTypeIsar? zcapDetailType = detail?.zcapDetailType.value;
    DateTime? startDate = detail?.startDate ?? DateTime.now();
    DateTime? endDate = detail?.endDate;

    final availableZcaps = await DatabaseService.db.zcapIsars
        .filter()
        .startDateLessThan(DateTime.now())
        .and()
        .group((q) => q.endDateIsNull().or().endDateGreaterThan(DateTime.now()))
        .findAll();

    final availableZcapDetailTypes = await DatabaseService
        .db.zcapDetailTypeIsars
        .filter()
        .startDateLessThan(DateTime.now())
        .and()
        .group((q) => q.endDateIsNull().or().endDateGreaterThan(DateTime.now()))
        .findAll();

    List<TextControllersInputFormConfig> textControllersConfig = [
      TextControllersInputFormConfig(
          controller: valueController, label: 'value'.tr()),
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          final allowances = context.watch<UserAllowancesProvider>();

          return AlertDialog(
            title: Text(detail == null
                ? '${'new'.tr()} ${'detail'.tr()}'
                : '${'edit'.tr()} ${'detail'.tr()}'),
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
              customDropdownSearch<ZcapIsar>(
                  items: availableZcaps,
                  selectedItem: zcap,
                  onSelected: (ZcapIsar? value) {
                    setModalState(() {
                      zcap = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'required_field'.tr() : null,
                  label: 'zcap'.tr()),
              customDropdownSearch<ZcapDetailTypeIsar>(
                  items: availableZcapDetailTypes,
                  selectedItem: zcapDetailType,
                  onSelected: (ZcapDetailTypeIsar? value) {
                    setModalState(() {
                      zcapDetailType = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'required_field'.tr() : null,
                  label: 'screen_detail_type'.tr())
            ]),
            actions: [
              TextButton(
                child: Text(
                    allowances.canWrite('user_access_settings_detail_per_zcap')
                        ? 'cancel'.tr()
                        : 'close'.tr()),
                onPressed: () => Navigator.pop(context),
              ),
              if (allowances.canWrite('user_access_settings_detail_per_zcap'))
                TextButton(
                  child: Text('save'.tr()),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final navigator = Navigator.of(context);
                      final now = DateTime.now();
                      await DatabaseService.db.writeTxn(() async {
                        final newDetail = detail ?? ZcapDetailsIsar();
                        newDetail.remoteId = detail?.remoteId ?? 0;
                        newDetail.valueCol = valueController.text;
                        newDetail.zcap.value = zcap;
                        newDetail.zcapDetailType.value = zcapDetailType;
                        newDetail.startDate = startDate ?? now;
                        newDetail.endDate = endDate;
                        newDetail.createdAt = detail?.createdAt ?? now;
                        newDetail.lastUpdatedAt = now;
                        newDetail.isSynced = false;

                        await DatabaseService.db.zcapDetailsIsars
                            .put(newDetail);
                        await newDetail.zcap.save();
                        await newDetail.zcapDetailType.save();
                      });
                      navigator.pop();
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
