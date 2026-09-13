import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:offline_cart/data/network/product_service.dart';
import 'package:offline_cart/data/local/daos/category_dao.dart';
import 'package:offline_cart/data/local/daos/products_dao.dart';
import 'package:offline_cart/data/local/database/app_database.dart';

enum SyncStep { idle, categories, products, completed, error, noInternet }

class ProductSyncController extends GetxController {
  final ProductService _productApiService;
  final CategoryDao _categoryDao;
  final ProductsDao _productDao;

  ProductSyncController({ProductService? productService, AppDatabase? database})
    : _productApiService = productService ?? ProductService(),
      _categoryDao = (database ?? AppDatabase.instance).categoryDao,
      _productDao = (database ?? AppDatabase.instance).productsDao;

  final isSyncing = false.obs;
  final hasError = false.obs;
  final progress = 0.0.obs;
  final statusText = ''.obs;
  final currentStep = SyncStep.idle.obs;
  final isCategoriesDone = false.obs;
  final isProductsDone = false.obs;

  CancelToken? cancelToken;

  Future<bool> syncCategories() async {
    try {
      currentStep.value = SyncStep.categories;
      statusText.value = 'Fetching categories...';
      progress.value = 0.0;
      cancelToken = CancelToken();

      final result = await _productApiService.getCategories(
        cancelToken: cancelToken,
      );

      statusText.value = 'Saving categories...';
      final categoryCompanions = result.map((e) => e.toCompanion()).toList();
      await _categoryDao.saveCategories(categoryCompanions);

      isCategoriesDone.value = true;
      progress.value = 1.0;
      return true;
    } on DioException catch (error) {
      _handleError(error);
      return false;
    } catch (error) {
      _handleGenericError(error);
      return false;
    }
  }

  Future<bool> syncProducts() async {
    try {
      currentStep.value = SyncStep.products;
      statusText.value = 'Fetching products...';
      progress.value = 0.0;
      cancelToken = CancelToken();

      final result = await _productApiService.getProducts(
        cancelToken: cancelToken,
        limit: 200,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            progress.value = received / total;
            statusText.value =
                'Downloading products: ${(progress.value * 100).toInt()}%';
          } else {
            statusText.value =
                'Downloading products: ${(received / 1024).toStringAsFixed(0)} KB';
          }
        },
      );

      statusText.value = 'Saving products to your device...';
      final productCompanions = result.products
          .map((e) => e.toCompanion())
          .toList();
      await _productDao.saveProducts(productCompanions);

      isProductsDone.value = true;
      progress.value = 1.0;
      return true;
    } on DioException catch (error) {
      _handleError(error);
      return false;
    } catch (error) {
      _handleGenericError(error);
      return false;
    }
  }

  Future<bool> syncCatalog() async {
    // Check connectivity before attempting any network call
    final hasConnection = await InternetConnection().hasInternetAccess;
    if (!hasConnection) {
      currentStep.value = SyncStep.noInternet;
      statusText.value = 'No internet connection';
      return false;
    }

    isSyncing.value = true;
    hasError.value = false;

    // Step 1: Categories (skip if already completed in previous retry)
    if (!isCategoriesDone.value) {
      final catSuccess = await syncCategories();
      if (!catSuccess) {
        isSyncing.value = false;
        return false;
      }
    }

    // Step 2: Products
    final prodSuccess = await syncProducts();
    if (!prodSuccess) {
      isSyncing.value = false;
      return false;
    }

    currentStep.value = SyncStep.completed;
    statusText.value = "You're all set! Everything is ready.";
    isSyncing.value = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_sync_date', DateTime.now().toIso8601String());
    return true;
  }

  void _handleError(DioException error) {
    hasError.value = true;
    currentStep.value = SyncStep.error;
    statusText.value = CancelToken.isCancel(error)
        ? 'Sync cancelled by user.'
        : 'Network issue: ${error.message ?? 'Please check connection'}';
  }

  void _handleGenericError(Object error) {
    hasError.value = true;
    currentStep.value = SyncStep.error;
    statusText.value = 'Failed to sync: $error';
  }

  void reset() {
    cancelToken?.cancel();
    isSyncing.value = false;
    hasError.value = false;
    progress.value = 0.0;
    statusText.value = '';
    currentStep.value = SyncStep.idle;
    isCategoriesDone.value = false;
    isProductsDone.value = false;
  }

  @override
  void onClose() {
    cancelToken?.cancel();
    super.onClose();
  }
}
