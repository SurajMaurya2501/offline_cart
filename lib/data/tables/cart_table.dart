import 'package:drift/drift.dart';

class CartTable extends Table {
  IntColumn get productId => integer()();
  IntColumn get quantity => integer()();

  @override
  Set<Column> get primaryKey => {productId};
}
