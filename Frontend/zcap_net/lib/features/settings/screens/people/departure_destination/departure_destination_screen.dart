import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/features/settings/models/people/departure_destination/departure_destination_isar.dart';
import 'package:zcap_net_app/widgets/confirm_dialog.dart';
import 'package:zcap_net_app/widgets/custom_form.dart';
import 'package:zcap_net_app/widgets/custom_list_view.dart';
import 'package:zcap_net_app/widgets/custom_search_and_add_bar.dart';
import 'package:zcap_net_app/widgets/text_controllers_input_form.dart';

class DepartureDestinationScreen extends StatefulWidget {
  const DepartureDestinationScreen({super.key});

  @override
  State<DepartureDestinationScreen> createState() =>
      _DepartureDestinationScreenState();
}

class _DepartureDestinationScreenState
    extends State<DepartureDestinationScreen> {
  List<DepartureDestinationIsar> departureDestinations = [];
  StreamSubscription? departureDestinationStream;
  bool _isLoading = true;
  final _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    departureDestinationStream = DatabaseService.db.departureDestinationIsars
        .buildQuery<DepartureDestinationIsar>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        departureDestinations = data;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('screen_settings_departure_destinations'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              final success = await syncServiceV3.synchronizeAll();
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('service_sync_ok'.tr())),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('service_sync_error'.tr())),
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
    final filteredList = departureDestinations.where((e) {
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
              onAddPressed: () => _addOrEditDepartureDestination(null)),
          const SizedBox(height: 10.0),
          _isLoading
              ? const CircularProgressIndicator()
              : buildListView(
                  filteredList,
                  getLabelsList(filteredList),
                  () async => await syncServiceV3.synchronizeAll(),
                  (departureDestination) => _addOrEditDepartureDestination(departureDestination),
                  (departureDestination) async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        title: 'confirm_delete'.tr(),
                        content: 'confirm_delete_message'.tr(),
                      ),
                    );
                    if (confirm == true) {
                      await DatabaseService.db.writeTxn(() async {
                        await DatabaseService.db.departureDestinationIsars
                            .delete(departureDestination.id);
                      });
                    }
                  },
                ),
        ],
      ),
    );
  }

  List<List<String>> getLabelsList(List<DepartureDestinationIsar> filteredList) {
    List<List<String>> labelsList = [];
    for (var departureDestination in filteredList) {
      labelsList.add([
        '${'name'.tr()}: ${departureDestination.name}',
        '${'start'.tr()}: ${departureDestination.startDate.toLocal().toString().split(' ')[0]}',
        '${'end'.tr()}: ${departureDestination.endDate?.toLocal().toString().split(' ')[0] ?? 'no_end_date'.tr()}'
      ]);
    }
    return labelsList;
  }

  void _addOrEditDepartureDestination(DepartureDestinationIsar? departureDestination) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: departureDestination?.name ?? '');
    DateTime? startDate = departureDestination?.startDate ?? DateTime.now();
    DateTime? endDate = departureDestination?.endDate;

    List<TextControllersInputFormConfig> textControllersConfig = [
      TextControllersInputFormConfig(
          controller: nameController, label: 'name'.tr()),
    ];

    showDialog(
      context: context,
      builder: (context) {
        final allowances = context.watch<UserAllowancesProvider>();

        return StatefulBuilder(builder: (context, setModalState) {
          return AlertDialog(
            title: Text(departureDestination == null
                ? '${'new'.tr()} ${'destination'.tr()}'
                : '${'edit'.tr()} ${'destination'.tr()}'),
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
                child: Text(
                    allowances.canWrite('user_access_settings_people_departure_destinations')
                        ? 'cancel'.tr()
                        : 'close'.tr()),
                onPressed: () => Navigator.pop(context),
              ),
              if (allowances.canWrite('user_access_settings_people_departure_destinations'))
                TextButton(
                  child: Text('save'.tr()),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final now = DateTime.now();
                      await DatabaseService.db.writeTxn(() async {
                        final newDepartureDestination = departureDestination ?? DepartureDestinationIsar();
                        newDepartureDestination.remoteId = departureDestination?.remoteId ?? 0;
                        newDepartureDestination.name = nameController.text;
                        newDepartureDestination.startDate = startDate ?? now;
                        newDepartureDestination.endDate = endDate;
                        newDepartureDestination.isSynced = false;

                        await DatabaseService.db.departureDestinationIsars
                            .put(newDepartureDestination);
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
}
