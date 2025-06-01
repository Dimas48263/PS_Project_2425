import 'package:isar/isar.dart';

part 'user_profiles_isar.g.dart';

@Collection()
class UserProfilesIsar {
  /*Local variables*/
  Id id = Isar.autoIncrement;
  bool isSynced = false;

  /* Remote variables */
  int? remoteId;

  @Index(type: IndexType.value)
  String name = "";

  DateTime startDate = DateTime(DateTime.now().year, 1, 1);
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  UserProfilesIsar();

  UserProfilesIsar copyWith({
    int? id,
    int? remoteId,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    final copy = UserProfilesIsar()
      ..id = id ?? this.id
      ..remoteId = remoteId ?? this.remoteId
      ..name = name ?? this.name
      ..startDate = startDate ?? this.startDate
      ..endDate = endDate ?? this.endDate
      ..createdAt = createdAt ?? this.createdAt
      ..updatedAt = updatedAt ?? DateTime.now()
      ..isSynced = isSynced ?? this.isSynced;

    return copy;
  }

  //TODO: Método para converter a partir do modelo UserProfile
  //TODO: Método para converter para o modelo UserProfile
}
