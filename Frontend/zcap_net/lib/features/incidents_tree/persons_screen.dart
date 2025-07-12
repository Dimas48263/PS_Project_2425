import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_zcap_persons/incident_zcap_persons_isar.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_zcaps/incident_zcaps_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/departure_destination/departure_destination_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/persons/persons_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_levels/tree_level_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_detail_types/tree_record_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_details/tree_record_detail_isar.dart';
import 'package:zcap_net_app/widgets/confirm_dialog.dart';
import 'package:zcap_net_app/widgets/custom_dropdown_search.dart';
import 'package:zcap_net_app/widgets/custom_form.dart';
import 'package:zcap_net_app/widgets/custom_list_view.dart';
import 'package:zcap_net_app/widgets/custom_search_and_add_bar.dart';
import 'package:zcap_net_app/widgets/text_controllers_input_form.dart';

class PersonsScreen extends StatefulWidget {
  final IncidentZcapsIsar incidentZcapIsar;
  const PersonsScreen({super.key, required this.incidentZcapIsar});

  @override
  State<PersonsScreen> createState() => _PersonsScreenState();
}

class _PersonsScreenState extends State<PersonsScreen> {
  late IncidentZcapsIsar incidentZcapIsar;
  List<PersonsIsar> persons = [];
  StreamSubscription? personsStream;

  bool _isLoading = true;
  final _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    incidentZcapIsar = widget.incidentZcapIsar;

