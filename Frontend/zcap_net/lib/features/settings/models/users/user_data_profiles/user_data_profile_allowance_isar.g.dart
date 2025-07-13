// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_profile_allowance_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserDataProfileAllowanceIsarCollection on Isar {
  IsarCollection<UserDataProfileAllowanceIsar>
      get userDataProfileAllowanceIsars => this.collection();
}

const UserDataProfileAllowanceIsarSchema = CollectionSchema(
  name: r'UserDataProfileAllowanceIsar',
  id: 776019211892892305,
  properties: {
    r'isNew': PropertySchema(
      id: 0,
      name: r'isNew',
      type: IsarType.bool,
    ),
    r'localProfileId': PropertySchema(
      id: 1,
      name: r'localProfileId',
      type: IsarType.long,
    ),
    r'markedForDelete': PropertySchema(
      id: 2,
      name: r'markedForDelete',
      type: IsarType.bool,
    ),
    r'treeRecordId': PropertySchema(
      id: 3,
      name: r'treeRecordId',
      type: IsarType.long,
    ),
    r'userDataProfileId': PropertySchema(
      id: 4,
      name: r'userDataProfileId',
      type: IsarType.long,
    )
  },
  estimateSize: _userDataProfileAllowanceIsarEstimateSize,
  serialize: _userDataProfileAllowanceIsarSerialize,
  deserialize: _userDataProfileAllowanceIsarDeserialize,
  deserializeProp: _userDataProfileAllowanceIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'localProfileId': IndexSchema(
      id: 1209869916345169155,
      name: r'localProfileId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'localProfileId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'userDataProfileId': IndexSchema(
      id: 1869932270773762868,
      name: r'userDataProfileId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userDataProfileId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'treeRecordId': IndexSchema(
      id: -6697958007707466298,
      name: r'treeRecordId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'treeRecordId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _userDataProfileAllowanceIsarGetId,
  getLinks: _userDataProfileAllowanceIsarGetLinks,
  attach: _userDataProfileAllowanceIsarAttach,
  version: '3.1.0+1',
);

int _userDataProfileAllowanceIsarEstimateSize(
  UserDataProfileAllowanceIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _userDataProfileAllowanceIsarSerialize(
  UserDataProfileAllowanceIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isNew);
  writer.writeLong(offsets[1], object.localProfileId);
  writer.writeBool(offsets[2], object.markedForDelete);
  writer.writeLong(offsets[3], object.treeRecordId);
  writer.writeLong(offsets[4], object.userDataProfileId);
}

UserDataProfileAllowanceIsar _userDataProfileAllowanceIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserDataProfileAllowanceIsar();
  object.id = id;
  object.isNew = reader.readBool(offsets[0]);
  object.localProfileId = reader.readLong(offsets[1]);
  object.markedForDelete = reader.readBool(offsets[2]);
  object.treeRecordId = reader.readLong(offsets[3]);
  object.userDataProfileId = reader.readLong(offsets[4]);
  return object;
}

P _userDataProfileAllowanceIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userDataProfileAllowanceIsarGetId(UserDataProfileAllowanceIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userDataProfileAllowanceIsarGetLinks(
    UserDataProfileAllowanceIsar object) {
  return [];
}

void _userDataProfileAllowanceIsarAttach(
    IsarCollection<dynamic> col, Id id, UserDataProfileAllowanceIsar object) {
  object.id = id;
}

extension UserDataProfileAllowanceIsarQueryWhereSort on QueryBuilder<
    UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar, QWhere> {
  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhere> anyLocalProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'localProfileId'),
      );
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhere> anyUserDataProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'userDataProfileId'),
      );
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhere> anyTreeRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'treeRecordId'),
      );
    });
  }
}

