import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/features/incidents_tree/family_members_dialogs.dart';
import 'package:zcap_net_app/features/incidents_tree/special_needs_dialogs.dart';
import 'package:zcap_net_app/features/incidents_tree/support_needed_dialogs.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_zcap_persons/incident_zcap_persons_isar.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_zcaps/incident_zcaps_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/departure_destination/departure_destination_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/person_special_needs/person_special_needs_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/persons/persons_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_levels/tree_level_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_detail_types/tree_record_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_details/tree_record_detail_isar.dart';
import 'package:zcap_net_app/widgets/confirm_dialog.dart';
import 'package:zcap_net_app/widgets/custom_dropdown_search.dart';
import 'package:zcap_net_app/widgets/custom_form.dart';
import 'package:zcap_net_app/widgets/custom_search_and_add_bar.dart';
import 'package:zcap_net_app/widgets/sync_button.dart';
import 'package:zcap_net_app/widgets/text_controllers_input_form.dart';

class PersonsScreen extends StatefulWidget {
  final IncidentZcapsIsar incidentZcapIsar;
  const PersonsScreen({super.key, required this.incidentZcapIsar});

  @override
  State<PersonsScreen> createState() => _PersonsScreenState();
}

class _PersonsScreenState extends State<PersonsScreen> {
  late IncidentZcapsIsar incidentZcapIsar;

  List<IncidentZcapPersonsIsar> incidentZcapPersons = [];
  StreamSubscription? incidentZcapPersonsStream;

  List<PersonsIsar> persons = [];
  StreamSubscription? personsStream;

  List<PersonSpecialNeedsIsar> personSpecialNeeds = [];
  StreamSubscription? personSpecialNeedsStream;

  bool _isLoading = true;
  final _searchController = TextEditingController();
  String _searchTerm = '';

  late UserAllowancesProvider allowances;
  late bool canWrite;

