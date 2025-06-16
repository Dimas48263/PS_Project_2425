import 'package:isar/isar.dart';
import 'package:zcap_net_app/features/settings/models/users/user_profiles/user_profiles_isar.dart';

part 'users_isar.g.dart';

@Collection()
class UsersIsar {
  /*Local variables*/
  Id id = Isar.autoIncrement;
  bool isSynced = false;

  /* Remote variables */
  int? remoteId;

  @Index(unique: true)
  String userName = "";
  String name = "";
  String password = "";

  final userProfile = IsarLink<UserProfilesIsar>();
//TODO:  final userDataProfile = IsarLink<...>();

  DateTime startDate = DateTime(DateTime.now().year, 1, 1);
  DateTime? endDate;
  DateTime createdAt = DateTime.now();
  DateTime lastUpdatedAt = DateTime.now();

  UsersIsar();

  UsersIsar copyWith({
    int? id,
    int? remoteId,
    String? userName,
    String? name,
    String? password,
    IsarLink<UserProfilesIsar>? userProfile,
    //userDataProfile
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    bool? isSynced,
  }) {
    final copy = UsersIsar()
      ..id = id ?? this.id
      ..remoteId = remoteId ?? this.remoteId
      ..userName = userName ?? this.userName
      ..name = name ?? this.name
      ..userProfile.value = userProfile?.value ?? this.userProfile.value
      //userDataProfile
      ..startDate = startDate ?? this.startDate
      ..endDate = endDate ?? this.endDate
      ..createdAt = createdAt ?? this.createdAt
      ..lastUpdatedAt = lastUpdatedAt ?? DateTime.now()
      ..isSynced = isSynced ?? this.isSynced;

    return copy;
  }

  //TODO: Método para converter a partir do modelo User
  //TODO: Método para converter para o modelo User
}
