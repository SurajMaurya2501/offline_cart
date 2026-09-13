import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:offline_cart/data/local/daos/cart_dao.dart';
import 'package:offline_cart/data/local/daos/category_dao.dart';
import 'package:offline_cart/data/local/daos/favourites_dao.dart';
import 'package:offline_cart/data/local/daos/products_dao.dart';
import 'package:offline_cart/data/local/daos/user_dao.dart';
import 'package:offline_cart/data/local/tables/categories_table.dart';
import 'package:offline_cart/data/local/tables/cart_table.dart';
import 'package:offline_cart/data/local/tables/favourites_table.dart';
import 'package:offline_cart/data/local/tables/products_table.dart';
import 'package:offline_cart/data/local/tables/user_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    UserTable,
    ProductsTable,
    CartTable,
    FavouritesTable,
    CategoriesTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  static AppDatabase? _instance;

  AppDatabase._internal([QueryExecutor? executor])
    : super(executor ?? _openConnection());

  static AppDatabase get instance => _instance ??= AppDatabase._internal();

  late final UserDao userDao = UserDao(this);
  late final ProductsDao productsDao = ProductsDao(this);
  late final CategoryDao categoryDao = CategoryDao(this);
  late final CartDao cartDao = CartDao(this);
  late final FavouritesDao favouritesDao = FavouritesDao(this);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'offline_cart_db');
  }

  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(cartTable).go();
      await delete(favouritesTable).go();
      await delete(productsTable).go();
      await delete(categoriesTable).go();
      await delete(userTable).go();
    });
  }

  @override
  Future<void> close() async {
    await super.close();
    if (identical(_instance, this)) {
      _instance = null;
    }
  }
}
