import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:offline_cart/api_services/product_service.dart';
import 'package:offline_cart/data/daos/category_dao.dart';
import 'package:offline_cart/data/database/app_database.dart';

class CategoriesController extends GetxController {
  final _productApiService = ProductService();
  final _categoryDao = AppDatabase().categoryDao;

  final isSyncing = false.obs;
  final progress = 0.0.obs;
  final statusText = ''.obs;
  CancelToken? cancelToken;

  Future<bool> syncCategories() async {
    try {
      isSyncing.value = true;
      progress.value = 0.0;
      statusText.value = 'Downloading categories';
      cancelToken = CancelToken();

      final result = await _productApiService.getCategories(
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            progress.value = received / total;
            statusText.value =
                'Downloading: ${(progress.value * 100).toInt()}%';
          } else {
            statusText.value =
                'Downloading: ${(received / 1024).toStringAsFixed(0)} KB';
          }
        },
      );

      statusText.value = 'Saving to database...';
      final categoryCompanion = result.map((e) => e.toCompanion()).toList();
      await _categoryDao.saveCategories(categoryCompanion);

      statusText.value = 'Categories downloaded';
      progress.value = 1.0;
      return true;
    } on DioException catch (error) {
      statusText.value = CancelToken.isCancel(error)
          ? 'Sync cancelled by user.'
          : 'Network error: ${error.message}';
      return false;
    } catch (error) {
      statusText.value = 'Failed to sync: $error';
      return false;
    } finally {
      isSyncing.value = false;
    }
  }

  @override
  void onClose() {
    cancelToken?.cancel();
    super.onClose();
  }
}
