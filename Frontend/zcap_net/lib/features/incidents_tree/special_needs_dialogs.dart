import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/features/settings/models/people/person_special_needs/person_special_needs_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/persons/persons_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/special_needs/special_needs_isar.dart';
import 'package:zcap_net_app/widgets/confirm_dialog.dart';
import 'package:zcap_net_app/widgets/custom_dropdown_search.dart';
import 'package:zcap_net_app/widgets/custom_form.dart';
import 'package:zcap_net_app/widgets/text_controllers_input_form.dart';

class SpecialNeedsDialogs extends StatefulWidget {
  final PersonsIsar person;

  const SpecialNeedsDialogs({
    super.key,
    required this.person,
  });

  @override
  State<SpecialNeedsDialogs> createState() => _SpecialNeedsDialogsState();
}

class _SpecialNeedsDialogsState extends State<SpecialNeedsDialogs> {
  List<PersonSpecialNeedsIsar> list = [];
  StreamSubscription? _subscription;

  late UserAllowancesProvider allowances;
  late bool canWrite;

  @override
  void initState() {
    super.initState();
    _subscription = isarDb.personSpecialNeedsIsars
        .buildQuery<PersonSpecialNeedsIsar>()
        .watch(fireImmediately: true)
        .listen((data) async {
      setState(() {
        list = data
            .where((element) => element.person.value!.id == widget.person.id)
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    allowances = context.watch<UserAllowancesProvider>();
    canWrite = allowances.canWrite('user_access_add_people');
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'special_needs'.tr(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (list.isEmpty)
              Text('no_special_needs'.tr())
            else
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final personSpecialNeed = list[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          personSpecialNeed.specialNeed.value?.name ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          personSpecialNeed.description ??
                              'no_description'.tr(),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!personSpecialNeed.isSynced)
                              IconButton(
                                icon: const Icon(Icons.sync_problem,
                                    color: Colors.amber),
                                onPressed: () async {
                                  await syncService.synchronizeAll();
                                  final updatedList = await isarDb
                                      .personSpecialNeedsIsars
                                      .filter()
                                      .person(
                                          (q) => q.idEqualTo(widget.person.id))
                                      .findAll();
                                  setState(() {
                                    list = updatedList;
                                  });
                                },
                              ),
                            if (canWrite) ...[
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  addOrEditSpecialNeed(
                                      personSpecialNeed, null, context);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => ConfirmDialog(
                                      title: 'confirm_delete'.tr(),
                                      content: 'confirm_delete_message'.tr(),
                                    ),
                                  );
                                  if (confirm == true) {
                                    await isarDb.writeTxn(() async {
                                      await isarDb.personSpecialNeedsIsars
                                          .delete(personSpecialNeed.id);
                                    });
                                    final updatedList = await isarDb
                                        .personSpecialNeedsIsars
                                        .filter()
                                        .person((q) =>
                                            q.idEqualTo(widget.person.id))
                                        .findAll();
                                    setState(() {
                                      list = updatedList;
                                    });
                                  }
                                },
                              ),
                            ] else
                              IconButton(
                                icon: const Icon(
                                  Icons.info_outline,
                                  color: Colors.blue,
                                ),
                                onPressed: () => addOrEditSpecialNeed(
                                    personSpecialNeed, null, context),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            if (canWrite) ...[
              ElevatedButton(
                onPressed: () async {
                  final saved =
                      await addOrEditSpecialNeed(null, widget.person, context);
                  if (saved == true) {
                    final updatedList = await isarDb.personSpecialNeedsIsars
                        .filter()
                        .person((q) => q.idEqualTo(widget.person.id))
                        .findAll();
                    setState(() {
                      list = updatedList;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  minimumSize: const Size(60.0, 60.0),
                ),
                child: const Icon(Icons.add, size: 40.0),
              ),
              const SizedBox(height: 16),
            ],
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('close'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> addOrEditSpecialNeed(PersonSpecialNeedsIsar? personSpecialNeed,
      PersonsIsar? person, BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final formKey = GlobalKey<FormState>();
    final personController = personSpecialNeed?.person.value! ?? person;
    SpecialNeedIsar? specialNeedController =
        personSpecialNeed?.specialNeed.value!;
    final descriptionController =
        TextEditingController(text: personSpecialNeed?.description ?? '');
    DateTime? startDate = personSpecialNeed?.startDate ?? DateTime.now();
    DateTime? endDate = personSpecialNeed?.endDate;

    List<TextControllersInputFormConfig> textControllersConfig = [
      TextControllersInputFormConfig(
          controller: descriptionController,
          label: 'description'.tr(),
          validator: (value) {
            return null;
          }),
    ];

    final availableSpecialNeeds = await isarDb.specialNeedIsars
        .filter()
        .startDateLessThan(today.add(const Duration(days: 1)))
        .and()
        .group((q) => q
            .endDateIsNull()
            .or()
            .endDateGreaterThan(today.subtract(const Duration(seconds: 1))))
        .findAll();

    return await showDialog<bool>(
      context: context,
      builder: (context) {
        final allowances = context.watch<UserAllowancesProvider>();

        return StatefulBuilder(builder: (context, setModalState) {
          return AlertDialog(
            title: Text(personSpecialNeed == null
                ? '${'add'.tr()} ${'special_need'.tr()}'
                : '${'edit'.tr()} ${'special_need'.tr()}'),
            content: buildForm(
                formKey, context, textControllersConfig, startDate, endDate,
                (value) {
              setModalState(() => startDate = value);
            }, (value) {
              setModalState(() => endDate = value);
            }, () {
              setModalState(() {
                endDate = null;
              });
            }, [
              customDropdownSearch(
                  enabled: canWrite,
                  itemLabelBuilder: (specialNeed) => specialNeed.name,
                  items: availableSpecialNeeds,
                  selectedItem: specialNeedController,
                  onSelected: (SpecialNeedIsar? value) {
                    setModalState(() {
                      specialNeedController = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'required_field'.tr() : null,
                  label: "${'special_need'.tr()}*")
            ], canWrite: canWrite),
            actions: [
              TextButton(
                child: Text(canWrite ? 'cancel'.tr() : 'close'.tr()),
                onPressed: () => Navigator.pop(context, false),
              ),
              if (canWrite)
                TextButton(
                  child: Text('save'.tr()),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final now = DateTime.now();
                      await isarDb.writeTxn(() async {
                        final newPersonSpecialNeed =
                            personSpecialNeed ?? PersonSpecialNeedsIsar();
                        newPersonSpecialNeed.remoteId =
                            personSpecialNeed?.remoteId ?? 0;
                        newPersonSpecialNeed.person.value = personController;
                        newPersonSpecialNeed.specialNeed.value =
                            specialNeedController;
                        newPersonSpecialNeed.description =
                            descriptionController.text.isEmpty
                                ? null
                                : descriptionController.text;
                        newPersonSpecialNeed.startDate = startDate ?? now;
                        newPersonSpecialNeed.endDate = endDate;
                        newPersonSpecialNeed.createdAt =
                            personSpecialNeed?.createdAt ?? now;
                        newPersonSpecialNeed.lastUpdatedAt = now;
                        newPersonSpecialNeed.isSynced = false;
                        await isarDb.personSpecialNeedsIsars
                            .put(newPersonSpecialNeed);
                        await newPersonSpecialNeed.person.save();
                        await newPersonSpecialNeed.specialNeed.save();
                      });
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, true);
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