  @override
  void initState() {
    super.initState();
    incidentZcapIsar = widget.incidentZcapIsar;

    personsStream = isarDb.personsIsars
        .buildQuery<PersonsIsar>()
        .watch(fireImmediately: true)
        .listen((data) async {
      final izp = await isarDb.incidentZcapPersonsIsars.where().findAll();
      updateValues(izp);
    });

    incidentZcapPersonsStream = isarDb.incidentZcapPersonsIsars
        .buildQuery<IncidentZcapPersonsIsar>()
        .watch(fireImmediately: true)
        .listen((data) async {
      updateValues(data);
    });

    personSpecialNeedsStream = isarDb.personSpecialNeedsIsars
        .buildQuery<PersonSpecialNeedsIsar>()
        .watch(fireImmediately: true)
        .listen((data) async {
      personSpecialNeeds = data;
    });
    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text.toLowerCase();
      });
    });
  }

  void updateValues(List<IncidentZcapPersonsIsar> data) {
    setState(() {
      incidentZcapPersons = data;
      persons = [];
      persons = incidentZcapPersons
          .where((e) =>
              e.incidentZcap.value!.zcap.value!.id ==
              incidentZcapIsar.zcap.value!.id)
          .map((e) => e.person.value!)
          .toList();
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    incidentZcapPersonsStream?.cancel();
    personsStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    allowances = context.watch<UserAllowancesProvider>();
    canWrite = allowances.canWrite('user_access_add_people');
    return Scaffold(
      appBar: AppBar(
        title: Text('persons_from_zcap'
            .tr(namedArgs: {'zcapName': incidentZcapIsar.zcap.value!.name})),
        actions: [SyncButton()],
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
            canWrite: canWrite,
            controller: _searchController,
            onSearchChanged: (value) => setState(() {
              _searchTerm = value.toLowerCase();
            }),
            onIconPressed: () {
              _addPerson();
            },
          ),
          const SizedBox(height: 10.0),
          _isLoading
              ? const CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final person = filteredList[index];

                        return Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.only(left: 10.0),
                            title: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: person.departureDateTime == null
                                        ? Colors.green
                                        : Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text('${'name'.tr()}: ${person.name}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child:
                                          Text('${'age'.tr()}: ${person.age}'),
                                    ),
                                    Expanded(
                                      child: Text(
                                          '${'contact'.tr()}: ${person.contact}'),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          '${'entry_date'.tr()}: ${DateFormat('yyyy-MM-dd HH:mm').format(person.entryDateTime.toLocal())}'),
                                    ),
                                    Expanded(
                                      child: Text(
                                          '${'departure_date'.tr()}: ${person.departureDateTime != null ? DateFormat('yyyy-MM-dd HH:mm').format(person.departureDateTime!.toLocal()) : 'no_end_date'.tr()}'),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                    onPressed: () => showDialog(
                                        context: context,
                                        builder: (_) => FamilyMembersDialogs(
                                            person: person,
                                            personsInZcap: persons)),
                                    child: Text('family_members'.tr())),
                                const SizedBox(width: 5),
                                if (canWrite &&
                                    person.departureDateTime == null) ...[
                                  ElevatedButton(
                                      onPressed: () => _exitForm(person),
                                      child: Text('exit'.tr())),
                                  const SizedBox(width: 5),
                                ],
                                ElevatedButton(
                                    onPressed: () => showDialog(
                                        context: context,
                                        builder: (context) =>
                                            SupportNeedsDialogs(
                                                person: person)),
                                    child: Text('support_needed'.tr())),
                                const SizedBox(width: 5),
                                ElevatedButton(
                                    onPressed: () => showDialog(
                                        context: context,
                                        builder: (context) =>
                                            SpecialNeedsDialogs(
                                                person: person)),
                                    child: Text('special_needs'.tr())),
                                if (!person.isSynced)
                                  IconButton(
                                    onPressed: () async =>
                                        await syncService.synchronizeAll(),
                                    icon: const Icon(Icons.sync_problem,
                                        color: Colors.orange, size: 30),
                                  ),
                                if (canWrite) ...[
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _editPerson(person);
                                    },
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => ConfirmDialog(
                                          title: 'confirm_delete'.tr(),
                                          content:
                                              'confirm_delete_message'.tr(),
                                        ),
                                      );
                                      if (confirm == true) {
                                        await isarDb.writeTxn(() async {
                                          final incidentZcapPersonFromPerson =
                                              incidentZcapPersons
                                                  .where((e) =>
                                                      e.person.value!.id ==
                                                      person.id)
                                                  .toList();
                                          for (var izp
                                              in incidentZcapPersonFromPerson) {
                                            await isarDb
                                                .incidentZcapPersonsIsars
                                                .delete(izp.id);
                                          }
                                          await isarDb.personsIsars
                                              .delete(person.id);
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                  ),
                                ] else
                                  IconButton(
                                    icon: const Icon(
                                      Icons.info_outline,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => _editPerson(person),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }))
        ],
      ),
    );
  }

  void _exitForm(PersonsIsar person) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final formKey = GlobalKey<FormState>();
    final destinationContactController = TextEditingController(text: '');
    DepartureDestinationIsar? selectedDepartureDestination;
    DateTime? departureDateTime = now;

    final availableDepartureDestinations = await isarDb
        .departureDestinationIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setModalState) {
            return AlertDialog(
              title: Text('exit'.tr()),
              content: buildFormWithoutDates(
                  chooseTime: true,
                  canWrite: canWrite,
                  formKey,
                  context,
                  [
                    TextControllersInputFormConfig(
                      controller: destinationContactController,
                      label: '${'contact'.tr()}*',
                      validator: (value) => null,
                    ),
                  ],
                  [
                    customDropdownSearch<DepartureDestinationIsar>(
                        enabled: canWrite,
                        justLabel: true,
                        label: 'screen_settings_departure_destinations'.tr(),
                        itemLabelBuilder: (item) => item.name,
                        items: availableDepartureDestinations,
                        selectedItem: selectedDepartureDestination,
                        onSelected: (value) => setModalState(
                            () => selectedDepartureDestination = value),
                        validator: (value) {
                          if (value == null) {
                            return 'required_field'.tr();
                          }
                          return null;
                        }),
                  ],
                  [
                    DateInputConfig(
                      label: 'departure_date'.tr(),
                      date: departureDateTime,
                      onDateChanged: (value) =>
                          setModalState(() => departureDateTime = value),
                      validator: (value) {
                        if (value == null) {
                          return 'fill_data'.tr(namedArgs: {
                            'field': 'departure_date'.tr(),
                          });
                        }
                        return null;
                      },
                    ),
                  ]),
              actions: [
                TextButton(
                  child: Text('cancel'.tr()),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text('save'.tr()),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final navigator = Navigator.of(context);
                      final now = DateTime.now();
                      await isarDb.writeTxn(() async {
                        final newPerson = person;
                        newPerson.destinationContact =
                            destinationContactController.text == ''
                                ? null
                                : destinationContactController.text;
                        newPerson.departureDestination.value =
                            selectedDepartureDestination;
                        newPerson.departureDateTime = departureDateTime;
                        newPerson.lastUpdatedAt = now;
                        newPerson.isSynced = false;
                        await isarDb.personsIsars.put(newPerson);
                        await newPerson.departureDestination.save();
                      });

                      navigator.pop();
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  void _addPerson() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: '');
    final ageController = TextEditingController(text: '');
    final contactController = TextEditingController(text: '');
    final technicianName = TextEditingController(text: '');
    TreeIsar? placeOfResidence;
    DateTime? entryDateTime = now;

    TreeLevelIsar? selectedTreeLevel;

    final availableTreeLevels = await isarDb.treeLevelIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();

    final availableTrees = await isarDb.treeIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();

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
        controller: technicianName,
        label: '${'technician_name'.tr()}*',
      ),
    ];

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setModalState) {
            return AlertDialog(
              title: Text('${'add'.tr()} ${'person'.tr()}'),
              content: buildFormWithoutDates(
                  chooseTime: true,
                  canWrite: canWrite,
                  formKey,
                  context,
                  textControllersConfig,
                  [
                    Row(
                      children: [
                        Expanded(
                          child: customDropdownSearch<TreeLevelIsar>(
                              isVisible: true,
                              enabled: canWrite,
                              justLabel: true,
                              label: 'level'.tr(),
                              itemLabelBuilder: (item) => item.name,
                              items: availableTreeLevels,
                              selectedItem: selectedTreeLevel,
                              onSelected: (value) => setModalState(() {
                                    selectedTreeLevel = value;
                                    placeOfResidence = null;
                                  }),
                              validator: (value) => null),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: customDropdownSearch<TreeIsar>(
                              enabled: canWrite,
                              justLabel: true,
                              label: '${'place_of_residence'.tr()}*',
                              itemLabelBuilder: (item) => item.name,
                              items: selectedTreeLevel == null
                                  ? availableTrees
                                  : availableTrees
                                      .where((e) =>
                                          e.treeLevel.value!.id ==
                                          selectedTreeLevel!.id)
                                      .toList(),
                              selectedItem: placeOfResidence,
                              onSelected: (value) => setModalState(() {
                                    placeOfResidence = value;
                                    selectedTreeLevel = value!.treeLevel.value;
                                  }),
                              validator: (value) {
                                if (value == null) {
                                  return 'fill_data'.tr(namedArgs: {
                                    'field': 'tree'.tr(),
                                  });
                                }
                                return null;
                              }),
                        )
                      ],
                    )
                  ],
                  [
                    DateInputConfig(
                      label: 'entry_date'.tr(),
                      date: entryDateTime,
                      onDateChanged: (value) =>
                          setModalState(() => entryDateTime = value),
                      validator: (value) {
                        if (value == null) {
                          return 'fill_data'.tr(namedArgs: {
                            'field': 'entry_date'.tr(),
                          });
                        }
                        return null;
                      },
                    ),
                  ]),
              actions: [
                TextButton(
                  child: Text('cancel'.tr()),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text('save'.tr()),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final navigator = Navigator.of(context);
                      final now = DateTime.now();
                      await isarDb.writeTxn(() async {
                        final newPerson = PersonsIsar();
                        newPerson.remoteId = 0;
                        newPerson.name = nameController.text;
                        newPerson.age = int.parse(ageController.text);
                        newPerson.contact = contactController.text;
                        newPerson.placeOfResidence.value = placeOfResidence;
                        newPerson.entryDateTime = entryDateTime ?? now;
                        newPerson.technicianName = technicianName.text;
                        newPerson.createdAt = now;
                        newPerson.lastUpdatedAt = now;
                        newPerson.isSynced = false;
                        await isarDb.personsIsars.put(newPerson);
                        await newPerson.placeOfResidence.save();

                        final newIncidentZcapPerson = IncidentZcapPersonsIsar();
                        newIncidentZcapPerson.remoteId = 0;
                        newIncidentZcapPerson.incidentZcap.value =
                            incidentZcapIsar;
                        newIncidentZcapPerson.person.value = newPerson;
                        newIncidentZcapPerson.startDate = now;
                        newIncidentZcapPerson.endDate = null;
                        newIncidentZcapPerson.createdAt = now;
                        newIncidentZcapPerson.lastUpdatedAt = now;
                        newIncidentZcapPerson.isSynced = false;
                        await isarDb.incidentZcapPersonsIsars
                            .put(newIncidentZcapPerson);
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
        });
  }

  void _editPerson(PersonsIsar person) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final formKey = GlobalKey<FormState>();
    final allDetails = await isarDb.treeRecordDetailIsars.where().findAll();

    final nationalityDetailType = await isarDb.treeRecordDetailTypeIsars
        .where()
        .remoteIdEqualTo(1)
        .findFirst();
    final availableNationalities = allDetails
        .where((element) =>
            element.detailType.value!.id == nationalityDetailType!.id)
        .toList();

    final availableTreeLevels = await isarDb.treeLevelIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();

    final availableTrees = await isarDb.treeIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();

    final nameController = TextEditingController(text: person.name);
    final ageController = TextEditingController(text: person.age.toString());
    final contactController = TextEditingController(text: person.contact);
    final bedNumberController = TextEditingController(text: person.bedNumber != null ? person.bedNumber.toString() : '');
    TreeIsar? placeOfResidence = person.placeOfResidence.value;
    TreeLevelIsar? treeLevel = placeOfResidence?.treeLevel.value;
    DateTime? birthDate = person.birthDate;
    TreeRecordDetailIsar? nationality = person.nationality.value;
    final addressController = TextEditingController(text: person.address);
    final nissController = TextEditingController(text: person.niss);
    final destinationContactController =
        TextEditingController(text: person.destinationContact);

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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'fill_data'.tr(namedArgs: {
                'field': 'contact'.tr(),
              });
            }
            return null;
          }),
      TextControllersInputFormConfig(
          controller: bedNumberController,
          label: 'bed_number'.tr(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            for (var c in value.characters) {
              if (int.tryParse(c) == null) {
                return 'wrong_format'.tr();
              }
            }
            return null;
          }),
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
            for (var c in value.characters) {
              if (int.tryParse(c) == null) {
                return 'wrong_format'.tr();
              }
            }
            return null;
          }),
      if (person.departureDateTime != null)
        TextControllersInputFormConfig(
          controller: destinationContactController,
          label: 'destination_contact'.tr(),
          validator: (value) => null,
        ),
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          List<DateInputConfig> dates = [
            DateInputConfig(
              label: 'birth_date'.tr(),
              date: birthDate,
              onDateChanged: (value) => setModalState(() => birthDate = value),
              onLongPress: () => setModalState(() => birthDate = null),
            ),
          ];
          return AlertDialog(
            title: Text('${'edit'.tr()} ${'person'.tr()}'),
            content: buildFormWithoutDates(
                canWrite: canWrite,
                formKey,
                context,
                textControllersConfig,
                [
                  Row(
                    children: [
                      Expanded(
                        child: customDropdownSearch<TreeLevelIsar>(
                            isVisible: true,
                            enabled: canWrite,
                            justLabel: true,
                            label: 'level'.tr(),
                            itemLabelBuilder: (item) => item.name,
                            items: availableTreeLevels,
                            selectedItem: treeLevel,
                            onSelected: (value) => setModalState(() {
                                  treeLevel = value;
                                  placeOfResidence = null;
                                }),
                            validator: (value) => null),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: customDropdownSearch<TreeIsar>(
                            enabled: canWrite,
                            justLabel: true,
                            label: '${'place_of_residence'.tr()}*',
                            itemLabelBuilder: (item) => item.name,
                            items: treeLevel == null
                                ? availableTrees
                                : availableTrees
                                    .where((e) =>
                                        e.treeLevel.value!.id == treeLevel!.id)
                                    .toList(),
                            selectedItem: placeOfResidence,
                            onSelected: (value) => setModalState(() {
                                  placeOfResidence = value;
                                  treeLevel = value!.treeLevel.value;
                                }),
                            validator: (value) {
                              if (value == null) {
                                return 'fill_data'.tr(namedArgs: {
                                  'field': 'tree'.tr(),
                                });
                              }
                              return null;
                            }),
                      )
                    ],
                  ),
                  customDropdownSearch<TreeRecordDetailIsar>(
                      enabled: canWrite,
                      isVisible: true,
                      justLabel: true,
                      label: 'nationality'.tr(),
                      itemLabelBuilder: (item) => item.valueCol,
                      items: availableNationalities,
                      selectedItem: nationality,
                      onSelected: (value) =>
                          setModalState(() => nationality = value),
                      validator: (value) => null),
                ],
                dates),
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
                      final navigator = Navigator.of(context);
                      final now = DateTime.now();
                      await isarDb.writeTxn(() async {
                        final newPerson = person;
                        newPerson.name = nameController.text;
                        newPerson.age = int.parse(ageController.text);
                        newPerson.contact = contactController.text;
                        newPerson.bedNumber = bedNumberController.text == ''
                            ? null
                            : int.parse(bedNumberController.text);
                        newPerson.placeOfResidence.value = placeOfResidence;
                        newPerson.birthDate = birthDate;
                        newPerson.nationality.value = nationality;
                        newPerson.address = addressController.text == ''
                            ? null
                            : addressController.text;
                        newPerson.niss = nissController.text == ''
                            ? null
                            : nissController.text;
                        newPerson.destinationContact =
                            destinationContactController.text == ''
                                ? null
                                : destinationContactController.text;
                        newPerson.lastUpdatedAt = now;
                        newPerson.isSynced = false;
                        await isarDb.personsIsars.put(newPerson);
                        await newPerson.placeOfResidence.save();
                        if (newPerson.nationality.value != null) {
                          await newPerson.nationality.save();
                        } else {
                          await newPerson.nationality.reset();
                        }
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
