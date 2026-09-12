import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_cart/data/daos/category_dao.dart';
import 'package:offline_cart/data/database/app_database.dart';
import 'package:offline_cart/models/categories_model.dart';

void main() {
  late AppDatabase db;
  late CategoryDao categoryDao;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    categoryDao = CategoryDao(db);
    await categoryDao.deleteAllCategories();
  });

  tearDown(() async {
    await categoryDao.deleteAllCategories();
    await db.close();
  });

  test('categoryDao saveCategory and getCategoryBySlug', () async {
    const category = CategoryModel(
      slug: 'smartphones',
      name: 'Smartphones',
      url: 'https://dummyjson.com/products/category/smartphones',
    );

    await categoryDao.saveCategoryModel(category);

    final fetched = await categoryDao.getCategoryBySlug('smartphones');
    expect(fetched, isNotNull);
    expect(fetched?.slug, 'smartphones');
    expect(fetched?.name, 'Smartphones');
    expect(fetched?.url, 'https://dummyjson.com/products/category/smartphones');
  });

  test('categoryDao saveCategories batch and getAllCategories', () async {
    final list = [
      const CategoryModel(
        slug: 'laptops',
        name: 'Laptops',
        url: 'https://dummyjson.com/laptops',
      ),
      const CategoryModel(
        slug: 'fragrances',
        name: 'Fragrances',
        url: 'https://dummyjson.com/fragrances',
      ),
    ];

    await categoryDao.saveCategoryModels(list);

    final all = await categoryDao.getAllCategories();
    expect(all.length, 2);
  });

  test('categoryDao deleteCategory and deleteAllCategories', () async {
    final list = [
      const CategoryModel(slug: 'cat-1', name: 'Category 1', url: ''),
      const CategoryModel(slug: 'cat-2', name: 'Category 2', url: ''),
    ];
    await categoryDao.saveCategoryModels(list);

    await categoryDao.deleteCategory('cat-1');
    final afterOneDelete = await categoryDao.getAllCategories();
    expect(afterOneDelete.length, 1);
    expect(afterOneDelete.first.slug, 'cat-2');

    await categoryDao.deleteAllCategories();
    final afterAllDelete = await categoryDao.getAllCategories();
    expect(afterAllDelete.isEmpty, true);
  });
}
