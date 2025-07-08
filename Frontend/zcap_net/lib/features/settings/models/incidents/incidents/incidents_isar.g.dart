// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incidents_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIncidentsIsarCollection on Isar {
  IsarCollection<IncidentsIsar> get incidentsIsars => this.collection();
}

const IncidentsIsarSchema = CollectionSchema(
  name: r'IncidentsIsar',
  id: -5852499298034569197,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'endDate': PropertySchema(
      id: 1,
      name: r'endDate',
      type: IsarType.dateTime,
    ),
    r'isSynced': PropertySchema(
      id: 2,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'lastUpdatedAt': PropertySchema(
      id: 3,
      name: r'lastUpdatedAt',
      type: IsarType.dateTime,
    ),
    r'remoteId': PropertySchema(
      id: 4,
      name: r'remoteId',
      type: IsarType.long,
    ),
    r'startDate': PropertySchema(
      id: 5,
      name: r'startDate',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _incidentsIsarEstimateSize,
  serialize: _incidentsIsarSerialize,
  deserialize: _incidentsIsarDeserialize,
  deserializeProp: _incidentsIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'remoteId': IndexSchema(
      id: 6301175856541681032,
      name: r'remoteId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'remoteId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'startDate': IndexSchema(
      id: 7723980484494730382,
      name: r'startDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'startDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'endDate': IndexSchema(
      id: 422088669960424970,
      name: r'endDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'endDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'incidentType': LinkSchema(
      id: 1372434000020016993,
      name: r'incidentType',
      target: r'IncidentTypesIsar',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _incidentsIsarGetId,
  getLinks: _incidentsIsarGetLinks,
  attach: _incidentsIsarAttach,
  version: '3.1.0+1',
);

int _incidentsIsarEstimateSize(
  IncidentsIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _incidentsIsarSerialize(
  IncidentsIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDateTime(offsets[1], object.endDate);
  writer.writeBool(offsets[2], object.isSynced);
  writer.writeDateTime(offsets[3], object.lastUpdatedAt);
  writer.writeLong(offsets[4], object.remoteId);
  writer.writeDateTime(offsets[5], object.startDate);
}

IncidentsIsar _incidentsIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IncidentsIsar();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.endDate = reader.readDateTimeOrNull(offsets[1]);
  object.id = id;
  object.isSynced = reader.readBool(offsets[2]);
  object.lastUpdatedAt = reader.readDateTime(offsets[3]);
  object.remoteId = reader.readLongOrNull(offsets[4]);
  object.startDate = reader.readDateTime(offsets[5]);
  return object;
}

P _incidentsIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _incidentsIsarGetId(IncidentsIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _incidentsIsarGetLinks(IncidentsIsar object) {
  return [object.incidentType];
}

void _incidentsIsarAttach(
    IsarCollection<dynamic> col, Id id, IncidentsIsar object) {
  object.id = id;
  object.incidentType.attach(
      col, col.isar.collection<IncidentTypesIsar>(), r'incidentType', id);
}

extension IncidentsIsarQueryWhereSort
    on QueryBuilder<IncidentsIsar, IncidentsIsar, QWhere> {
  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhere> anyRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'remoteId'),
      );
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhere> anyStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'startDate'),
      );
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhere> anyEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'endDate'),
      );
    });
  }
}