extension UserDataProfileAllowanceIsarQueryWhere on QueryBuilder<
    UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar, QWhereClause> {
  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> idBetween(
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

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> localProfileIdEqualTo(int localProfileId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'localProfileId',
        value: [localProfileId],
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> localProfileIdNotEqualTo(int localProfileId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'localProfileId',
              lower: [],
              upper: [localProfileId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'localProfileId',
              lower: [localProfileId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'localProfileId',
              lower: [localProfileId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'localProfileId',
              lower: [],
              upper: [localProfileId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> localProfileIdGreaterThan(
    int localProfileId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'localProfileId',
        lower: [localProfileId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> localProfileIdLessThan(
    int localProfileId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'localProfileId',
        lower: [],
        upper: [localProfileId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> localProfileIdBetween(
    int lowerLocalProfileId,
    int upperLocalProfileId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'localProfileId',
        lower: [lowerLocalProfileId],
        includeLower: includeLower,
        upper: [upperLocalProfileId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> userDataProfileIdEqualTo(int userDataProfileId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userDataProfileId',
        value: [userDataProfileId],
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> userDataProfileIdNotEqualTo(int userDataProfileId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userDataProfileId',
              lower: [],
              upper: [userDataProfileId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userDataProfileId',
              lower: [userDataProfileId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userDataProfileId',
              lower: [userDataProfileId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userDataProfileId',
              lower: [],
              upper: [userDataProfileId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> userDataProfileIdGreaterThan(
    int userDataProfileId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userDataProfileId',
        lower: [userDataProfileId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> userDataProfileIdLessThan(
    int userDataProfileId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userDataProfileId',
        lower: [],
        upper: [userDataProfileId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> userDataProfileIdBetween(
    int lowerUserDataProfileId,
    int upperUserDataProfileId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userDataProfileId',
        lower: [lowerUserDataProfileId],
        includeLower: includeLower,
        upper: [upperUserDataProfileId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> treeRecordIdEqualTo(int treeRecordId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'treeRecordId',
        value: [treeRecordId],
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> treeRecordIdNotEqualTo(int treeRecordId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'treeRecordId',
              lower: [],
              upper: [treeRecordId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'treeRecordId',
              lower: [treeRecordId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'treeRecordId',
              lower: [treeRecordId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'treeRecordId',
              lower: [],
              upper: [treeRecordId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> treeRecordIdGreaterThan(
    int treeRecordId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'treeRecordId',
        lower: [treeRecordId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> treeRecordIdLessThan(
    int treeRecordId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'treeRecordId',
        lower: [],
        upper: [treeRecordId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterWhereClause> treeRecordIdBetween(
    int lowerTreeRecordId,
    int upperTreeRecordId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'treeRecordId',
        lower: [lowerTreeRecordId],
        includeLower: includeLower,
        upper: [upperTreeRecordId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserDataProfileAllowanceIsarQueryFilter on QueryBuilder<
    UserDataProfileAllowanceIsar,
    UserDataProfileAllowanceIsar,
    QFilterCondition> {
  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterFilterCondition> isNewEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isNew',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterFilterCondition> localProfileIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localProfileId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterFilterCondition> localProfileIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localProfileId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterFilterCondition> localProfileIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localProfileId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterFilterCondition> localProfileIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localProfileId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterFilterCondition> markedForDeleteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'markedForDelete',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterFilterCondition> treeRecordIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'treeRecordId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterFilterCondition> treeRecordIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'treeRecordId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterFilterCondition> treeRecordIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'treeRecordId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterFilterCondition> treeRecordIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'treeRecordId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterFilterCondition> userDataProfileIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userDataProfileId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterFilterCondition> userDataProfileIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userDataProfileId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterFilterCondition> userDataProfileIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userDataProfileId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterFilterCondition> userDataProfileIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userDataProfileId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserDataProfileAllowanceIsarQueryObject on QueryBuilder<
    UserDataProfileAllowanceIsar,
    UserDataProfileAllowanceIsar,
    QFilterCondition> {}

extension UserDataProfileAllowanceIsarQueryLinks on QueryBuilder<
    UserDataProfileAllowanceIsar,
    UserDataProfileAllowanceIsar,
    QFilterCondition> {}

extension UserDataProfileAllowanceIsarQuerySortBy on QueryBuilder<
    UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar, QSortBy> {
  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> sortByIsNew() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNew', Sort.asc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> sortByIsNewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNew', Sort.desc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> sortByLocalProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localProfileId', Sort.asc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> sortByLocalProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localProfileId', Sort.desc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> sortByMarkedForDelete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markedForDelete', Sort.asc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> sortByMarkedForDeleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markedForDelete', Sort.desc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> sortByTreeRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'treeRecordId', Sort.asc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> sortByTreeRecordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'treeRecordId', Sort.desc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> sortByUserDataProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userDataProfileId', Sort.asc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> sortByUserDataProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userDataProfileId', Sort.desc);
    });
  }
}

extension UserDataProfileAllowanceIsarQuerySortThenBy on QueryBuilder<
    UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar, QSortThenBy> {
  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> thenByIsNew() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNew', Sort.asc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> thenByIsNewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNew', Sort.desc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> thenByLocalProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localProfileId', Sort.asc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> thenByLocalProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localProfileId', Sort.desc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> thenByMarkedForDelete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markedForDelete', Sort.asc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> thenByMarkedForDeleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markedForDelete', Sort.desc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> thenByTreeRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'treeRecordId', Sort.asc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> thenByTreeRecordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'treeRecordId', Sort.desc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> thenByUserDataProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userDataProfileId', Sort.asc);
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QAfterSortBy> thenByUserDataProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userDataProfileId', Sort.desc);
    });
  }
}

extension UserDataProfileAllowanceIsarQueryWhereDistinct on QueryBuilder<
    UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar, QDistinct> {
  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QDistinct> distinctByIsNew() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isNew');
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QDistinct> distinctByLocalProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localProfileId');
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QDistinct> distinctByMarkedForDelete() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'markedForDelete');
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QDistinct> distinctByTreeRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'treeRecordId');
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, UserDataProfileAllowanceIsar,
      QDistinct> distinctByUserDataProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userDataProfileId');
    });
  }
}

extension UserDataProfileAllowanceIsarQueryProperty on QueryBuilder<
    UserDataProfileAllowanceIsar,
    UserDataProfileAllowanceIsar,
    QQueryProperty> {
  QueryBuilder<UserDataProfileAllowanceIsar, int, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, bool, QQueryOperations>
      isNewProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isNew');
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, int, QQueryOperations>
      localProfileIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localProfileId');
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, bool, QQueryOperations>
      markedForDeleteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'markedForDelete');
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, int, QQueryOperations>
      treeRecordIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'treeRecordId');
    });
  }

  QueryBuilder<UserDataProfileAllowanceIsar, int, QQueryOperations>
      userDataProfileIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userDataProfileId');
    });
  }
}
