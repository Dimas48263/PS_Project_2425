// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_access_allowance_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserProfileAccessAllowanceIsarCollection on Isar {
  IsarCollection<UserProfileAccessAllowanceIsar>
      get userProfileAccessAllowanceIsars => this.collection();
}

const UserProfileAccessAllowanceIsarSchema = CollectionSchema(
  name: r'UserProfileAccessAllowanceIsar',
  id: 7393833754293177437,
  properties: {
    r'accessType': PropertySchema(
      id: 0,
      name: r'accessType',
      type: IsarType.long,
    ),
    r'userProfileAccessKeyId': PropertySchema(
      id: 1,
      name: r'userProfileAccessKeyId',
      type: IsarType.long,
    )
  },
  estimateSize: _userProfileAccessAllowanceIsarEstimateSize,
  serialize: _userProfileAccessAllowanceIsarSerialize,
  deserialize: _userProfileAccessAllowanceIsarDeserialize,
  deserializeProp: _userProfileAccessAllowanceIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'userProfile': LinkSchema(
      id: 1491388830560731165,
      name: r'userProfile',
      target: r'UserProfilesIsar',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _userProfileAccessAllowanceIsarGetId,
  getLinks: _userProfileAccessAllowanceIsarGetLinks,
  attach: _userProfileAccessAllowanceIsarAttach,
  version: '3.1.0+1',
);

int _userProfileAccessAllowanceIsarEstimateSize(
  UserProfileAccessAllowanceIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _userProfileAccessAllowanceIsarSerialize(
  UserProfileAccessAllowanceIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.accessType);
  writer.writeLong(offsets[1], object.userProfileAccessKeyId);
}

UserProfileAccessAllowanceIsar _userProfileAccessAllowanceIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserProfileAccessAllowanceIsar();
  object.accessType = reader.readLong(offsets[0]);
  object.id = id;
  object.userProfileAccessKeyId = reader.readLong(offsets[1]);
  return object;
}

P _userProfileAccessAllowanceIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userProfileAccessAllowanceIsarGetId(UserProfileAccessAllowanceIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userProfileAccessAllowanceIsarGetLinks(
    UserProfileAccessAllowanceIsar object) {
  return [object.userProfile];
}

void _userProfileAccessAllowanceIsarAttach(
    IsarCollection<dynamic> col, Id id, UserProfileAccessAllowanceIsar object) {
  object.id = id;
  object.userProfile
      .attach(col, col.isar.collection<UserProfilesIsar>(), r'userProfile', id);
}

extension UserProfileAccessAllowanceIsarQueryWhereSort on QueryBuilder<
    UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar, QWhere> {
  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserProfileAccessAllowanceIsarQueryWhere on QueryBuilder<
    UserProfileAccessAllowanceIsar,
    UserProfileAccessAllowanceIsar,
    QWhereClause> {
  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
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

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
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
}

extension UserProfileAccessAllowanceIsarQueryFilter on QueryBuilder<
    UserProfileAccessAllowanceIsar,
    UserProfileAccessAllowanceIsar,
    QFilterCondition> {
  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterFilterCondition> accessTypeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accessType',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterFilterCondition> accessTypeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accessType',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterFilterCondition> accessTypeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accessType',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterFilterCondition> accessTypeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accessType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
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

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
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

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
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

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterFilterCondition> userProfileAccessKeyIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userProfileAccessKeyId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterFilterCondition> userProfileAccessKeyIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userProfileAccessKeyId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterFilterCondition> userProfileAccessKeyIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userProfileAccessKeyId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterFilterCondition> userProfileAccessKeyIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userProfileAccessKeyId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserProfileAccessAllowanceIsarQueryObject on QueryBuilder<
    UserProfileAccessAllowanceIsar,
    UserProfileAccessAllowanceIsar,
    QFilterCondition> {}

extension UserProfileAccessAllowanceIsarQueryLinks on QueryBuilder<
    UserProfileAccessAllowanceIsar,
    UserProfileAccessAllowanceIsar,
    QFilterCondition> {
  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterFilterCondition> userProfile(FilterQuery<UserProfilesIsar> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'userProfile');
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterFilterCondition> userProfileIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'userProfile', 0, true, 0, true);
    });
  }
}

extension UserProfileAccessAllowanceIsarQuerySortBy on QueryBuilder<
    UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar, QSortBy> {
  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterSortBy> sortByAccessType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessType', Sort.asc);
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterSortBy> sortByAccessTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessType', Sort.desc);
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterSortBy> sortByUserProfileAccessKeyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userProfileAccessKeyId', Sort.asc);
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterSortBy> sortByUserProfileAccessKeyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userProfileAccessKeyId', Sort.desc);
    });
  }
}

extension UserProfileAccessAllowanceIsarQuerySortThenBy on QueryBuilder<
    UserProfileAccessAllowanceIsar,
    UserProfileAccessAllowanceIsar,
    QSortThenBy> {
  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterSortBy> thenByAccessType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessType', Sort.asc);
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterSortBy> thenByAccessTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessType', Sort.desc);
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterSortBy> thenByUserProfileAccessKeyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userProfileAccessKeyId', Sort.asc);
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QAfterSortBy> thenByUserProfileAccessKeyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userProfileAccessKeyId', Sort.desc);
    });
  }
}

extension UserProfileAccessAllowanceIsarQueryWhereDistinct on QueryBuilder<
    UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar, QDistinct> {
  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QDistinct> distinctByAccessType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accessType');
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, UserProfileAccessAllowanceIsar,
      QDistinct> distinctByUserProfileAccessKeyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userProfileAccessKeyId');
    });
  }
}

extension UserProfileAccessAllowanceIsarQueryProperty on QueryBuilder<
    UserProfileAccessAllowanceIsar,
    UserProfileAccessAllowanceIsar,
    QQueryProperty> {
  QueryBuilder<UserProfileAccessAllowanceIsar, int, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, int, QQueryOperations>
      accessTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accessType');
    });
  }

  QueryBuilder<UserProfileAccessAllowanceIsar, int, QQueryOperations>
      userProfileAccessKeyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userProfileAccessKeyId');
    });
  }
}