    personsStream = DatabaseService.db.personsIsars
        .buildQuery<PersonsIsar>()
        .watch(fireImmediately: true)
        .listen((data) async {
      for (var element in data) {
        if (!element.countryCode.isLoaded) await element.countryCode.load();
        if (!element.placeOfResidence.isLoaded) {
          await element.placeOfResidence.load();
        }
        if (!element.nationality.isLoaded) await element.nationality.load();
        if (!element.departureDestination.isLoaded) {
          await element.departureDestination.load();
        }
      }
      setState(() {
        persons = data;
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
    personsStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('screen_settings_people'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              final success = await syncService.synchronizeAll();
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
    final filteredList = persons.where((e) {
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
            onAddPressed: () {
              _addOrEditPerson(null);
            },
          ),
          const SizedBox(height: 10.0),
          _isLoading
              ? const CircularProgressIndicator()
              : buildListView(
                  filteredList,
                  getLabelsList(filteredList),
                  () async => await syncService.synchronizeAll(),
                  (person) {
                    _addOrEditPerson(person);
                  }, 
                  (person) async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        title: 'confirm_delete'.tr(),
                        content: 'confirm_delete_message'.tr(),
                      ),
                    );
                    if (confirm == true) {
                      await DatabaseService.db.writeTxn(() async {
                        await DatabaseService.db.personsIsars.delete(person.id);
                      });
                    }
                  },
                ),
        ],
      ),
    );
  }

  List<List<String>> getLabelsList(List<PersonsIsar> filteredList) {
    List<List<String>> labelsList = [];
    for (var person in filteredList) {
      labelsList.add([
        '${'name'.tr()}: ${person.name}',
      ]);
    }
    return labelsList;
  }

  void _addOrEditPerson(PersonsIsar? person) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final formKey = GlobalKey<FormState>();
    final allDetails =
        await DatabaseService.db.treeRecordDetailIsars.where().findAll();
    final countryCodeDetailType = await DatabaseService
        .db.treeRecordDetailTypeIsars
        .where()
        .remoteIdEqualTo(1)
        .findFirst();
    final availableCountryCodes = allDetails
        .where((element) =>
            element.detailType.value!.id == countryCodeDetailType!.id)
        .toList();

    final nationalityDetailType = await DatabaseService
        .db.treeRecordDetailTypeIsars
        .where()
        .remoteIdEqualTo(2)
        .findFirst();
    final availableNationalities = allDetails
        .where((element) =>
            element.detailType.value!.id == nationalityDetailType!.id)
        .toList();

    final availableTreeLevels = await DatabaseService.db.treeLevelIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();

    final availableTrees = await DatabaseService.db.treeIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();

    final availableDepartureDestinations = await DatabaseService.db.departureDestinationIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();


    final nameController = TextEditingController(text: person?.name ?? '');
    final ageController =
        TextEditingController(text: person?.age.toString() ?? '');
    final contactController =
        TextEditingController(text: person?.contact ?? '');
    TreeRecordDetailIsar? countryCode = person?.countryCode.value;
    TreeIsar? placeOfResidence = person?.placeOfResidence.value;
    TreeLevelIsar? treeLevel = placeOfResidence?.treeLevel.value;
    DateTime? entryDateTime = person?.entryDateTime ?? DateTime.now();
    DateTime? departureDateTime = person?.departureDateTime;
    DateTime? birthDate = person?.birthDate;
    TreeRecordDetailIsar? nationality = person?.nationality.value;
    final addressController =
        TextEditingController(text: person?.address ?? '');
    final nissController =
        TextEditingController(text: person?.niss == null ? '' : person!.niss.toString());
    DepartureDestinationIsar? departureDestination =
        person?.departureDestination.value;
    final destinationContactController =
        TextEditingController(text: person?.contact ?? '');

    List<TextControllersInputFormConfig> textControllersConfig = [
      TextControllersInputFormConfig(
          controller: nameController, label: '${'name'.tr()}*'),
      TextControllersInputFormConfig(
          controller: ageController,
          label: '${'age'.tr()}*',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'fill_data'.tr(namedArgs: {
                'field': 'age'.tr(),
              });
            }
            if (int.tryParse(value) == null) {
              return 'wrong_format'.tr();
            }
            return null;
          }),
      TextControllersInputFormConfig(
        controller: contactController,
        label: '${'contact'.tr()}*',
      ),
      TextControllersInputFormConfig(
        controller: addressController,
        label: 'address'.tr(),
        validator: (value) => null,
      ),
      TextControllersInputFormConfig(
          controller: nissController,
          label: 'NISS',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            if (int.tryParse(value) == null) {
              return 'wrong_format'.tr();
            }
            return null;
          }),
      TextControllersInputFormConfig(
        controller: destinationContactController,
        label: 'destination_contact'.tr(),
        validator: (value) => null,
      ),
    ];

    showDialog(
      context: context,
      builder: (context) {
        final allowances = context.watch<UserAllowancesProvider>();

        return StatefulBuilder(builder: (context, setModalState) {
          List<DateInputConfig> dates = [
            DateInputConfig(
              label: 'entry_date'.tr(),
              date: entryDateTime,
              onDateChanged: (value) => setState(() => entryDateTime = value),
              validator: (value) {
                if (value == null) {
                  return 'fill_data'.tr(namedArgs: {
                    'field': 'entry_date'.tr(),
                  });
                }
                return null;
              },
            ),
            DateInputConfig(
              label: 'departure_date'.tr(),
              date: departureDateTime,
              onDateChanged: (value) =>
                  setState(() => departureDateTime = value),
              onLongPress: () => setModalState(() => departureDateTime = null),
            ),
            DateInputConfig(
              label: 'birth_date'.tr(),
              date: birthDate,
              onDateChanged: (value) => setState(() => birthDate = value),
              onLongPress: () => setModalState(() => departureDateTime = null),
            ),
          ];
          return AlertDialog(
            title: Text(person == null
                ? '${'new'.tr()} ${'screen_settings_people'.tr()}'
                : '${'edit'.tr()} ${'screen_settings_people'.tr()}'),
            content: buildFormWithoutDates(
                formKey,
                context,
                textControllersConfig,
                [
                  customDropdownSearch<TreeRecordDetailIsar>(
                      justLabel: true,
                      label: '${'country_code'.tr()}*',
                      itemLabelBuilder: (item) => item.valueCol,
                      items: availableCountryCodes,
                      selectedItem: countryCode,
                      onSelected: (value) =>
                          setModalState(() => countryCode = value),
                      validator: (value) {
                        if (value == null) {
                          return 'fill_data'.tr(namedArgs: {
                            'field': 'country_code'.tr(),
                          });
                        }
                        return null;
                      }),
                  customDropdownSearch<TreeLevelIsar>(
                      justLabel: true,
                      label: '${'level'.tr()}*',
                      itemLabelBuilder: (item) => item.name,
                      items: availableTreeLevels,
                      selectedItem: treeLevel,
                      onSelected: (value) =>
                          setModalState(() {
                            treeLevel = value;
                            placeOfResidence = null;
                      }),
                      validator: (value) {
                        if (value == null) {
                          return 'fill_data'.tr(namedArgs: {
                            'field': 'level'.tr(),
                          });
                        }
                        return null;
                      }),
                  customDropdownSearch<TreeIsar>(
                      enabled: treeLevel != null,
                      justLabel: true,
                      label: '${'tree'.tr()}*',
                      itemLabelBuilder: (item) => item.name,
                      items: treeLevel == null ? [] : availableTrees.where((e) => e.treeLevel.value!.id == treeLevel!.id).toList(),
                      selectedItem: placeOfResidence,
                      onSelected: (value) =>
                          setModalState(() => placeOfResidence = value),
                      validator: (value) {
                        if (value == null) {
                          return 'fill_data'.tr(namedArgs: {
                            'field': 'tree'.tr(),
                          });
                        }
                        return null;
                      }),
                  customDropdownSearch<TreeRecordDetailIsar>(
                      isVisible: true,
                      justLabel: true,
                      label: 'nationality'.tr(),
                      itemLabelBuilder: (item) => item.valueCol,
                      items: availableNationalities,
                      selectedItem: nationality,
                      onSelected: (value) =>
                          setModalState(() => nationality = value),
                      validator: (value) => null),
                  customDropdownSearch<DepartureDestinationIsar>(
                      isVisible: true,
                      justLabel: true,
                      label: 'screen_settings_departure_destinations'.tr(),
                      itemLabelBuilder: (item) => item.name,
                      items: availableDepartureDestinations,
                      selectedItem: departureDestination,
                      onSelected: (value) =>
                          setModalState(() => departureDestination = value),
                      validator: (value) => null),
                ],
                dates),
            actions: [
              TextButton(
                child: Text(
                    allowances.canWrite('user_access_settings_tree_elements') //TODO
                        ? 'cancel'.tr()
                        : 'close'.tr()),
                onPressed: () => Navigator.pop(context),
              ),
              if (allowances.canWrite('user_access_settings_tree_elements')) //TODO
                TextButton(
                  child: Text('save'.tr()),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final navigator = Navigator.of(context);
                      final now = DateTime.now();
                      await DatabaseService.db.writeTxn(() async {
                        final newPerson = person ?? PersonsIsar();
                        newPerson.remoteId = person?.remoteId ?? 0;
                        newPerson.name = nameController.text;
                        newPerson.age = int.parse(ageController.text);
                        newPerson.contact = contactController.text;
                        newPerson.countryCode.value = countryCode;
                        newPerson.placeOfResidence.value = placeOfResidence;
                        newPerson.entryDateTime = entryDateTime ?? now;
                        newPerson.departureDateTime = departureDateTime;
                        newPerson.birthDate = birthDate;
                        newPerson.nationality.value = nationality;
                        newPerson.address = addressController.text;
                        newPerson.niss = nissController.text == '' ? null : int.parse(nissController.text);
                        newPerson.departureDestination.value = departureDestination;
                        newPerson.destinationContact = destinationContactController.text == '' ? null : int.parse(destinationContactController.text);
                        newPerson.createdAt = person?.createdAt ?? now;
                        newPerson.lastUpdatedAt = now;
                        newPerson.isSynced = false;
                        await DatabaseService.db.personsIsars.put(newPerson);
                        await newPerson.countryCode.save();
                        await newPerson.placeOfResidence.save();
                        if (newPerson.nationality.value != null) {
                          await newPerson.nationality.save();
                        } else {
                          await newPerson.nationality.reset();
                        }
                        if (newPerson.departureDestination.value != null) {
                          await newPerson.departureDestination.save();
                        } else {
                          await newPerson.departureDestination.reset();
                        }
                        
                        final newIncidentZcapPerson = IncidentZcapPersonsIsar();
                        newIncidentZcapPerson.remoteId = 0;
                        newIncidentZcapPerson.incidentZcap.value = incidentZcapIsar;
                        newIncidentZcapPerson.person.value = newPerson;
                        newIncidentZcapPerson.startDate = now;
                        newIncidentZcapPerson.endDate = null;
                        newIncidentZcapPerson.createdAt = now;
                        newIncidentZcapPerson.lastUpdatedAt = now;
                        newIncidentZcapPerson.isSynced = false;
                        await DatabaseService.db.incidentZcapPersonsIsars.put(newIncidentZcapPerson);
                        await newIncidentZcapPerson.incidentZcap.save();
                        await newIncidentZcapPerson.person.save();
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
