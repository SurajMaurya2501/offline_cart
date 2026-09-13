import 'package:flutter_test/flutter_test.dart';
import 'package:offline_cart/data/local/daos/category_dao.dart';
import 'package:offline_cart/data/local/daos/products_dao.dart';
import 'package:offline_cart/data/local/database/app_database.dart';
import 'package:offline_cart/data/models/categories_model.dart';
import 'package:offline_cart/data/models/product_model.dart';
import 'package:offline_cart/data/network/product_service.dart';
import 'package:offline_cart/presentation/controllers/product_sync_controller.dart';
import 'package:dio/dio.dart';

class FakeProductService extends ProductService {
  final List<CategoryModel> mockCategories;
  final ProductsResponseModel mockProducts;

  FakeProductService({
    this.mockCategories = const [],
    this.mockProducts = const ProductsResponseModel(),
  });

  @override
  Future<List<CategoryModel>> getCategories({
    Function(int, int)? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    onReceiveProgress?.call(1024, 2048);
    return mockCategories;
  }

  @override
  Future<ProductsResponseModel> getProducts({
    int limit = 200,
    Function(int, int)? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    onReceiveProgress?.call(512000, 1024000);
    return mockProducts;
  }
}

class FakeCategoryDao extends CategoryDao {
  final List<String> progressHistory = [];

  FakeCategoryDao() : super(AppDatabase.instance);

  @override
  Future<void> saveCategories(
    List<CategoriesTableCompanion> categories, {
    void Function(int count, int total)? onProgress,
  }) async {
    for (var i = 0; i < categories.length; i++) {
      onProgress?.call(i + 1, categories.length);
      progressHistory.add('${i + 1}/${categories.length}');
    }
  }
}

class FakeProductsDao extends ProductsDao {
  final List<String> progressHistory = [];

  FakeProductsDao() : super(AppDatabase.instance);

  @override
  Future<void> saveProducts(
    List<ProductsTableCompanion> products, {
    void Function(int count, int total)? onProgress,
  }) async {
    for (var i = 0; i < products.length; i++) {
      onProgress?.call(i + 1, products.length);
      progressHistory.add('${i + 1}/${products.length}');
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProductSyncController Progress Formatting', () {
    test('syncCategories shows progress while saving categories with (count/total)', () async {
      final fakeService = FakeProductService(
        mockCategories: [
          const CategoryModel(slug: 'cat1', name: 'Category 1', url: ''),
          const CategoryModel(slug: 'cat2', name: 'Category 2', url: ''),
          const CategoryModel(slug: 'cat3', name: 'Category 3', url: ''),
        ],
      );

      final fakeCategoryDao = FakeCategoryDao();
      final fakeProductsDao = FakeProductsDao();

      final controller = ProductSyncController(
        productService: fakeService,
        categoryDao: fakeCategoryDao,
        productsDao: fakeProductsDao,
      );

      final statuses = <String>[];
      final progresses = <double>[];

      controller.statusText.listen((val) => statuses.add(val));
      controller.progress.listen((val) => progresses.add(val));

      final success = await controller.syncCategories();

      expect(success, isTrue);
      expect(fakeCategoryDao.progressHistory, ['1/3', '2/3', '3/3']);
      expect(statuses, contains('Saving categories: (0/3)'));
      expect(statuses, contains('Saving categories: (1/3)'));
      expect(statuses, contains('Saving categories: (2/3)'));
      expect(statuses, contains('Saving categories: (3/3)'));
      expect(controller.isCategoriesDone.value, isTrue);
      expect(controller.progress.value, 1.0);
    });

    test('syncProducts shows progress during download and while saving with (count/total)', () async {
      final fakeService = FakeProductService(
        mockProducts: const ProductsResponseModel(
          products: [
            ProductModel(id: 1, title: 'Product 1'),
            ProductModel(id: 2, title: 'Product 2'),
          ],
        ),
      );

      final fakeCategoryDao = FakeCategoryDao();
      final fakeProductsDao = FakeProductsDao();

      final controller = ProductSyncController(
        productService: fakeService,
        categoryDao: fakeCategoryDao,
        productsDao: fakeProductsDao,
      );

      final statuses = <String>[];
      controller.statusText.listen((val) => statuses.add(val));

      final success = await controller.syncProducts();

      expect(success, isTrue);
      expect(fakeProductsDao.progressHistory, ['1/2', '2/2']);
      expect(statuses, contains(predicate((String s) => s.contains('Downloading products:'))));
      expect(statuses, contains('Saving products: (0/2)'));
      expect(statuses, contains('Saving products: (1/2)'));
      expect(statuses, contains('Saving products: (2/2)'));
      expect(controller.isProductsDone.value, isTrue);
      expect(controller.progress.value, 1.0);
    });
  });
}

