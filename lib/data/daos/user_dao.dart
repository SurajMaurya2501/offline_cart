import 'package:drift/drift.dart';
import 'package:offline_cart/data/database/app_database.dart';
import 'package:offline_cart/data/tables/user_table.dart';
import 'package:offline_cart/data/models/user_model.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [UserTable])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  Future<void> saveUser(UserTableCompanion user) => into(
    userTable,
  ).insert(user, onConflict: DoUpdate((_) => user, target: [userTable.id]));

  Future<void> saveUserModel(UserModel user) => saveUser(
    UserTableCompanion.insert(
      id: user.id,
      email: user.email,
      name: user.displayName,
      profileImage: user.photoUrl,
    ),
  );

  Future<UserTableData?> getCurrentUser() =>
      select(userTable).getSingleOrNull();
}
