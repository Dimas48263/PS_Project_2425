import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities/entities_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/building_types/building_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/detail_type_categories/detail_type_categories_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_detail_types/zcap_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_details/zcap_details_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcaps/zcap_isar.dart';
import 'package:zcap_net_app/shared/shared.dart';
import 'package:zcap_net_app/widgets/status_bar.dart';

class ZcapsScreen extends StatefulWidget {
  final String? userName;
  const ZcapsScreen({super.key, required this.userName});

  @override
  State<ZcapsScreen> createState() => _ZcapsScreenState();
}

class _ZcapsScreenState extends State<ZcapsScreen> {
  List<ZcapIsar> zcaps = [];
  StreamSubscription? zcapsStream;

  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  Map<ZcapIsar, List<ZcapDetailsIsar>> zcapsWithDetails = {};
  List<ZcapDetailsIsar> allDetails = [];
  StreamSubscription? allDetailsStream;

  @override
  void initState() {
    super.initState();
    zcapsStream = DatabaseService.db.zcapIsars
        .buildQuery<ZcapIsar>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        zcaps = data;
        _isLoading = false;
      });
    });

    allDetailsStream = DatabaseService.db.zcapDetailsIsars
        .buildQuery<ZcapDetailsIsar>()
        .watch(fireImmediately: true)
        .listen((data) {
      setState(() {
        allDetails = data;
        for (var zcap in zcaps) {
          zcapsWithDetails[zcap] =
              allDetails.where((e) => e.zcap.value!.id == zcap.id).toList();
        }
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
    zcapsStream?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredZcaps = zcaps.where((zcap) {
      final name = zcap.name.toLowerCase();
      return name.contains(_searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('screen_zcaps'.tr()),
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: Center(
            child: SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  CustomSearchAndAddBar(
                    controller: _searchController,
                    onSearchChanged: (value) => setState(() {
                      _searchTerm = value.toLowerCase();
                    }),
                    onAddPressed: _addOrEditZcap,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: filteredZcaps.length,
                            itemBuilder: (context, index) {
                              final zcap = filteredZcaps[index];
                              return Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(
                                    left: 10.0,
                                  ),
                                  title: Text(
                                    '${(zcap.remoteId != null && zcap.remoteId! > 0) ? "[${zcap.remoteId}] " : " "}${zcap.name}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomLabelValueText(
                                              label: 'zcap_screen_buildingType'
                                                  .tr(),
                                              value: zcap.buildingType.value
                                                      ?.name ??
                                                  '',
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomLabelValueText(
                                                  label: 'screen_entity'.tr(),
                                                  value: zcap.zcapEntity.value
                                                          ?.name ??
                                                      '',
                                                ),
                                                CustomLabelValueText(
                                                  label: 'contact'.tr(),
                                                  value:
                                                      '${zcap.zcapEntity.value?.phone1 ?? ''}'
                                                      '${(zcap.zcapEntity.value?.phone2?.isNotEmpty ?? false) ? ' \\ ${zcap.zcapEntity.value?.phone2}' : ''}',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomLabelValueText(
                                                label: 'start'.tr(),
                                                value: zcap.startDate
                                                    .toLocal()
                                                    .toString()
                                                    .split(' ')[0]),
                                          ),
                                          Expanded(
                                            child: CustomLabelValueText(
                                              label: 'end'.tr(),
                                              value: zcap.endDate != null
                                                  ? zcap.endDate!
                                                      .toLocal()
                                                      .toString()
                                                      .split(' ')[0]
                                                  : 'no_end_date'.tr(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (zcap.latitude != null &&
                                          zcap.longitude != null)
                                        if (zcap.latitude != null &&
                                            zcap.longitude != null)
                                          CustomGMapsLocationButton(
                                            latitude: zcap.latitude.toString(),
                                            longitude:
                                                zcap.longitude.toString(),
                                          ),
                                      if (!zcap.isSynced) CustomUnsyncedIcon(),
                                      IconButton(
                                        onPressed: () {
                                          _addOrEditZcap(zcap: zcap);
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          final confirm =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (context) => ConfirmDialog(
                                              title: 'confirm_delete'.tr(),
                                              content:
                                                  'confirm_delete_message'.tr(),
                                            ),
                                          );
                                          if (confirm == true) {
                                            await DatabaseService.db
                                                .writeTxn(() async {
                                              await DatabaseService.db.zcapIsars
                                                  .delete(zcap.id);
                                            });
                                          }
                                        },
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  )
                ]),
              ),
            ),
          )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: StatusBar(userName: widget.userName),
          ),
        ],
      ),
    );
  }

  void _addOrEditZcap({ZcapIsar? zcap}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final nameController = TextEditingController(text: zcap?.name ?? "");
    final addressController = TextEditingController(text: zcap?.address ?? "");
    final latitudeController =
        TextEditingController(text: zcap?.latitude?.toString() ?? '');
    final longitudeController =
        TextEditingController(text: zcap?.longitude?.toString() ?? '');
    BuildingTypesIsar? buildingType = zcap?.buildingType.value;
    EntitiesIsar? zcapEntity = zcap?.zcapEntity.value;

    DateTime selectedStartDate = zcap?.startDate ?? DateTime.now();
    DateTime? selectedEndDate = zcap?.endDate;

    final availableBuildingTypes = await DatabaseService.db.buildingTypesIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();

    final availableEntities = await DatabaseService.db.entitiesIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();

    final availableCategories = await DatabaseService
        .db.detailTypeCategoriesIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();

    final availableDetailTypes = await DatabaseService.db.zcapDetailTypeIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();

    List<ZcapDetailsIsar> zcapDetails =
        zcap != null ? zcapsWithDetails[zcap]! : [];

    Map<ZcapDetailTypeIsar, ZcapDetailsIsar?> zcapDetailsMap = {};

    for (var availableDetailType in availableDetailTypes) {
      ZcapDetailsIsar? search;
      try {
        search = zcapDetails.firstWhere((element) =>
            element.zcapDetailType.value!.id == availableDetailType.id);
      } catch (e) {
        search = null;
      }
      zcapDetailsMap[availableDetailType] = search;
    }

    final formKey = GlobalKey<FormState>();
    final detailsFormKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          bool detailsFormValidated = false;
          bool showDetailsError = false;
          return StatefulBuilder(
            builder: (context, setModalState) {
              return AlertDialog(
                title: Text(zcap != null
                    ? '${'edit'.tr()} ${'screen_zcap'.tr()}'
                    : '${'new'.tr()} ${'screen_zcap'.tr()}'),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              labelText: 'screen_zcap_name'.tr()),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'required_field'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        DropdownSearch<EntitiesIsar>(
                          selectedItem: zcapEntity,
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                labelText:
                                    '${'search'.tr()} ${'screen_entity'.tr()}',
                              ),
                            ),
                          ),
                          itemAsString: (EntitiesIsar? e) => e?.name ?? '',
                          items: availableEntities,
                          onChanged: (EntitiesIsar? value) {
                            setModalState(() {
                              zcapEntity = value;
                            });
                          },
                          validator: (EntitiesIsar? value) {
                            if (value == null) {
                              return 'required_field'.tr();
                            }
                            return null;
                          },
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: 'screen_entity'.tr(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        DropdownSearch<BuildingTypesIsar>(
                          selectedItem: buildingType,
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                labelText:
                                    '${'search'.tr()} ${'zcap_screen_buildingType'.tr()}',
                              ),
                            ),
                          ),
                          itemAsString: (BuildingTypesIsar? e) => e?.name ?? '',
                          items: availableBuildingTypes,
                          onChanged: (BuildingTypesIsar? value) {
                            setModalState(() {
                              buildingType = value;
                            });
                          },
                          validator: (BuildingTypesIsar? value) {
                            if (value == null) {
                              return 'required_field'.tr();
                            }
                            return null;
                          },
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: 'zcap_screen_buildingType'.tr(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                              labelText: 'zcap_screen_address'.tr()),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'required_field'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        CustomLocationInputField(
                          latitudeController: latitudeController,
                          longitudeController: longitudeController,
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        CustomDateRangePicker(
                          startDate: selectedStartDate,
                          endDate: selectedEndDate,
                          onStartDateChanged: (newStart) {
                            setModalState(() {
                              selectedStartDate = newStart;
                            });
                          },
                          onEndDateChanged: (newEnd) {
                            setModalState(() {
                              selectedEndDate = newEnd;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              //centrar,
                              onPressed: () {
                                showDetails(
                                  context,
                                  availableCategories,
                                  detailsFormKey,
                                  zcapDetailsMap,
                                  onValidated: () {
                                    setModalState(() {
                                      detailsFormValidated = true;
                                      showDetailsError = false;
                                    });
                                  },
                                );
                              },
                              child: const Text('Abrir detalhes'),
                            ),
                          ],
                        ),
                        if (showDetailsError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Por favor preencha os detalhes obrigatórios.',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  CancelTextButton(),
                  TextButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate() &&
                          nameController.text.isNotEmpty) {
                        if (!detailsFormValidated) {
                          setModalState(() {
                            showDetailsError = true;
                          });
                          return;
                        }
                        final now = DateTime.now();
                        final navigator = Navigator.of(context);
                        for (var m in zcapDetailsMap.keys) {
                          print('detailType ${m.name} with detail ${zcapDetailsMap[m]?.valueCol}');
                        }
                        
                        final editedZcap = zcap ?? ZcapIsar();

                        editedZcap.name = nameController.text.trim();
                        editedZcap.address = addressController.text.trim();
                        editedZcap.buildingType.value = buildingType;
                        editedZcap.zcapEntity.value = zcapEntity;
                        editedZcap.latitude =
                            double.tryParse(latitudeController.text);
                        editedZcap.longitude =
                            double.tryParse(longitudeController.text);
                        editedZcap.startDate = selectedStartDate;
                        editedZcap.endDate = selectedEndDate;
                        editedZcap.lastUpdatedAt = now;
                        editedZcap.isSynced = false;
                        if (zcap == null) {
                          editedZcap.createdAt = now;
                        }
                        DatabaseService.db.writeTxn(() async {
                          await DatabaseService.db.zcapIsars.put(editedZcap);
                          await editedZcap.buildingType.save();
                          await editedZcap.zcapEntity.save();
                          for (var m in zcapDetailsMap.keys) {
                            final detail = zcapDetailsMap[m];
                            if (detail != null) {
                              detail.zcap.value = editedZcap;
                              await DatabaseService.db.zcapDetailsIsars.put(detail);
                              await detail.zcap.save();
                              await detail.zcapDetailType.save();
                            }
                          }
                        });
                        navigator.pop();

                      }
                    },
                    child: Text('save'.tr()),
                  ),
                ],
              );
            },
          );
        });
  }

  Future<void> showDetails(BuildContext context,
      List<DetailTypeCategoriesIsar> categories, GlobalKey<FormState> formKey, Map<ZcapDetailTypeIsar, ZcapDetailsIsar?> typeDetailMap,
      {VoidCallback? onValidated}) async {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    final form = await detailsForm(
      categories,
      () => overlayEntry.remove(),
      formKey,
      context,
      typeDetailMap,
      onValidated: onValidated,
    );
    overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () => overlayEntry.remove(),
        child: Material(
          color: Colors.black54,
          child: Center(
            child: GestureDetector(
              onTap: () {}, // Impede fechar ao clicar no form
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    form /*_DetailsForm(
                  category: category,
                  onClose: () => overlayEntry.remove(),
                )*/
                ,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }

  bool validateValue(String type, String value) {
    switch (type) {
      case 'string':
        if (value.isEmpty) return false;
        return true;
      case 'int':
        return int.tryParse(value) != null;
      case 'double':
        return double.tryParse(value) != null;
      case 'boolean':
        return value == '0' || value == '1';
      case 'char':
        return value.length == 1;
      case 'float':
        return double.tryParse(value) != null;
      default:
        return true;
    }
  }

  Future<Widget> detailsForm(
      List<DetailTypeCategoriesIsar> categories,
      VoidCallback onClose,
      GlobalKey<FormState> formKey,
      BuildContext context,
      Map<ZcapDetailTypeIsar, ZcapDetailsIsar?> typeDetailMap,
      {VoidCallback? onValidated}) async {
    Map<DetailTypeCategoriesIsar, List<ZcapDetailTypeIsar>> detailsByCategory =
        {};

    final detailTypeKeys = typeDetailMap.keys.toList();

    final Map<int, TextEditingController> detailControllers = {};

    for (var detailType in detailTypeKeys) {
      final existingDetail = typeDetailMap[detailType];

      detailControllers[detailType.id] = TextEditingController(
        text: existingDetail?.valueCol ?? '',
      );
    }

    for (var category in categories) {
      final detailTypes = detailTypeKeys.where((e) {
        return e.detailTypeCategory.value!.id == category.id;
      }).toList();
      detailsByCategory[category] = detailTypes;
    }
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Editar Detalhes',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            for (int i = 0; i < categories.length; i++)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  if (i > 0) const Divider(),
                  const SizedBox(height: 10),
                  Text(categories[i].name,
                      style: Theme.of(context).textTheme.titleSmall),
                  for (var detailType in detailsByCategory[categories[i]]!)
                    Column(
                      children: [
                        detailType.dataType.name != 'boolean'
                            ? TextFormField(
                                controller: detailControllers[detailType.id],
                                decoration: InputDecoration(
                                  labelText: detailType.isMandatory
                                      ? '${detailType.name}*'
                                      : detailType.name,
                                  hintText:
                                      "${'example_abbreviation'.tr()} ${detailType.dataType.example}",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                                validator: (value) {
                                  if (!detailType.isMandatory) {
                                    if (value != null && value.isNotEmpty) {
                                      if (validateValue(
                                          detailType.dataType.name, value)) {
                                        return null;
                                      } else {
                                        return 'wrong_format'.tr();
                                      }
                                    }
                                    return null;
                                  } else {
                                    if (value == null || value.isEmpty) {
                                      return 'required_field'.tr();
                                    }
                                    if (validateValue(
                                        detailType.dataType.name, value)) {
                                      return null;
                                    }
                                    return 'wrong_format'.tr();
                                  }
                                })
                            : FormField<bool>(
                                initialValue: detailControllers[detailType.id]?.text != '' ? detailControllers[detailType.id]?.text == '1' : null, 
                                validator: (value) {
                                  if (detailType.isMandatory && value == null) {
                                    return 'required_field'.tr();
                                  }
                                  return null;
                                },
                                builder: (field) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(detailType.isMandatory
                                          ? '${detailType.name}*'
                                          : detailType.name),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: field.value == true,
                                            onChanged: (val) {
                                              final newValue =
                                                  field.value == true
                                                      ? null
                                                      : true;
                                              field.didChange(newValue);
                                              detailControllers[detailType.id]!.text = newValue != null ? '1' : '';
                                            },
                                          ),
                                          Text("true".tr()),
                                          const SizedBox(width: 20),
                                          Checkbox(
                                            value: field.value == false,
                                            onChanged: (val) {
                                              final newValue =
                                                  field.value == false
                                                      ? null
                                                      : false;
                                              field.didChange(newValue);
                                              detailControllers[detailType.id]!.text = newValue != null ? '0' : '';
                                            },
                                          ),
                                          Text("false".tr()),
                                        ],
                                      ),
                                      if (field.hasError)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(
                                            field.errorText!,
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 12),
                                          ),
                                        )
                                    ],
                                  );
                                },
                              ),
                        const SizedBox(height: 10),
                      ],
                    ),
                ],
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onClose,
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        for (var detailType in detailTypeKeys) {
                          final controller = detailControllers[detailType.id];
                          final detail = typeDetailMap[detailType];
                          if (detail == null) {
                            typeDetailMap[detailType] = ZcapDetailsIsar()
                              ..isSynced = false
                              ..remoteId = 0
                              ..valueCol = controller?.text ?? ''
                              ..zcapDetailType.value = detailType
                              ..startDate = DateTime.now()
                              ..createdAt = DateTime.now()
                              ..lastUpdatedAt = DateTime.now();
                          } else {
                            if (detail.valueCol != controller?.text) {
                              typeDetailMap[detailType] = ZcapDetailsIsar()
                              ..isSynced = false
                              ..remoteId = detail.remoteId
                              ..valueCol = controller?.text ?? ''
                              ..zcapDetailType.value = detailType
                              ..startDate = DateTime.now()
                              ..createdAt = DateTime.now()
                              ..lastUpdatedAt = DateTime.now();
                            }
                          }
                        }
                        onValidated?.call();
                        onClose();
                      }
                    },
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
