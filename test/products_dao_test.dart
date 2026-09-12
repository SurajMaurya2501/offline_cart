import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_cart/data/daos/products_dao.dart';
import 'package:offline_cart/data/database/app_database.dart';
import 'package:offline_cart/models/product_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/path_provider'),
        (MethodCall methodCall) async => '.',
      );

  late AppDatabase db;
  late ProductsDao productsDao;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    productsDao = ProductsDao(db);
    await productsDao.deleteAllProducts();
  });

  tearDown(() async {
    await productsDao.deleteAllProducts();
    await db.close();
  });

  ProductsTableCompanion createProductCompanion({
    required int id,
    required String title,
    required String description,
    required String category,
    required double price,
    double? discountPercentage,
    double? rating,
    required int stock,
    String? brand,
    required String thumbnail,
    List<String>? images,
  }) {
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
      images: Value(images ?? const []),
    );
  }

  test('productsDao saveProduct, update, and getProductById', () async {
    final product = createProductCompanion(
      id: 1,
      title: 'iPhone 15',
      description: 'Latest Apple iPhone',
      category: 'smartphones',
      price: 999.99,
      discountPercentage: 5.0,
      rating: 4.8,
      stock: 50,
      brand: 'Apple',
      thumbnail: 'https://example.com/iphone15.jpg',
    );

    // Save product
    await productsDao.saveProduct(product);

    final fetched = await productsDao.getProductById(1);
    expect(fetched, isNotNull);
    expect(fetched?.id, 1);
    expect(fetched?.title, 'iPhone 15');
    expect(fetched?.price, 999.99);
    expect(fetched?.brand, 'Apple');
    expect(fetched?.images, isEmpty);

    // Update product with same id
    final updated = createProductCompanion(
      id: 1,
      title: 'iPhone 15 Pro',
      description: 'Titanium design',
      category: 'smartphones',
      price: 1099.99,
      discountPercentage: 10.0,
      rating: 4.9,
      stock: 30,
      brand: 'Apple',
      thumbnail: 'https://example.com/iphone15pro.jpg',
      images: [
        'https://example.com/iphone15pro_1.jpg',
        'https://example.com/iphone15pro_2.jpg',
      ],
    );
    await productsDao.saveProduct(updated);

    final fetchedUpdated = await productsDao.getProductById(1);
    expect(fetchedUpdated?.title, 'iPhone 15 Pro');
    expect(fetchedUpdated?.price, 1099.99);
    expect(fetchedUpdated?.rating, 4.9);
    expect(fetchedUpdated?.images, [
      'https://example.com/iphone15pro_1.jpg',
      'https://example.com/iphone15pro_2.jpg',
    ]);
  });

  test('productsDao batch saveProducts and getAllProducts', () async {
    final list = [
      createProductCompanion(
        id: 10,
        title: 'MacBook Air',
        description: 'M3 chip laptop',
        category: 'laptops',
        price: 1199.0,
        stock: 20,
        brand: 'Apple',
        thumbnail: 'https://example.com/macbook.jpg',
      ),
      createProductCompanion(
        id: 11,
        title: 'ThinkPad X1',
        description: 'Business laptop',
        category: 'laptops',
        price: 1299.0,
        stock: 15,
        brand: 'Lenovo',
        thumbnail: 'https://example.com/thinkpad.jpg',
      ),
    ];

    await productsDao.saveProducts(list);

    final all = await productsDao.getAllProducts();
    expect(all.length, 2);

    final count = await productsDao.getProductsCount();
    expect(count, 2);
  });

  test('productsDao getProductsByCategory and searchProducts', () async {
    final products = [
      createProductCompanion(
        id: 1,
        title: 'Running Shoes',
        description: 'Comfortable sneakers',
        category: 'shoes',
        price: 80.0,
        stock: 100,
        brand: 'Nike',
        thumbnail: 'https://example.com/shoes.jpg',
      ),
      createProductCompanion(
        id: 2,
        title: 'Wireless Earbuds',
        description: 'Noise cancelling earphones',
        category: 'audio',
        price: 150.0,
        stock: 45,
        brand: 'Sony',
        thumbnail: 'https://example.com/earbuds.jpg',
      ),
      createProductCompanion(
        id: 3,
        title: 'Basketball Shoes',
        description: 'High top sneakers',
        category: 'shoes',
        price: 120.0,
        stock: 25,
        brand: 'Adidas',
        thumbnail: 'https://example.com/bbshoes.jpg',
      ),
    ];

    await productsDao.saveProducts(products);

    // Filter by category
    final shoes = await productsDao.getProductsByCategory('shoes');
    expect(shoes.length, 2);

    // Search by title or brand
    final sony = await productsDao.searchProducts('Sony');
    expect(sony.length, 1);
    expect(sony.first.title, 'Wireless Earbuds');

    final sneakers = await productsDao.searchProducts('sneakers');
    expect(sneakers.length, 2);
  });

  test('productsDao pagination', () async {
    final list = List.generate(
      5,
      (index) => createProductCompanion(
        id: index + 1,
        title: 'Product ${index + 1}',
        description: 'Description ${index + 1}',
        category: 'general',
        price: 10.0 * (index + 1),
        stock: 10,
        thumbnail: 'https://example.com/$index.jpg',
      ),
    );
    await productsDao.saveProducts(list);

    final page1 = await productsDao.getPagedProducts(limit: 2, offset: 0);
    expect(page1.length, 2);
    expect(page1.first.id, 1);

    final page2 = await productsDao.getPagedProducts(limit: 2, offset: 2);
    expect(page2.length, 2);
    expect(page2.first.id, 3);
  });

  test(
    'productsDao reactive streams watchProductById and watchAllProducts',
    () async {
      final product = createProductCompanion(
        id: 50,
        title: 'Gaming Mouse',
        description: 'RGB optical mouse',
        category: 'accessories',
        price: 49.99,
        stock: 40,
        thumbnail: 'https://example.com/mouse.jpg',
      );

      await productsDao.saveProduct(product);

      final watched = await productsDao.watchProductById(50).first;
      expect(watched?.title, 'Gaming Mouse');

      final allWatched = await productsDao.watchAllProducts().first;
      expect(allWatched.length, 1);
    },
  );

  test('productsDao deletion operations', () async {
    final products = [
      createProductCompanion(
        id: 1,
        title: 'Item 1',
        description: 'Cat A item',
        category: 'category_a',
        price: 10.0,
        stock: 5,
        thumbnail: 'https://example.com/1.jpg',
      ),
      createProductCompanion(
        id: 2,
        title: 'Item 2',
        description: 'Cat A item 2',
        category: 'category_a',
        price: 20.0,
        stock: 5,
        thumbnail: 'https://example.com/2.jpg',
      ),
      createProductCompanion(
        id: 3,
        title: 'Item 3',
        description: 'Cat B item',
        category: 'category_b',
        price: 30.0,
        stock: 5,
        thumbnail: 'https://example.com/3.jpg',
      ),
    ];
    await productsDao.saveProducts(products);

    // Delete single product
    final deleted = await productsDao.deleteProduct(1);
    expect(deleted, 1);
    expect(await productsDao.getProductById(1), isNull);

    // Delete by category
    await productsDao.deleteProductsByCategory('category_a');
    expect(await productsDao.getProductById(2), isNull);
    expect(await productsDao.getProductById(3), isNotNull);

    // Delete all products
    await productsDao.deleteAllProducts();
    final count = await productsDao.getProductsCount();
    expect(count, 0);
  });

  test('productsDao ProductModel integration and extensions', () async {
    const model = ProductModel(
      id: 99,
      title: 'Model Product',
      description: 'Model Description',
      category: 'gadgets',
      price: 199.99,
      discountPercentage: 12.5,
      rating: 4.7,
      stock: 12,
      brand: 'GadgetCorp',
      thumbnail: 'https://example.com/gadget.jpg',
      images: [
        'https://example.com/gadget_1.jpg',
        'https://example.com/gadget_2.jpg',
      ],
    );

    // Save directly via model
    await productsDao.saveProductModel(model);

    final fetched = await productsDao.getProductById(99);
    expect(fetched, isNotNull);
    expect(fetched?.title, 'Model Product');
    expect(fetched?.images, [
      'https://example.com/gadget_1.jpg',
      'https://example.com/gadget_2.jpg',
    ]);

    // Convert back to model
    final converted = fetched!.toModel();
    expect(converted.id, 99);
    expect(converted.title, 'Model Product');
    expect(converted.price, 199.99);
    expect(converted.brand, 'GadgetCorp');
    expect(converted.images, [
      'https://example.com/gadget_1.jpg',
      'https://example.com/gadget_2.jpg',
    ]);

    // Batch save models
    await productsDao.saveProductModels([
      const ProductModel(
        id: 100,
        title: 'Batch 1',
        description: 'Desc 1',
        category: 'batch',
        price: 10.0,
        stock: 5,
        thumbnail: 'https://example.com/b1.jpg',
      ),
      const ProductModel(
        id: 101,
        title: 'Batch 2',
        description: 'Desc 2',
        category: 'batch',
        price: 20.0,
        stock: 10,
        thumbnail: 'https://example.com/b2.jpg',
      ),
    ]);

    final batchProducts = await productsDao.getProductsByCategory('batch');
    expect(batchProducts.length, 2);
  });
}
