// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcap_details_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetZcapDetailsIsarCollection on Isar {
  IsarCollection<ZcapDetailsIsar> get zcapDetailsIsars => this.collection();
}

const ZcapDetailsIsarSchema = CollectionSchema(
  name: r'ZcapDetailsIsar',
  id: -2218705010570395033,
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
    ),
    r'valueCol': PropertySchema(
      id: 6,
      name: r'valueCol',
      type: IsarType.string,
    )
  },
  estimateSize: _zcapDetailsIsarEstimateSize,
  serialize: _zcapDetailsIsarSerialize,
  deserialize: _zcapDetailsIsarDeserialize,
  deserializeProp: _zcapDetailsIsarDeserializeProp,
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
    )
  },
  links: {
    r'zcap': LinkSchema(
      id: 2014758399546240247,
      name: r'zcap',
      target: r'ZcapIsar',
      single: true,
    ),
    r'zcapDetailType': LinkSchema(
      id: 9004410228663231591,
      name: r'zcapDetailType',
      target: r'ZcapDetailTypeIsar',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _zcapDetailsIsarGetId,
  getLinks: _zcapDetailsIsarGetLinks,
  attach: _zcapDetailsIsarAttach,
  version: '3.1.0+1',
);

int _zcapDetailsIsarEstimateSize(
  ZcapDetailsIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.valueCol.length * 3;
  return bytesCount;
}

void _zcapDetailsIsarSerialize(
  ZcapDetailsIsar object,
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
  writer.writeString(offsets[6], object.valueCol);
}

ZcapDetailsIsar _zcapDetailsIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ZcapDetailsIsar();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.endDate = reader.readDateTimeOrNull(offsets[1]);
  object.id = id;
  object.isSynced = reader.readBool(offsets[2]);
  object.lastUpdatedAt = reader.readDateTime(offsets[3]);
  object.remoteId = reader.readLongOrNull(offsets[4]);
  object.startDate = reader.readDateTime(offsets[5]);
  object.valueCol = reader.readString(offsets[6]);
  return object;
}

P _zcapDetailsIsarDeserializeProp<P>(
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
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _zcapDetailsIsarGetId(ZcapDetailsIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _zcapDetailsIsarGetLinks(ZcapDetailsIsar object) {
  return [object.zcap, object.zcapDetailType];
}

void _zcapDetailsIsarAttach(
    IsarCollection<dynamic> col, Id id, ZcapDetailsIsar object) {
  object.id = id;
  object.zcap.attach(col, col.isar.collection<ZcapIsar>(), r'zcap', id);
  object.zcapDetailType.attach(
      col, col.isar.collection<ZcapDetailTypeIsar>(), r'zcapDetailType', id);
}

extension ZcapDetailsIsarQueryWhereSort
    on QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QWhere> {
  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterWhere> anyRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'remoteId'),
      );
    });
  }
}

extension ZcapDetailsIsarQueryWhere
    on QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QWhereClause> {
  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterWhereClause> idBetween(
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterWhereClause>
      remoteIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'remoteId',
        value: [null],
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterWhereClause>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterWhereClause>
      remoteIdEqualTo(int? remoteId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'remoteId',
        value: [remoteId],
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterWhereClause>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterWhereClause>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterWhereClause>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterWhereClause>
      remoteIdBetween(
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
}

extension ZcapDetailsIsarQueryFilter
    on QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QFilterCondition> {
  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      endDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endDate',
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      endDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endDate',
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      endDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      lastUpdatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      remoteIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'remoteId',
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      remoteIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'remoteId',
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      remoteIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: value,
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      startDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
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

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      valueColEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'valueCol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      valueColGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'valueCol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      valueColLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'valueCol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      valueColBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'valueCol',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      valueColStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'valueCol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      valueColEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'valueCol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      valueColContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'valueCol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      valueColMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'valueCol',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      valueColIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'valueCol',
        value: '',
      ));
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      valueColIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'valueCol',
        value: '',
      ));
    });
  }
}

extension ZcapDetailsIsarQueryObject
    on QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QFilterCondition> {}

extension ZcapDetailsIsarQueryLinks
    on QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QFilterCondition> {
  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition> zcap(
      FilterQuery<ZcapIsar> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'zcap');
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      zcapIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'zcap', 0, true, 0, true);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      zcapDetailType(FilterQuery<ZcapDetailTypeIsar> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'zcapDetailType');
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterFilterCondition>
      zcapDetailTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'zcapDetailType', 0, true, 0, true);
    });
  }
}

extension ZcapDetailsIsarQuerySortBy
    on QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QSortBy> {
  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy> sortByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      sortByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      sortByLastUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      sortByLastUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      sortByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      sortByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      sortByValueCol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valueCol', Sort.asc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      sortByValueColDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valueCol', Sort.desc);
    });
  }
}

extension ZcapDetailsIsarQuerySortThenBy
    on QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QSortThenBy> {
  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy> thenByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      thenByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      thenByLastUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      thenByLastUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      thenByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      thenByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      thenByValueCol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valueCol', Sort.asc);
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QAfterSortBy>
      thenByValueColDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valueCol', Sort.desc);
    });
  }
}

extension ZcapDetailsIsarQueryWhereDistinct
    on QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QDistinct> {
  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QDistinct>
      distinctByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endDate');
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QDistinct>
      distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QDistinct>
      distinctByLastUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdatedAt');
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QDistinct>
      distinctByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteId');
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QDistinct>
      distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate');
    });
  }

  QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QDistinct> distinctByValueCol(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'valueCol', caseSensitive: caseSensitive);
    });
  }
}

extension ZcapDetailsIsarQueryProperty
    on QueryBuilder<ZcapDetailsIsar, ZcapDetailsIsar, QQueryProperty> {
  QueryBuilder<ZcapDetailsIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ZcapDetailsIsar, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ZcapDetailsIsar, DateTime?, QQueryOperations> endDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endDate');
    });
  }

  QueryBuilder<ZcapDetailsIsar, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<ZcapDetailsIsar, DateTime, QQueryOperations>
      lastUpdatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdatedAt');
    });
  }

  QueryBuilder<ZcapDetailsIsar, int?, QQueryOperations> remoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteId');
    });
  }

  QueryBuilder<ZcapDetailsIsar, DateTime, QQueryOperations>
      startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }

  QueryBuilder<ZcapDetailsIsar, String, QQueryOperations> valueColProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'valueCol');
    });
  }
}
