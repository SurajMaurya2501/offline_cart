import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:offline_cart/data/daos/cart_dao.dart';
import 'package:offline_cart/data/daos/category_dao.dart';
import 'package:offline_cart/data/daos/favourites_dao.dart';
import 'package:offline_cart/data/daos/products_dao.dart';
import 'package:offline_cart/data/daos/user_dao.dart';
import 'package:offline_cart/data/tables/categories_table.dart';
import 'package:offline_cart/data/tables/cart_table.dart';
import 'package:offline_cart/data/tables/favourites_table.dart';
import 'package:offline_cart/data/tables/products_table.dart';
import 'package:offline_cart/data/tables/user_table.dart';

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

  factory AppDatabase([QueryExecutor? executor]) {
    if (executor != null) {
      return AppDatabase._internal(executor);
    }
    return _instance ??= AppDatabase._internal();
  }

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
