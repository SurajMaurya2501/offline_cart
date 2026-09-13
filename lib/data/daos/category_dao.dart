import 'package:drift/drift.dart';
import 'package:offline_cart/data/database/app_database.dart';
import 'package:offline_cart/data/tables/categories_table.dart';
import 'package:offline_cart/data/models/categories_model.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [CategoriesTable])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  Future<void> saveCategories(List<CategoriesTableCompanion> categories) async {
    await batch((batch) {
      batch.insertAll(
        categoriesTable,
        categories,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Stream<List<CategoriesTableData>> watchAllCategories() =>
      select(categoriesTable).watch();
}

extension CategoryModelCompanionX on CategoryModel {
  CategoriesTableCompanion toCompanion() {
    return CategoriesTableCompanion.insert(
      slug: slug,
      name: name,
      url: Value(url),
    );
  }
}
