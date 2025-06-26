import 'package:isar/isar.dart';
import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_access_keys/user_access_keys.dart';

part 'user_access_keys_isar.g.dart';

@collection
class UserAccessKeysIsar implements IsarTable<UserAccessKeys> {
  /*Local variables*/
  @override
  Id id = Isar.autoIncrement;
  @override
  bool isSynced = false;

  /* Remote variables */
  @Index()
  @override
  int? remoteId;

  @Index(type: IndexType.value)
  String accessKey = "";

  String description= "";
  DateTime createdAt = DateTime.now();
  @override
  DateTime lastUpdatedAt = DateTime.now();

  // Construtor sem nome (necessário para o Isar)
  UserAccessKeysIsar();

  UserAccessKeysIsar copyWith({
    int? id,
    int? remoteId,
    String? accessKey,
    String? description,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    bool? isSynced,
  }) {
    final copy = UserAccessKeysIsar()
      ..id = id ?? this.id
      ..remoteId = remoteId ?? this.remoteId
      ..accessKey = accessKey ?? this.accessKey
      ..description = description ?? this.description
      ..createdAt = createdAt ?? this.createdAt     
      ..lastUpdatedAt = lastUpdatedAt ?? this.lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;

    return copy;
  }

  @override
  Future<void> updateFromApiEntity(UserAccessKeys entity) async {
    remoteId = entity.remoteId;
    accessKey = entity.accessKey;
    description = entity.description;
    createdAt = entity.createdAt;
    lastUpdatedAt = entity.lastUpdatedAt;
    isSynced = true;
  }

  // Método para converter a partir do modelo EntityType
  factory UserAccessKeysIsar.fromEntityType(UserAccessKeys entity) {
    return UserAccessKeysIsar()
      ..remoteId = entity.remoteId
      ..accessKey = entity.accessKey
      ..description = entity.description
      ..createdAt = entity.createdAt
      ..lastUpdatedAt = entity.lastUpdatedAt
      ..isSynced = entity.isSynced;
  }

  // Método para converter para o modelo EntityType
  @override
  UserAccessKeys toEntity() {
    return UserAccessKeys(
      remoteId: remoteId ?? -1,
      accessKey: accessKey,
      description: description,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
      isSynced: isSynced,
    );
  }

  factory UserAccessKeysIsar.toRemote(UserAccessKeys userAccessKey) {
    return UserAccessKeysIsar()
      ..remoteId = userAccessKey.remoteId
      ..accessKey = userAccessKey.accessKey
      ..description = userAccessKey.description
      ..createdAt = userAccessKey.createdAt
      ..lastUpdatedAt = userAccessKey.lastUpdatedAt
      ..isSynced = true;
  }

  @override
  UserAccessKeysIsar setEntityIdAndSync(
      {int? remoteId, bool? isSynced, DateTime? lastUpdatedAt}) {
    return UserAccessKeysIsar()
      ..id = id
      ..remoteId = remoteId ?? this.remoteId
      ..accessKey = accessKey
      ..description = description
      ..createdAt = createdAt
      ..lastUpdatedAt = lastUpdatedAt ?? this.lastUpdatedAt
      ..isSynced = isSynced ?? this.isSynced;
  }
}