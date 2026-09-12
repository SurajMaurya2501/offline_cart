import 'package:drift/drift.dart';
import 'package:offline_cart/data/database/app_database.dart';
import 'package:offline_cart/data/tables/categories_tabel.dart';
import 'package:offline_cart/models/categories_model.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [CategoriesTabel])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  Future<void> saveCategory(CategoriesTabelCompanion category) =>
      into(categoriesTabel).insert(
        category,
        onConflict: DoUpdate((_) => category, target: [categoriesTabel.slug]),
      );

  Future<void> saveCategories(List<CategoriesTabelCompanion> categories) async {
    await batch((batch) {
      batch.insertAll(
        categoriesTabel,
        categories,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<CategoriesTabelData?> getCategoryBySlug(String slug) => (select(
    categoriesTabel,
  )..where((t) => t.slug.equals(slug))).getSingleOrNull();

  Future<List<CategoriesTabelData>> getAllCategories() =>
      select(categoriesTabel).get();

  Stream<List<CategoriesTabelData>> watchAllCategories() =>
      select(categoriesTabel).watch();

  Future<int> deleteCategory(String slug) =>
      (delete(categoriesTabel)..where((t) => t.slug.equals(slug))).go();

  Future<int> deleteAllCategories() => delete(categoriesTabel).go();

  Future<void> saveCategoryModel(CategoryModel category) =>
      saveCategory(category.toCompanion());

  Future<void> saveCategoryModels(List<CategoryModel> categories) =>
      saveCategories(categories.map((c) => c.toCompanion()).toList());
}

extension CategoryModelCompanionX on CategoryModel {
  CategoriesTabelCompanion toCompanion() {
    return CategoriesTabelCompanion.insert(
      slug: slug,
      name: name,
      url: Value(url),
    );
  }
}

extension CategoriesTabelDataX on CategoriesTabelData {
  CategoryModel toModel() {
    return CategoryModel(slug: slug, name: name, url: url ?? '');
  }
}
