import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities/entities_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/building_types/building_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_detail_types/zcap_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcap_details/zcap_details_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/zcaps/zcap_isar.dart';
import 'package:zcap_net_app/shared/shared.dart';
import 'package:zcap_net_app/widgets/status_bar.dart';
import 'package:zcap_net_app/widgets/text_controllers_input_form.dart';

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

    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
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
                        final now = DateTime.now();
                        final navigator = Navigator.of(context);

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
                        if (zcap != null) {
                          DatabaseService.db.writeTxn(() async {
                            await DatabaseService.db.zcapIsars.put(editedZcap);

                            await editedZcap.buildingType.save();
                            await editedZcap.zcapEntity.save();
                          });
                          navigator.pop();  
                        } else {
                          editedZcap.createdAt = now;
                          navigator.pop();
                        _addDetails(editedZcap); 
                        }
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

  void _addDetails(ZcapIsar zcap) async {
    final detailTypes =
        await DatabaseService.db.zcapDetailTypeIsars.where().findAll();
    final mandatoryDetailTypes =
        detailTypes.where((e) => e.isMandatory).toList();
    List<ZcapDetailsIsar> details = [];
    ZcapDetailsIsar? detail;
    for (var i = 0; i < mandatoryDetailTypes.length; i++) {
      final mandatoryDetailType = mandatoryDetailTypes[i];
      detail = await _addOrEditDetail(
          mandatoryDetailType, zcap, i, mandatoryDetailTypes.length);
      if (detail == null) {
        break;
      } else {
        details.add(detail);
      }
    }
    if (detail != null) {
      //guarda a zcap e os detalhes
      DatabaseService.db.writeTxn(() async {
        await DatabaseService.db.zcapIsars.put(zcap);
        await zcap.buildingType.save();
        await zcap.zcapEntity.save();
        for (final det in details) {
          await DatabaseService.db.zcapDetailsIsars.put(det);
          await det.zcapDetailType.save();
          await det.zcap.save();
        }
      });
    }
  }

  Future<ZcapDetailsIsar?> _addOrEditDetail(ZcapDetailTypeIsar detailType,
      ZcapIsar zcap, int index, int total) async {
    final formKey = GlobalKey<FormState>();
    final valueController = TextEditingController(text: '');
    DateTime startDate = DateTime.now();
    DateTime? endDate;
    List<TextControllersInputFormConfig>? textControllersConfig;
    bool? boolField;
    String? selectedItemLabel;
    if (detailType.dataType.name != 'boolean') {
      textControllersConfig = [
        TextControllersInputFormConfig(
            controller: valueController,
            label:
                "${'value'.tr()} (${'example'.tr()}: ${detailType.dataType.example})",
            validator: (val) {
              if (val == null || val.isEmpty) return 'required_field'.tr();
              if (validateValue(detailType.dataType.name, val)) return null;
              return 'wrong_format'.tr();
            }),
      ];
    }

    final shouldContinue = await showDialog<ZcapDetailsIsar>(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setModalState) {
            return AlertDialog(
              title: Text(
                  '${'detail'.tr()}: ${detailType.name}.  ${index + 1}/$total'),
              content: buildForm(formKey, context, textControllersConfig ?? [],
                  startDate, endDate, (value) {
                setState(() => startDate = value);
                setModalState(() {}); // Atualiza o dialog
              }, (value) {
                setState(() => endDate = value);
                setModalState(() {}); // Atualiza o dialog
              }, () {
                setModalState(() {
                  endDate = null;
                });
              },
                  textControllersConfig == null
                      ? [
                          customDropdownSearch<String>(
                              items: ['true'.tr(), 'false'.tr()],
                              selectedItem: selectedItemLabel,
                              onSelected: (String? value) {
                                setModalState(() {
                                  selectedItemLabel = value;
                                  boolField = selectedItemLabel == 'true'.tr();
                                });
                              },
                              validator: (value) =>
                                  value == null ? 'required_field'.tr() : null)
                        ]
                      : []),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final String val;
                      if (boolField != null) {
                        if (boolField!) {
                          val = 'true';
                        } else {
                          val = 'false';
                        }
                      } else {
                        val = valueController.text.trim();
                      }
                      final now = DateTime.now();
                      final editedDetail = ZcapDetailsIsar();
                      editedDetail.remoteId = 0;
                      editedDetail.valueCol = val;
                      editedDetail.zcap.value = zcap;
                      editedDetail.zcapDetailType.value = detailType;
                      editedDetail.startDate = startDate;
                      editedDetail.endDate = endDate;
                      editedDetail.createdAt = now;
                      editedDetail.lastUpdatedAt = now;
                      editedDetail.isSynced = false;
                      Navigator.of(context).pop(editedDetail);
                    }
                  },
                  child: Text('Next'),
                ),
              ],
            );
          });
        });
    return shouldContinue;
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
        return value == 'true' || value == 'false';
      case 'char':
        return value.length == 1;
      case 'float':
        return double.tryParse(value) != null;
      default:
        return true;
    }
  }
}
