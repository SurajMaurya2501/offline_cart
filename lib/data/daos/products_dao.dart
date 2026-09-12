import 'package:drift/drift.dart';
import 'package:offline_cart/data/database/app_database.dart';
import 'package:offline_cart/data/tables/products_table.dart';
import 'package:offline_cart/models/product_model.dart';
part 'products_dao.g.dart';

@DriftAccessor(tables: [ProductsTable])
class ProductsDao extends DatabaseAccessor<AppDatabase>
    with _$ProductsDaoMixin {
  ProductsDao(super.db);

  Future<void> saveProduct(ProductsTableCompanion product) =>
      into(productsTable).insert(
        product,
        onConflict: DoUpdate((_) => product, target: [productsTable.id]),
      );

  Future<void> saveProducts(List<ProductsTableCompanion> products) async {
    await batch((batch) {
      batch.insertAll(
        productsTable,
        products,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<ProductsTableData?> getProductById(int id) =>
      (select(productsTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<ProductsTableData?> watchProductById(int id) => (select(
    productsTable,
  )..where((t) => t.id.equals(id))).watchSingleOrNull();

  Future<List<ProductsTableData>> getAllProducts() =>
      select(productsTable).get();

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

  Future<List<ProductsTableData>> searchProducts(String query) {
    final cleanQuery = '%$query%';
    return (select(productsTable)..where(
          (t) =>
              t.title.like(cleanQuery) |
              t.description.like(cleanQuery) |
              t.brand.like(cleanQuery),
        ))
        .get();
  }

  Stream<List<ProductsTableData>> watchSearchProducts(String query) {
    final cleanQuery = '%$query%';
    return (select(productsTable)..where(
          (t) =>
              t.title.like(cleanQuery) |
              t.description.like(cleanQuery) |
              t.brand.like(cleanQuery),
        ))
        .watch();
  }

  Future<List<ProductsTableData>> getPagedProducts({
    required int limit,
    int offset = 0,
  }) => (select(productsTable)..limit(limit, offset: offset)).get();

  Future<int> deleteProduct(int id) =>
      (delete(productsTable)..where((t) => t.id.equals(id))).go();

  Future<int> deleteProductsByCategory(String category) =>
      (delete(productsTable)..where((t) => t.category.equals(category))).go();

  Future<int> deleteAllProducts() => delete(productsTable).go();

  Future<int> getProductsCount() async {
    final countExp = productsTable.id.count();
    final query = selectOnly(productsTable)..addColumns([countExp]);
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<void> saveProductModel(ProductModel product) =>
      saveProduct(product.toCompanion());

  Future<void> saveProductModels(List<ProductModel> products) =>
      saveProducts(products.map((p) => p.toCompanion()).toList());
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

extension ProductsTableDataX on ProductsTableData {
  ProductModel toModel() {
    return ProductModel(
      id: id,
      title: title,
      description: description,
      category: category,
      price: price,
      discountPercentage: discountPercentage ?? 0.0,
      rating: rating ?? 0.0,
      stock: stock,
      brand: brand ?? '',
      thumbnail: thumbnail,
      images: images,
    );
  }
}
