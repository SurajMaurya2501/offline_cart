import 'package:drift/drift.dart';

class FavouritesTable extends Table {
  IntColumn get productId => integer()();

  @override
  Set<Column> get primaryKey => {productId};
}
