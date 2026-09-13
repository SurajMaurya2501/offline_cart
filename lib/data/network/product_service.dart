import 'package:dio/dio.dart';
import 'package:offline_cart/data/models/categories_model.dart';
import 'package:offline_cart/data/models/product_model.dart';

class ProductService {
  final _dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com/'));

  Future<List<CategoryModel>> getCategories({
    Function(int, int)? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final result = await _dio.get(
        'products/categories',
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      if (result.statusCode == 200) {
        return CategoryModel.listFromJson(result.data);
      } else {
        throw Exception("Something went wrong while fetching categories");
      }
    } on DioException {
      rethrow;
    } catch (error) {
      throw Exception("Something went wrong while fetching categories: $error");
    }
  }

  Future<ProductsResponseModel> getProducts({
    int limit = 200,
    Function(int, int)? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final result = await _dio.get(
        'products',
        queryParameters: {"limit": limit},
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      if (result.statusCode == 200) {
        return ProductsResponseModel.fromJson(result.data);
      } else {
        throw Exception("Something went wrong while fetching products");
      }
    } on DioException {
      rethrow;
    } catch (error) {
      throw Exception("Something went wrong while fetching products: $error");
    }
  }
}
