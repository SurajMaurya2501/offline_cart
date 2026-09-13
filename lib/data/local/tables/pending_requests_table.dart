import 'package:drift/drift.dart';

class PendingRequestsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get url => text()();
  TextColumn get method => text()();
  TextColumn get headers => text().nullable()();
  TextColumn get body => text().nullable()();
  TextColumn get queryParams => text().nullable()();
  TextColumn get description =>
      text().withDefault(const Constant('Network Request'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
}
