import 'package:drift/drift.dart';

class UserTable extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get name => text()();
  TextColumn get profileImage => text()();

  @override
  Set<Column> get primaryKey => {id};
}
