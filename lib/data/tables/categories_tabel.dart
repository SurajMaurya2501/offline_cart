import 'package:drift/drift.dart';

class CategoriesTabel extends Table {
  TextColumn get slug => text()();
  TextColumn get name => text()();
  TextColumn get url => text().nullable()();

  @override
  Set<Column> get primaryKey => {slug};
}
