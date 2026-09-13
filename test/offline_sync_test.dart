import 'dart:async';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:offline_cart/data/local/database/app_database.dart';
import 'package:offline_cart/data/network/offline_sync_interceptor.dart';
import 'package:offline_cart/data/network/sync_manager.dart';

class FakeOfflineConnection extends Fake implements InternetConnection {
  @override
  Future<bool> get hasInternetAccess async => false;
}

class FakeOnlineConnection extends Fake implements InternetConnection {
  final _controller = StreamController<InternetStatus>.broadcast();

  @override
  Future<bool> get hasInternetAccess async => true;

  @override
  Stream<InternetStatus> get onStatusChange => _controller.stream;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test(
    'OfflineSyncInterceptor queues POST request when offline and returns 202',
    () async {
      final dio = Dio();
      dio.interceptors.add(
        OfflineSyncInterceptor(
          database: db,
          connection: FakeOfflineConnection(),
        ),
      );

      final response = await dio.post(
        'https://dummyjson.com/carts/add',
        data: {
          'userId': 1,
          'products': [
            {'id': 42, 'quantity': 2},
          ],
        },
        options: Options(extra: {'description': 'Add "MacBook Pro" to cart'}),
      );

      expect(response.statusCode, 202);
      expect(response.data['offline'], true);
      expect(response.data['queued'], true);

      // Verify item in Drift database
      final pending = await db.pendingRequestsDao.getPendingRequests();
      expect(pending.length, 1);
      expect(pending.first.method, 'POST');
      expect(pending.first.description, 'Add "MacBook Pro" to cart');
      expect(pending.first.url, 'https://dummyjson.com/carts/add');
    },
  );

  test('SyncManager replays and clears pending requests on success', () async {
    // 1. Insert a pending request into database
    await db.pendingRequestsDao.insertRequest(
      PendingRequestsTableCompanion.insert(
        url: '/carts/add',
        method: 'POST',
        description: const Value('Add "Headphones" to cart'),
      ),
    );

    var items = await db.pendingRequestsDao.getPendingRequests();
    expect(items.length, 1);

    // 2. Create mock Dio adapter that returns 200 OK
    final mockDio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com/'));
    mockDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {'success': true},
            ),
          );
        },
      ),
    );

    // 3. Run SyncManager
    final syncManager = SyncManager(
      database: db,
      dio: mockDio,
      connection: FakeOnlineConnection(),
    );

    await syncManager.syncPendingRequests();

    // 4. Verify request was processed and removed from DB
    items = await db.pendingRequestsDao.getPendingRequests();
    expect(items.isEmpty, true);
    expect(syncManager.lastSyncTime.value, isNotNull);
  });
}
