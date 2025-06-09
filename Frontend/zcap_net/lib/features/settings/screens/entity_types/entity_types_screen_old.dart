/*
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/api_service.dart';
import 'package:zcap_net_app/core/services/database_service.dart';
import 'package:zcap_net_app/core/services/sync_service.dart';
import '../../models/entity_types/entity_type.dart';
import '../../models/entity_types/entity_type_isar.dart';
import 'package:intl/intl.dart';
import './entity_type_list_item_widget.dart';

class EntityTypesScreenOld extends StatefulWidget {
  const EntityTypesScreenOld({super.key});

  @override
  State<EntityTypesScreenOld> createState() => _EntityTypesScreenOldState();
}

class _EntityTypesScreenOldState extends State<EntityTypesScreenOld> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _searchController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  EntityType? _editingEntity;

  List<EntityType> _entityTypes = [];
  bool _isLoading = true;
  String _searchTerm = '';

  late final SyncService syncService;

  @override
  void initState() {
    super.initState();

    syncService = SyncService(DatabaseService.db, () {
      _loadEntityTypes(); // ou usa setState se precisares atualizar outros estados
    });

    syncService.startListening(); // Inicia a sincronização automática
    _loadEntityTypes();
  }

  Future<void> _loadEntityTypes() async {
    try {
      final data = await ApiService.getList(
          'entityTypes', (json) => EntityType.fromJson(json));

      // Save to local database
      for (var entity in data) {
        await DatabaseService.db.writeTxn(() async {
          await DatabaseService.db.entityTypeIsars
              .put(EntityTypeIsar.fromEntityType(entity)..isSynced = true);
        });
      }

      setState(() {
        _entityTypes = data;
        _isLoading = false;
      });
    } catch (e) {
      // Load local offline data
      final localData =
          await DatabaseService.db.entityTypeIsars.where().findAll();

      setState(() {
        _entityTypes = localData.map((e) => e.toEntity()).toList();
        _isLoading = false;
      });
    }
  }

  void _startEditing(EntityType entity) {
    setState(() {
      _editingEntity = entity;
      _nameController.text = entity.name;
      _startDate = entity.startDate;
      _endDate = entity.endDate;
    });
  }

  void _clearForm() {
    setState(() {
      _editingEntity = null;
      _nameController.clear();
      _startDate = null;
      _endDate = null;
    });
  }

  Future<void> _selectDate(bool isStart) async {
    final initial =
        isStart ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2500),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _saveEntity() async {
    if (!_formKey.currentState!.validate() || _startDate == null) return;

    final now = DateTime.now();
    final tempId = DateTime.now().millisecondsSinceEpoch * -1;

    final entity = EntityType(
      id: _editingEntity?.id ?? tempId,
      name: _nameController.text,
      startDate: _startDate!,
      endDate: _endDate,
      createdAt: _editingEntity?.createdAt ?? now,
      updatedAt: now,
      isSynced: false,
    );

    try {
      if (_editingEntity == null) {
        final created =
            await ApiService.post('entityTypes', entity.toJsonInput());
        if (created['entityTypeId'] != null) {
          entity.id = created['entityTypeId'];
          entity.isSynced = true;
        }
      } else {
        await ApiService.put('entityTypes/${entity.id}', entity.toJsonInput());
        entity.isSynced = true;
      }
    } catch (_) {
      // Ignora erro: será sincronizado depois
      entity.isSynced = false;
    }

    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.entityTypeIsars
          .put(EntityTypeIsar.fromEntityType(entity));
    });

    _clearForm();
    await _loadEntityTypes();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final filteredList = _entityTypes.where((e) {
      return e.name.toLowerCase().contains(_searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tipos de Entidade"),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              await syncService.syncNow();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Sincronização manual completa')),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          labelStyle: TextStyle(
                            fontSize: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Campo obrigatório'
                            : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Row(
                            children: [
                              Text(
                                'Data Inicio:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              Text(
                                " ${_startDate != null ? dateFormat.format(_startDate!) : 'yyyy-MM-dd'}",
                                style: TextStyle(fontSize: 20.0),
                              ),
                              TextButton(
                                onPressed: () => _selectDate(true),
                                child: Icon(Icons.calendar_month),
                              ),
                            ],
                          )),
                          VerticalDivider(thickness: 10.0),
                          Expanded(
                              child: Row(
                            children: [
                              Text(
                                'Data Fim:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              Text(
                                " ${_endDate != null ? dateFormat.format(_endDate!) : 'yyyy-MM-dd'}",
                                style: TextStyle(fontSize: 20.0),
                              ),
                              TextButton(
                                onPressed: () => _selectDate(false),
                                child: Icon(Icons.calendar_month),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _saveEntity,
                          child: Text(
                              _editingEntity == null ? "Criar" : "Atualizar"),
                        ),
                        if (_editingEntity != null)
                          TextButton(
                              onPressed: _clearForm,
                              child: const Text("Cancelar"))
                      ],
                    ),
                  ),
                  const Divider(height: 32),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Pesquisar',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchTerm = value.toLowerCase();
                  });
                },
              ),
            ),
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final entity = filteredList[index];
                        return Column(
                          children: [
                            EntityTypeListItem(
                              entityType: entity,
                              dateFormat: dateFormat,
                              onEdit: () => _startEditing(entity),
                            ),
                            const Divider(height: 10),
                          ],
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
*/