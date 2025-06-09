import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/features/settings/models/building_types/building_types_isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';

class IsarExplorerScreen extends StatefulWidget {
  const IsarExplorerScreen({super.key});

  @override
  State<IsarExplorerScreen> createState() => _IsarExplorerScreenState();
}

class _IsarExplorerScreenState extends State<IsarExplorerScreen> {
  final isar = DatabaseService.db;
  String selectedTable = 'BuildingTypes';
  final formatter = DateFormat('yyyy-MM-dd');

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
                DropdownMenuItem(
                    value: 'BuildingTypes', child: Text("Building Types")),
                DropdownMenuItem(
                    value: 'UserProfiles', child: Text("User Profiles")),
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
                DataColumn(label: Text("Is Sync")),
              ],
              rows: items
                  .map((e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.remoteId.toString())),
                        DataCell(Text(e.name)),
                        DataCell(Text(formatter.format(e.startDate))),
                        DataCell(Text(e.endDate != null
                            ? formatter.format(e.endDate!)
                            : '')),
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
                DataColumn(label: Text("Is Sync")),
              ],
              rows: items
                  .map((e) => DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.remoteId.toString())),
                        DataCell(Text(e.name)),
                        DataCell(Text(formatter.format(e.startDate))),
                        DataCell(Text(e.endDate != null
                            ? formatter.format(e.endDate!)
                            : '')),
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

  Widget _buildDataTable({
    required List<DataColumn> columns,
    required List<DataRow> rows,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(columns: columns, rows: rows),
    );
  }
}

