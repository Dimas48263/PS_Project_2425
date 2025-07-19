import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/features/settings/models/people/persons/persons_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/relation_type/relation_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/relations/relations_isar.dart';
import 'package:zcap_net_app/widgets/confirm_dialog.dart';
import 'package:zcap_net_app/widgets/custom_dropdown_search.dart';

class FamilyMembersDialogs extends StatefulWidget {
  final PersonsIsar person;
  final List<PersonsIsar> personsInZcap;
  const FamilyMembersDialogs(
      {super.key, required this.person, required this.personsInZcap});
  @override
  State<FamilyMembersDialogs> createState() => _FamilyMembersDialogsState();
}

class _FamilyMembersDialogsState extends State<FamilyMembersDialogs> {
  List<RelationsIsar> relations = [];
  StreamSubscription? _subscription;

  late UserAllowancesProvider allowances;
  late bool canWrite;

  @override
  void initState() {
    super.initState();
    _subscription = isarDb.relationsIsars
        .buildQuery<RelationsIsar>()
        .watch(fireImmediately: true)
        .listen((data) async {
      setState(() {
        relations = data
            .where((element) => element.person2.value!.id == widget.person.id)
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'family_members_from'.tr(namedArgs: {'name': widget.person.name}),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (relations.isEmpty)
              Text('no_family_members'.tr())
            else
              SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: relations.length,
                  itemBuilder: (context, index) {
                    final relation = relations[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                            '${'name'.tr()}: ${relation.person1.value!.name}'),
                        subtitle: Text(
                            '${'relation'.tr()}: ${relation.relationType.value!.name}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!relation.isSynced)
                              IconButton(
                                icon: const Icon(Icons.sync_problem,
                                    color: Colors.amber),
                                onPressed: () async {
                                  await syncService.synchronizeAll();
                                  final updatedList = await isarDb
                                      .relationsIsars
                                      .filter()
                                      .person2(
                                          (q) => q.idEqualTo(widget.person.id))
                                      .findAll();
                                  setState(() {
                                    relations = updatedList;
                                  });
                                },
                              ),
                            if (canWrite)
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
                                    final otherRelation = await isarDb
                                        .relationsIsars
                                        .filter()
                                        .person1((q) => q.idEqualTo(
                                            relation.person2.value!.id))
                                        .and()
                                        .person2((q) => q.idEqualTo(
                                            relation.person1.value!.id))
                                        .findFirst();
                                    await isarDb.writeTxn(() async {
                                      await isarDb.relationsIsars
                                          .delete(relation.id);
                                      await isarDb.relationsIsars
                                          .delete(otherRelation!.id);
                                    });
                                    final updatedList = await isarDb
                                        .relationsIsars
                                        .filter()
                                        .person2((q) =>
                                            q.idEqualTo(widget.person.id))
                                        .findAll();
                                    setState(() {
                                      relations = updatedList;
                                    });
                                  }
                                },
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 10),
            if (canWrite)
              IconButton(
                  onPressed: () async {
                    final saved = await _addRelation(context);
                    if (saved == true) {
                      final updatedList = await isarDb.relationsIsars
                          .filter()
                          .person2((q) => q.idEqualTo(widget.person.id))
                          .findAll();
                      setState(() {
                        relations = updatedList;
                      });
                    }
                  },
                  icon: const Icon(Icons.add)),
            const SizedBox(height: 10),
            ElevatedButton(
              child: Text('close'.tr()),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _addRelation(BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final formKey = GlobalKey<FormState>();
    final person1 = widget.person;
    PersonsIsar? person2;
    RelationTypeIsar? relationType12;
    RelationTypeIsar? relationType21;

    final availableRelationTypes = await isarDb.relationTypeIsars
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
          return StatefulBuilder(builder: (context, setModalState) {
            return AlertDialog(
              title: Text('${'add'.tr()} ${'family_member'.tr()}'),
              content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          enabled: false,
                          initialValue: person1.name,
                          decoration: InputDecoration(labelText: 'name'.tr()),
                        ),
                        customDropdownSearch<RelationTypeIsar>(
                            itemLabelBuilder: (value) => value.name,
                            label: 'relation'.tr(),
                            items: availableRelationTypes,
                            selectedItem: relationType12,
                            onSelected: (RelationTypeIsar? value) {
                              setModalState(() {
                                relationType12 = value;
                              });
                            },
                            validator: (value) =>
                                value == null ? 'required_field'.tr() : null),
                        customDropdownSearch<PersonsIsar>(
                            itemLabelBuilder: (value) => value.name,
                            label: 'person'.tr(),
                            items: widget.personsInZcap
                                .where((element) => element.id != person1.id)
                                .toList(),
                            selectedItem: person2,
                            onSelected: (PersonsIsar? value) {
                              setModalState(() {
                                person2 = value;
                              });
                            },
                            validator: (value) =>
                                value == null ? 'required_field'.tr() : null),
                        customDropdownSearch<RelationTypeIsar>(
                            itemLabelBuilder: (value) => value.name,
                            justLabel: true,
                            label: 'relation_with'
                                .tr(namedArgs: {'name': person1.name}),
                            items: availableRelationTypes,
                            selectedItem: relationType21,
                            onSelected: (RelationTypeIsar? value) {
                              setModalState(() {
                                relationType21 = value;
                              });
                            },
                            validator: (value) =>
                                value == null ? 'required_field'.tr() : null),
                      ],
                    ),
                  )),
              actions: [
                TextButton(
                    child: Text('cancel'.tr()),
                    onPressed: () => Navigator.of(context).pop(false)),
                TextButton(
                    child: Text('save'.tr()),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final now = DateTime.now();
                        await isarDb.writeTxn(() async {
                          final newRelation1 = RelationsIsar()
                            ..remoteId = 0
                            ..person1.value = person1
                            ..person2.value = person2
                            ..relationType.value = relationType12
                            ..createdAt = now
                            ..lastUpdatedAt = now
                            ..isSynced = false;

                          await isarDb.relationsIsars.put(newRelation1);
                          await newRelation1.person1.save();
                          await newRelation1.person2.save();
                          await newRelation1.relationType.save();

                          final newRelation2 = RelationsIsar()
                            ..remoteId = 0
                            ..person1.value = person2
                            ..person2.value = person1
                            ..relationType.value = relationType21
                            ..createdAt = now
                            ..lastUpdatedAt = now
                            ..isSynced = false;

                          await isarDb.relationsIsars.put(newRelation2);
                          await newRelation2.person1.save();
                          await newRelation2.person2.save();
                          await newRelation2.relationType.save();
                        });

                        Navigator.of(context).pop(true);
                      }
                    })
              ],
            );
          });
        });
  }
}
