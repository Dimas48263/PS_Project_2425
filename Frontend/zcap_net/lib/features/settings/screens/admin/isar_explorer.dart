// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/features/settings/models/incidents/incident_types/incident_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/relation_type/relation_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/people/special_needs/special_needs_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_access_keys_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profile_access_allowance_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';
import 'package:zcap_net_app/features/settings/models/zcaps/building_types/building_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities/entities_isar.dart';
import 'package:zcap_net_app/features/settings/models/entities/entity_types/entity_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_levels/tree_level_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_detail_types/tree_record_detail_type_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_details/tree_record_detail_isar.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/users/users_isar.dart';

class IsarExplorerScreen extends StatefulWidget {
  const IsarExplorerScreen({super.key});

  @override
  State<IsarExplorerScreen> createState() => _IsarExplorerScreenState();
}

class _IsarExplorerScreenState extends State<IsarExplorerScreen> {
  final isar = DatabaseService.db;
  String selectedTable = 'EntityTypes';
  final smallDate = DateFormat('yyyy-MM-dd');
  final fullDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Explorador Isar")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButton<String>(
              value: selectedTable,
              items: const [
                DropdownMenuItem(value: 'tree', child: Text("Tree")),
                DropdownMenuItem(
                    value: 'treeLevels', child: Text("Tree Levels")),
                DropdownMenuItem(
                    value: 'treeRecordDetailTypes',
                    child: Text("Tree Record Detail Types")),
                DropdownMenuItem(
                    value: 'treeRecordDetails',
                    child: Text("Tree Record Details")),
                DropdownMenuItem(value: 'Users', child: Text("Users")),
                DropdownMenuItem(
                    value: 'UserProfiles', child: Text("User Profiles")),
                DropdownMenuItem(
                    value: 'UserAccessKeys', child: Text("User Access Keys")),
                DropdownMenuItem(
                    value: 'UserAccessAllowances',
                    child: Text("User Access Allowances")),
                DropdownMenuItem(
                    value: 'EntityTypes', child: Text("Entity Types")),
                DropdownMenuItem(value: 'Entities', child: Text("Entities")),
                DropdownMenuItem(
                    value: 'BuildingTypes', child: Text("Building Types")),
                 DropdownMenuItem(
                    value: 'IncidentTypes', child: Text("Incident Types")),
                DropdownMenuItem(
                    value: 'RelationTypes', child: Text("Relation Types")),
                DropdownMenuItem(
                    value: 'SpecialNeeds', child: Text("Special Need Types")),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedTable = value;
                  });
                }
              },
            ),
          ),
          Expanded(child: _buildSelectedTableView()),
        ],
      ),
    );
  }

  Widget _buildSelectedTableView() {
    switch (selectedTable) {
      case 'tree':
        return FutureBuilder<List<TreeIsar>>(
          future: () async {
            final trees = await isar.treeIsars.where().findAll();

            for (final tree in trees) {
              await tree.treeLevel.load(); // <- obrigatório
              await tree.parent.load(); // <- se também usares o parent
            }

            return trees;
          }(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            final items = snapshot.data!;
            return _buildDataTable(
              columns: const [
                DataColumn(label: Text("ID")),
                DataColumn(label: Text("RemoteId")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("TreeLevelId")),
                DataColumn(label: Text("Start Date")),
                DataColumn(label: Text("End Date")),
                DataColumn(label: Text("Created at")),
                DataColumn(label: Text("Updated at")),
                DataColumn(label: Text("Is Sync")),
              ],
              rows: items
                  .map((e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.remoteId.toString())),
                        DataCell(Text(e.name)),
                        DataCell(Text(e.treeLevel.value?.id.toString() ?? '')),
                        DataCell(Text(smallDate.format(e.startDate))),
                        DataCell(Text(e.endDate != null
                            ? smallDate.format(e.endDate!)
                            : '')),
                        DataCell(Text(smallDate.format(e.createdAt))),
                        DataCell(Text(fullDate.format(e.lastUpdatedAt))),
                        DataCell(Text(e.isSynced.toString())),
                      ]))
                  .toList(),
            );
          },
        );
      case 'treeLevels':
        return FutureBuilder<List<TreeLevelIsar>>(
          future: isar.treeLevelIsars.where().findAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            final items = snapshot.data!;
            return _buildDataTable(
              columns: const [
                DataColumn(label: Text("ID")),
                DataColumn(label: Text("RemoteId")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Start Date")),
                DataColumn(label: Text("End Date")),
                DataColumn(label: Text("Created at")),
                DataColumn(label: Text("Updated at")),
                DataColumn(label: Text("Is Sync")),
              ],
              rows: items
                  .map((e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.remoteId.toString())),
                        DataCell(Text(e.name)),
                        DataCell(Text(smallDate.format(e.startDate))),
                        DataCell(Text(e.endDate != null
                            ? smallDate.format(e.endDate!)
                            : '')),
                        DataCell(Text(smallDate.format(e.createdAt))),
                        DataCell(Text(fullDate.format(e.lastUpdatedAt))),
                        DataCell(Text(e.isSynced.toString())),
                      ]))
                  .toList(),
            );
          },
        );
      case 'treeRecordDetailTypes':
        return FutureBuilder<List<TreeRecordDetailTypeIsar>>(
          future: isar.treeRecordDetailTypeIsars.where().findAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            final items = snapshot.data!;
            return _buildDataTable(
              columns: const [
                DataColumn(label: Text("ID")),
                DataColumn(label: Text("RemoteId")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Start Date")),
                DataColumn(label: Text("End Date")),
                DataColumn(label: Text("Created at")),
                DataColumn(label: Text("Updated at")),
                DataColumn(label: Text("Is Sync")),
              ],
              rows: items
                  .map((e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.remoteId.toString())),
                        DataCell(Text(e.name)),
                        DataCell(Text(smallDate.format(e.startDate))),
                        DataCell(Text(e.endDate != null
                            ? smallDate.format(e.endDate!)
                            : '')),
                        DataCell(Text(smallDate.format(e.createdAt))),
                        DataCell(Text(fullDate.format(e.lastUpdatedAt))),
                        DataCell(Text(e.isSynced.toString())),
                      ]))
                  .toList(),
            );
          },
        );
      case 'treeRecordDetails':
        return FutureBuilder<List<TreeRecordDetailIsar>>(
          future: () async {
            final details = await isar.treeRecordDetailIsars.where().findAll();

            for (final detail in details) {
              await detail.tree.load();
              await detail.detailType.load();
            }

            return details;
          }(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            final items = snapshot.data!;
            return _buildDataTable(
              columns: const [
                DataColumn(label: Text("ID")),
                DataColumn(label: Text("RemoteId")),
                DataColumn(label: Text("ValueCol")),
                DataColumn(label: Text("TreeId")),
                DataColumn(label: Text("DetailTypeId")),
                DataColumn(label: Text("Start Date")),
                DataColumn(label: Text("End Date")),
                DataColumn(label: Text("Created at")),
                DataColumn(label: Text("Updated at")),
                DataColumn(label: Text("Is Sync")),
              ],
              rows: items
                  .map((e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.remoteId.toString())),
                        DataCell(Text(e.valueCol)),
                        DataCell(Text(e.tree.value?.id.toString() ?? '')),
                        DataCell(Text(e.detailType.value?.id.toString() ?? '')),
                        DataCell(Text(smallDate.format(e.startDate))),
                        DataCell(Text(e.endDate != null
                            ? smallDate.format(e.endDate!)
                            : '')),
                        DataCell(Text(smallDate.format(e.createdAt))),
                        DataCell(Text(fullDate.format(e.lastUpdatedAt))),
                        DataCell(Text(e.isSynced.toString())),
                      ]))
                  .toList(),
            );
          },
        );

      case 'Users':
        return FutureBuilder<List<UsersIsar>>(
          future: isar.usersIsars.where().findAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            final items = snapshot.data!;
            return _buildDataTable(
              columns: const [
                DataColumn(label: Text("ID")),
                DataColumn(label: Text("RemoteId")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Start Date")),
                DataColumn(label: Text("End Date")),
                DataColumn(label: Text("Created at")),
                DataColumn(label: Text("Updated at")),
                DataColumn(label: Text("Is Sync")),
              ],
              rows: items
                  .map((e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.remoteId.toString())),
                        DataCell(Text(e.name)),
                        DataCell(Text(smallDate.format(e.startDate))),
                        DataCell(Text(e.endDate != null
                            ? smallDate.format(e.endDate!)
                            : '')),
                        DataCell(Text(smallDate.format(e.createdAt))),
                        DataCell(Text(fullDate.format(e.lastUpdatedAt))),
                        DataCell(Text(e.isSynced.toString())),
                      ]))
                  .toList(),
            );
          },
        );
      case 'UserProfiles':
        return FutureBuilder<List<UserProfilesIsar>>(
          future: isar.userProfilesIsars.where().findAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            final items = snapshot.data!;
            return _buildDataTable(
              columns: const [
                DataColumn(label: Text("Local ID")),
                DataColumn(label: Text("Remote Id")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Start Date")),
                DataColumn(label: Text("End Date")),
                DataColumn(label: Text("Created at")),
                DataColumn(label: Text("Updated at")),
                DataColumn(label: Text("Is Sync")),
              ],
              rows: items
                  .map((e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.remoteId.toString())),
                        DataCell(Text(e.name)),
                        DataCell(Text(smallDate.format(e.startDate))),
                        DataCell(Text(e.endDate != null
                            ? smallDate.format(e.endDate!)
                            : '')),
                        DataCell(Text(smallDate.format(e.createdAt))),
                        DataCell(Text(fullDate.format(e.lastUpdatedAt))),
                        DataCell(Text(e.isSynced.toString())),
                      ]))
                  .toList(),
            );
          },
        );

      case 'UserAccessKeys':
        return FutureBuilder<List<UserAccessKeysIsar>>(
          future: isar.userAccessKeysIsars.where().findAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            final items = snapshot.data!;
            return _buildDataTable(
              columns: const [
                DataColumn(label: Text("Local ID")),
                DataColumn(label: Text("Remote Id")),
                DataColumn(label: Text("Key name")),
                DataColumn(label: Text("Descriprion")),
                DataColumn(label: Text("Created at")),
                DataColumn(label: Text("Updated at")),
                DataColumn(label: Text("Is Sync")),
              ],
              rows: items
                  .map((e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.remoteId.toString())),
                        DataCell(Text(e.accessKey)),
                        DataCell(Text(e.description)),
                        DataCell(Text(smallDate.format(e.createdAt))),
                        DataCell(Text(fullDate.format(e.lastUpdatedAt))),
                        DataCell(Text(e.isSynced.toString())),
                      ]))
                  .toList(),
            );
          },
        );

