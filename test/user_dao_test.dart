import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_cart/data/daos/user_dao.dart';
import 'package:offline_cart/data/database/app_database.dart';
import 'package:offline_cart/models/user_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/path_provider'),
        (MethodCall methodCall) async => '.',
      );

  late AppDatabase db;
  late UserDao userDao;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    userDao = UserDao(db);
    await userDao.deleteAllUsers();
  });

  tearDown(() async {
    await userDao.deleteAllUsers();
    await db.close();
  });

  test('userDao save, update, get, watch, and delete user', () async {
    final user1 = UserTableCompanion.insert(
      id: 'usr_1',
      email: 'john@example.com',
      name: 'John Doe',
      profileImage: 'https://example.com/avatar.jpg',
    );

    // 1. Save new user
    await userDao.saveUser(user1);

    final fetched = await userDao.getUser('usr_1');
    expect(fetched, isNotNull);
    expect(fetched?.id, 'usr_1');
    expect(fetched?.email, 'john@example.com');
    expect(fetched?.name, 'John Doe');
    expect(fetched?.profileImage, 'https://example.com/avatar.jpg');

    // 2. Update existing user with same id
    final user1Updated = UserTableCompanion.insert(
      id: 'usr_1',
      email: 'john.updated@example.com',
      name: 'John Updated',
      profileImage: 'https://example.com/avatar_new.jpg',
    );
    await userDao.saveUser(user1Updated);

    final current = await userDao.getCurrentUser();
    expect(current?.name, 'John Updated');
    expect(current?.email, 'john.updated@example.com');

    // 3. Watch user stream
    final streamUser = await userDao.watchUser('usr_1').first;
    expect(streamUser?.id, 'usr_1');

    // 4. Delete user by id
    final deletedCount = await userDao.deleteUser('usr_1');
    expect(deletedCount, 1);
    expect(await userDao.getUser('usr_1'), isNull);

    // 5. Delete all users
    await userDao.saveUser(user1);
    expect(await userDao.getCurrentUser(), isNotNull);
    await userDao.deleteAllUsers();
    expect(await userDao.getCurrentUser(), isNull);
  });

  test('userDao saveUserModel saves UserModel correctly', () async {
    const userModel = UserModel(
      id: 'usr_model_1',
      displayName: 'Jane Doe',
      email: 'jane@example.com',
      photoUrl: 'https://example.com/jane.jpg',
    );

    await userDao.saveUserModel(userModel);

    final fetched = await userDao.getUser('usr_model_1');
    expect(fetched, isNotNull);
    expect(fetched?.id, 'usr_model_1');
    expect(fetched?.name, 'Jane Doe');
    expect(fetched?.email, 'jane@example.com');
    expect(fetched?.profileImage, 'https://example.com/jane.jpg');
  });
}