extension IncidentsIsarQueryWhere
    on QueryBuilder<IncidentsIsar, IncidentsIsar, QWhereClause> {
  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause>
      remoteIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'remoteId',
        value: [null],
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause>
      remoteIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'remoteId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause> remoteIdEqualTo(
      int? remoteId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'remoteId',
        value: [remoteId],
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause>
      remoteIdNotEqualTo(int? remoteId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [],
              upper: [remoteId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [remoteId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [remoteId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [],
              upper: [remoteId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause>
      remoteIdGreaterThan(
    int? remoteId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'remoteId',
        lower: [remoteId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause>
      remoteIdLessThan(
    int? remoteId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'remoteId',
        lower: [],
        upper: [remoteId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause> remoteIdBetween(
    int? lowerRemoteId,
    int? upperRemoteId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'remoteId',
        lower: [lowerRemoteId],
        includeLower: includeLower,
        upper: [upperRemoteId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause>
      startDateEqualTo(DateTime startDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'startDate',
        value: [startDate],
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause>
      startDateNotEqualTo(DateTime startDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startDate',
              lower: [],
              upper: [startDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startDate',
              lower: [startDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startDate',
              lower: [startDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startDate',
              lower: [],
              upper: [startDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause>
      startDateGreaterThan(
    DateTime startDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startDate',
        lower: [startDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause>
      startDateLessThan(
    DateTime startDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startDate',
        lower: [],
        upper: [startDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause>
      startDateBetween(
    DateTime lowerStartDate,
    DateTime upperStartDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startDate',
        lower: [lowerStartDate],
        includeLower: includeLower,
        upper: [upperStartDate],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause>
      endDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'endDate',
        value: [null],
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause>
      endDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'endDate',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause> endDateEqualTo(
      DateTime? endDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'endDate',
        value: [endDate],
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause>
      endDateNotEqualTo(DateTime? endDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'endDate',
              lower: [],
              upper: [endDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'endDate',
              lower: [endDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'endDate',
              lower: [endDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'endDate',
              lower: [],
              upper: [endDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause>
      endDateGreaterThan(
    DateTime? endDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'endDate',
        lower: [endDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause> endDateLessThan(
    DateTime? endDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'endDate',
        lower: [],
        upper: [endDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterWhereClause> endDateBetween(
    DateTime? lowerEndDate,
    DateTime? upperEndDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'endDate',
        lower: [lowerEndDate],
        includeLower: includeLower,
        upper: [upperEndDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IncidentsIsarQueryFilter
    on QueryBuilder<IncidentsIsar, IncidentsIsar, QFilterCondition> {
  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      endDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endDate',
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      endDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endDate',
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      endDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      endDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      endDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      endDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      lastUpdatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      lastUpdatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      lastUpdatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      lastUpdatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      remoteIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'remoteId',
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      remoteIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'remoteId',
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      remoteIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: value,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      remoteIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remoteId',
        value: value,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      remoteIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remoteId',
        value: value,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      remoteIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remoteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      startDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      startDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      startDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      startDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IncidentsIsarQueryObject
    on QueryBuilder<IncidentsIsar, IncidentsIsar, QFilterCondition> {}

extension IncidentsIsarQueryLinks
    on QueryBuilder<IncidentsIsar, IncidentsIsar, QFilterCondition> {
  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      incidentType(FilterQuery<IncidentTypesIsar> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'incidentType');
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterFilterCondition>
      incidentTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'incidentType', 0, true, 0, true);
    });
  }
}

extension IncidentsIsarQuerySortBy
    on QueryBuilder<IncidentsIsar, IncidentsIsar, QSortBy> {
  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy> sortByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy> sortByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy>
      sortByLastUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy>
      sortByLastUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy> sortByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy>
      sortByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy> sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy>
      sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }
}

extension IncidentsIsarQuerySortThenBy
    on QueryBuilder<IncidentsIsar, IncidentsIsar, QSortThenBy> {
  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy> thenByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy> thenByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy>
      thenByLastUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy>
      thenByLastUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy> thenByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy>
      thenByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy> thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QAfterSortBy>
      thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }
}

extension IncidentsIsarQueryWhereDistinct
    on QueryBuilder<IncidentsIsar, IncidentsIsar, QDistinct> {
  QueryBuilder<IncidentsIsar, IncidentsIsar, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QDistinct> distinctByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endDate');
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QDistinct> distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QDistinct>
      distinctByLastUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdatedAt');
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QDistinct> distinctByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteId');
    });
  }

  QueryBuilder<IncidentsIsar, IncidentsIsar, QDistinct> distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate');
    });
  }
}

extension IncidentsIsarQueryProperty
    on QueryBuilder<IncidentsIsar, IncidentsIsar, QQueryProperty> {
  QueryBuilder<IncidentsIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IncidentsIsar, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<IncidentsIsar, DateTime?, QQueryOperations> endDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endDate');
    });
  }

  QueryBuilder<IncidentsIsar, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<IncidentsIsar, DateTime, QQueryOperations>
      lastUpdatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdatedAt');
    });
  }

  QueryBuilder<IncidentsIsar, int?, QQueryOperations> remoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteId');
    });
  }

  QueryBuilder<IncidentsIsar, DateTime, QQueryOperations> startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }
}
