import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_cart/data/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('clearAllData erases all rows across all tables', () async {
    // 1. Insert user
    await db.userDao.saveUser(
      const UserTableCompanion(
        id: Value('user-1'),
        email: Value('test@example.com'),
        name: Value('Test User'),
        profileImage: Value('https://example.com/photo.jpg'),
      ),
    );

    // 2. Insert category
    await db.categoryDao.saveCategory(
      const CategoriesTabelCompanion(
        slug: Value('electronics'),
        name: Value('Electronics'),
        url: Value('https://example.com/cat'),
      ),
    );

    // 3. Insert product
    await db.productsDao.saveProduct(
      const ProductsTableCompanion(
        id: Value(101),
        title: Value('Smartphone'),
        description: Value('A test smartphone'),
        category: Value('electronics'),
        price: Value(699.99),
        stock: Value(25),
        thumbnail: Value('https://example.com/thumb.jpg'),
      ),
    );

    // 4. Insert cart item
    await db
        .into(db.cartTable)
        .insert(
          const CartTableCompanion(productId: Value(101), quantity: Value(2)),
        );

    // 5. Insert favourite item
    await db
        .into(db.favouritesTable)
        .insert(const FavouritesTableCompanion(productId: Value(101)));

    // Verify all tables contain inserted data
    final usersBefore = await db.select(db.userTable).get();
    final categoriesBefore = await db.select(db.categoriesTabel).get();
    final productsBefore = await db.select(db.productsTable).get();
    final cartBefore = await db.select(db.cartTable).get();
    final favsBefore = await db.select(db.favouritesTable).get();

    expect(usersBefore.length, 1);
    expect(categoriesBefore.length, 1);
    expect(productsBefore.length, 1);
    expect(cartBefore.length, 1);
    expect(favsBefore.length, 1);

    // Act: clear all data
    await db.clearAllData();

    // Verify all tables are empty
    final usersAfter = await db.select(db.userTable).get();
    final categoriesAfter = await db.select(db.categoriesTabel).get();
    final productsAfter = await db.select(db.productsTable).get();
    final cartAfter = await db.select(db.cartTable).get();
    final favsAfter = await db.select(db.favouritesTable).get();

    expect(usersAfter, isEmpty);
    expect(categoriesAfter, isEmpty);
    expect(productsAfter, isEmpty);
    expect(cartAfter, isEmpty);
    expect(favsAfter, isEmpty);
  });
}
