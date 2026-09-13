import 'package:drift/drift.dart';
import 'package:offline_cart/data/local/database/app_database.dart';
import 'package:offline_cart/data/local/tables/pending_requests_table.dart';

part 'pending_requests_dao.g.dart';

@DriftAccessor(tables: [PendingRequestsTable])
class PendingRequestsDao extends DatabaseAccessor<AppDatabase>
    with _$PendingRequestsDaoMixin {
  PendingRequestsDao(super.db);

  Future<int> insertRequest(PendingRequestsTableCompanion request) {
    return into(pendingRequestsTable).insert(request);
  }

  Future<List<PendingRequestsTableData>> getPendingRequests() {
    return (select(pendingRequestsTable)
          ..where((t) => t.status.equals('pending') | t.status.equals('failed'))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();
  }

  Stream<List<PendingRequestsTableData>> watchPendingRequests() {
    return (select(
      pendingRequestsTable,
    )..orderBy([(t) => OrderingTerm.asc(t.id)])).watch();
  }

  Stream<int> watchPendingCount() {
    return (select(pendingRequestsTable)
          ..where((t) => t.status.isNotValue('synced')))
        .watch()
        .map((list) => list.length);
  }

  Future<void> updateStatus(int id, String status) {
    return (update(pendingRequestsTable)..where((t) => t.id.equals(id))).write(
      PendingRequestsTableCompanion(status: Value(status)),
    );
  }

  Future<void> incrementRetry(int id, int currentRetries) {
    return (update(pendingRequestsTable)..where((t) => t.id.equals(id))).write(
      PendingRequestsTableCompanion(
        retryCount: Value(currentRetries + 1),
        status: const Value('failed'),
      ),
    );
  }

  Future<int> deleteRequest(int id) {
    return (delete(pendingRequestsTable)..where((t) => t.id.equals(id))).go();
  }

  Future<int> clearAll() {
    return delete(pendingRequestsTable).go();
  }
}
