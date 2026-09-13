import 'package:dio/dio.dart';
import 'package:offline_cart/data/network/dio_client.dart';

class CartApiService {
  final Dio _dio;

  CartApiService({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  /// Syncs an item added to cart with DummyJSON API
  Future<Response?> addToCart({
    required int productId,
    required int quantity,
    String? productTitle,
  }) async {
    final title = productTitle != null
        ? '"$productTitle"'
        : 'Product #$productId';
    return _dio.post(
      'carts/add',
      data: {
        'userId': 1,
        'products': [
          {'id': productId, 'quantity': quantity},
        ],
      },
      options: Options(
        extra: {'description': 'Add $title to cart', 'queue_offline': true},
      ),
    );
  }

  /// Syncs updated item quantity
  Future<Response?> updateQuantity({
    required int productId,
    required int quantity,
    String? productTitle,
  }) async {
    final title = productTitle != null
        ? '"$productTitle"'
        : 'Product #$productId';
    return _dio.put(
      'carts/1',
      data: {
        'merge': true,
        'products': [
          {'id': productId, 'quantity': quantity},
        ],
      },
      options: Options(
        extra: {
          'description': 'Update $title quantity to $quantity',
          'queue_offline': true,
        },
      ),
    );
  }

  /// Syncs item removal
  Future<Response?> removeFromCart({
    required int productId,
    String? productTitle,
  }) async {
    final title = productTitle != null
        ? '"$productTitle"'
        : 'Product #$productId';
    return _dio.delete(
      'carts/1',
      options: Options(
        extra: {
          'description': 'Remove $title from cart',
          'queue_offline': true,
        },
      ),
    );
  }

  /// Syncs checkout
  Future<Response?> checkout({
    required List<Map<String, dynamic>> items,
    required double total,
  }) async {
    return _dio.post(
      'carts/add',
      data: {'userId': 1, 'products': items, 'total': total},
      options: Options(
        extra: {
          'description': 'Checkout order (${items.length} items)',
          'queue_offline': true,
        },
      ),
    );
  }
}