case 'UserAccessAllowances':
  return FutureBuilder<List<UserProfileAccessAllowanceIsar>>(
    future: () async {
      final profiles = await isar.userProfilesIsars.where().findAll();
      final List<UserProfileAccessAllowanceIsar> allAllowances = [];

      for (final profile in profiles) {
        await profile.accessAllowances.load();
        allAllowances.addAll(profile.accessAllowances.toList());
      }

      // Carrega os links dos allowances
      for (final allowance in allAllowances) {
        await allowance.userProfile.load();
      }

      return allAllowances;
    }(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }

      final items = snapshot.data!;
      return _buildDataTable(
        columns: const [
          DataColumn(label: Text("ID")),
          DataColumn(label: Text("UserProfileId")),
          DataColumn(label: Text("AccessKeyId")),
          DataColumn(label: Text("Access Type")),
        ],
        rows: items.map((e) => DataRow(cells: [
          DataCell(Text(e.id.toString())),
          DataCell(Text(e.userProfile.value?.id.toString() ?? '')),
          DataCell(Text(e.key)),
          DataCell(Text(e.accessTypeIndex.toString())),
        ])).toList(),
      );
    },
  );
      case 'EntityTypes':
        return FutureBuilder<List<EntityTypeIsar>>(
          future: isar.entityTypeIsars.where().findAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            final items = snapshot.data!;
            return _buildDataTable(
              columns: const [
                DataColumn(label: Text("Local ID")),
                DataColumn(label: Text("Remote Id")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Start Date")),
                DataColumn(label: Text("End Date")),
                DataColumn(label: Text("Created at")),
                DataColumn(label: Text("Updated at")),
                DataColumn(label: Text("Is Sync")),
              ],
              rows: items
                  .map((e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.remoteId.toString())),
                        DataCell(Text(e.name)),
                        DataCell(Text(smallDate.format(e.startDate))),
                        DataCell(Text(e.endDate != null
                            ? smallDate.format(e.endDate!)
                            : '')),
                        DataCell(Text(smallDate.format(e.createdAt))),
                        DataCell(Text(fullDate.format(e.lastUpdatedAt))),
                        DataCell(Text(e.isSynced.toString())),
                      ]))
                  .toList(),
            );
          },
        );

      case 'Entities':
        return FutureBuilder<List<EntitiesIsar>>(
          future: () async {
            final items = await isar.entitiesIsars.where().findAll();
            await Future.wait(items.map((e) => e.entityType.load()));
            return items;
          }(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            final items = snapshot.data!;
            return _buildDataTable(
              columns: const [
                DataColumn(label: Text("Local ID")),
                DataColumn(label: Text("Remote Id")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Entity Type Local Code")),
                DataColumn(label: Text("Entity Type Api Code")),
                DataColumn(label: Text("Start Date")),
                DataColumn(label: Text("End Date")),
                DataColumn(label: Text("Created at")),
                DataColumn(label: Text("Updated at")),
                DataColumn(label: Text("Is Sync")),
              ],
              rows: items.map((e) {
                final entityType = e.entityType.value;
                return DataRow(cells: [
                  DataCell(Text(e.id.toString())),
                  DataCell(Text(e.remoteId.toString())),
                  DataCell(Text(e.name)),
                  DataCell(Text(entityType?.id.toString() ?? '')),
                  DataCell(Text(entityType?.remoteId.toString() ?? '')),
                  DataCell(Text(smallDate.format(e.startDate))),
                  DataCell(Text(
                      e.endDate != null ? smallDate.format(e.endDate!) : '')),
                  DataCell(Text(smallDate.format(e.createdAt))),
                  DataCell(Text(fullDate.format(e.lastUpdatedAt))),
                  DataCell(Text(e.isSynced.toString())),
                ]);
              }).toList(),
            );
          },
        );

      case 'BuildingTypes':
        return FutureBuilder<List<BuildingTypesIsar>>(
          future: isar.buildingTypesIsars.where().findAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            final items = snapshot.data!;
            return _buildDataTable(
              columns: const [
                DataColumn(label: Text("ID")),
                DataColumn(label: Text("RemoteId")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Start Date")),
                DataColumn(label: Text("End Date")),
                DataColumn(label: Text("Created at")),
                DataColumn(label: Text("Updated at")),
                DataColumn(label: Text("Is Sync")),
              ],
              rows: items
                  .map((e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.remoteId.toString())),
                        DataCell(Text(e.name)),
                        DataCell(Text(smallDate.format(e.startDate))),
                        DataCell(Text(e.endDate != null
                            ? smallDate.format(e.endDate!)
                            : '')),
                        DataCell(Text(smallDate.format(e.createdAt))),
                        DataCell(Text(fullDate.format(e.lastUpdatedAt))),
                        DataCell(Text(e.isSynced.toString())),
                      ]))
                  .toList(),
            );
          },
        );

      case 'IncidentTypes':
        return FutureBuilder<List<IncidentTypesIsar>>(
          future: isar.incidentTypesIsars.where().findAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            final items = snapshot.data!;
            return _buildDataTable(
              columns: const [
                DataColumn(label: Text("ID")),
                DataColumn(label: Text("RemoteId")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Start Date")),
                DataColumn(label: Text("End Date")),
                DataColumn(label: Text("Created at")),
                DataColumn(label: Text("Updated at")),
                DataColumn(label: Text("Is Sync")),
              ],
              rows: items
                  .map((e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.remoteId.toString())),
                        DataCell(Text(e.name)),
                        DataCell(Text(smallDate.format(e.startDate))),
                        DataCell(Text(e.endDate != null
                            ? smallDate.format(e.endDate!)
                            : '')),
                        DataCell(Text(smallDate.format(e.createdAt))),
                        DataCell(Text(fullDate.format(e.lastUpdatedAt))),
                        DataCell(Text(e.isSynced.toString())),
                      ]))
                  .toList(),
            );
          },
        );

      case 'RelationTypes':
        return FutureBuilder<List<RelationTypeIsar>>(
          future: isar.relationTypeIsars.where().findAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            final items = snapshot.data!;
            return _buildDataTable(
              columns: const [
                DataColumn(label: Text("ID")),
                DataColumn(label: Text("RemoteId")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Start Date")),
                DataColumn(label: Text("End Date")),
                DataColumn(label: Text("Created at")),
                DataColumn(label: Text("Updated at")),
                DataColumn(label: Text("Is Sync")),
              ],
              rows: items
                  .map((e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.remoteId.toString())),
                        DataCell(Text(e.name)),
                        DataCell(Text(smallDate.format(e.startDate))),
                        DataCell(Text(e.endDate != null
                            ? smallDate.format(e.endDate!)
                            : '')),
                        DataCell(Text(smallDate.format(e.createdAt))),
                        DataCell(Text(fullDate.format(e.lastUpdatedAt))),
                        DataCell(Text(e.isSynced.toString())),
                      ]))
                  .toList(),
            );
          },
        );
      case 'SpecialNeeds':
        return FutureBuilder<List<SpecialNeedIsar>>(
          future: isar.specialNeedIsars.where().findAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            final items = snapshot.data!;
            return _buildDataTable(
              columns: const [
                DataColumn(label: Text("ID")),
                DataColumn(label: Text("RemoteId")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Start Date")),
                DataColumn(label: Text("End Date")),
                DataColumn(label: Text("Created at")),
                DataColumn(label: Text("Updated at")),
                DataColumn(label: Text("Is Sync")),
              ],
              rows: items
                  .map((e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.remoteId.toString())),
                        DataCell(Text(e.name)),
                        DataCell(Text(smallDate.format(e.startDate))),
                        DataCell(Text(e.endDate != null
                            ? smallDate.format(e.endDate!)
                            : '')),
                        DataCell(Text(smallDate.format(e.createdAt))),
                        DataCell(Text(fullDate.format(e.lastUpdatedAt))),
                        DataCell(Text(e.isSynced.toString())),
                      ]))
                  .toList(),
            );
          },
        );
      default:
        return const Center(child: Text("Tabela não suportada."));
    }
  }
}

Widget _buildDataTable({
  required List<DataColumn> columns,
  required List<DataRow> rows,
}) {
  return DataTable2(
    columns: columns,
    rows: rows,
    columnSpacing: 12,
    horizontalMargin: 12,
    minWidth: 600,
    headingRowHeight: 56,
    dataRowHeight: 56,
    dividerThickness: 1,
    isHorizontalScrollBarVisible: true,
    isVerticalScrollBarVisible: true,
  );
}
