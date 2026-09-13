import 'package:drift/drift.dart';
import 'package:offline_cart/data/local/database/app_database.dart';
import 'package:offline_cart/data/local/tables/products_table.dart';
import 'package:offline_cart/data/models/product_model.dart';

part 'products_dao.g.dart';

@DriftAccessor(tables: [ProductsTable])
class ProductsDao extends DatabaseAccessor<AppDatabase>
    with _$ProductsDaoMixin {
  ProductsDao(super.db);

  Future<void> saveProducts(
    List<ProductsTableCompanion> products, {
    void Function(int count, int total)? onProgress,
  }) async {
    await batch((batch) {
      batch.insertAll(
        productsTable,
        products,
        mode: InsertMode.insertOrReplace,
      );
    });
    onProgress?.call(products.length, products.length);
  }

  Future<ProductsTableData?> getProductById(int id) =>
      (select(productsTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<ProductsTableData?> watchProductById(int id) => (select(
    productsTable,
  )..where((t) => t.id.equals(id))).watchSingleOrNull();

  Stream<List<ProductsTableData>> watchAllProducts() =>
      select(productsTable).watch();

  Future<List<ProductsTableData>> getProductsByCategory(
    String category, {
    String? altCategory,
  }) {
    return (select(productsTable)..where((t) {
          final match =
              t.category.equals(category) |
              t.category.lower().equals(category.toLowerCase());
          if (altCategory != null && altCategory.isNotEmpty) {
            return match |
                t.category.equals(altCategory) |
                t.category.lower().equals(altCategory.toLowerCase());
          }
          return match;
        }))
        .get();
  }

  Stream<List<ProductsTableData>> watchProductsByCategory(
    String category, {
    String? altCategory,
  }) {
    return (select(productsTable)..where((t) {
          final match =
              t.category.equals(category) |
              t.category.lower().equals(category.toLowerCase());
          if (altCategory != null && altCategory.isNotEmpty) {
            return match |
                t.category.equals(altCategory) |
                t.category.lower().equals(altCategory.toLowerCase());
          }
          return match;
        }))
        .watch();
  }
}

extension ProductModelCompanionX on ProductModel {
  ProductsTableCompanion toCompanion() {
    return ProductsTableCompanion.insert(
      id: Value(id),
      title: title,
      description: description,
      category: category,
      price: price,
      discountPercentage: Value(discountPercentage),
      rating: Value(rating),
      stock: stock,
      brand: Value(brand),
      thumbnail: thumbnail,
      images: Value(images),
    );
  }
}
