import 'package:drift/drift.dart';
import 'package:offline_cart/data/database/app_database.dart';
import 'package:offline_cart/data/tables/favourites_table.dart';

part 'favourites_dao.g.dart';

@DriftAccessor(tables: [FavouritesTable])
class FavouritesDao extends DatabaseAccessor<AppDatabase>
    with _$FavouritesDaoMixin {
  FavouritesDao(super.db);

  Future<void> addFavourite(int productId) {
    return into(favouritesTable).insert(
      FavouritesTableCompanion.insert(productId: Value(productId)),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<int> removeFavourite(int productId) {
    return (delete(
      favouritesTable,
    )..where((t) => t.productId.equals(productId))).go();
  }

  Future<bool> isFavourite(int productId) async {
    final item = await (select(
      favouritesTable,
    )..where((t) => t.productId.equals(productId))).getSingleOrNull();
    return item != null;
  }

  Stream<bool> watchIsFavourite(int productId) {
    return (select(favouritesTable)
          ..where((t) => t.productId.equals(productId)))
        .watchSingleOrNull()
        .map((item) => item != null);
  }

  Future<bool> toggleFavourite(int productId) async {
    final exists = await isFavourite(productId);
    if (exists) {
      await removeFavourite(productId);
      return false;
    } else {
      await addFavourite(productId);
      return true;
    }
  }

  Future<List<FavouritesTableData>> getAllFavourites() {
    return select(favouritesTable).get();
  }

  Stream<List<FavouritesTableData>> watchAllFavourites() {
    return select(favouritesTable).watch();
  }

  Stream<List<ProductsTableData>> watchFavouriteProducts() {
    final query = db.select(db.productsTable).join([
      innerJoin(
        favouritesTable,
        favouritesTable.productId.equalsExp(db.productsTable.id),
      ),
    ]);
    return query.watch().map(
      (rows) => rows.map((r) => r.readTable(db.productsTable)).toList(),
    );
  }

  Future<List<ProductsTableData>> getFavouriteProducts() {
    final query = db.select(db.productsTable).join([
      innerJoin(
        favouritesTable,
        favouritesTable.productId.equalsExp(db.productsTable.id),
      ),
    ]);
    return query.get().then(
      (rows) => rows.map((r) => r.readTable(db.productsTable)).toList(),
    );
  }

  Future<int> clearFavourites() {
    return delete(favouritesTable).go();
  }
}
