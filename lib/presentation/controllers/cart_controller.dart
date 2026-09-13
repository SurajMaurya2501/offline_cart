import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_cart/data/local/daos/cart_dao.dart';
import 'package:offline_cart/data/local/database/app_database.dart';
import 'package:offline_cart/data/network/cart_api_service.dart';

class CartController extends GetxController {
  final AppDatabase _db = AppDatabase.instance;
  final CartApiService _cartApi;
  final cartItems = <CartItemWithProduct>[].obs;
  final isLoading = true.obs;
  StreamSubscription? _subscription;

  CartController({CartApiService? cartApiService})
    : _cartApi = cartApiService ?? CartApiService();

  @override
  void onInit() {
    super.onInit();
    _subscription = _db.cartDao.watchCartWithProducts().listen((items) {
      cartItems.value = items;
      isLoading.value = false;
    });
  }

  int get itemCount => cartItems.fold(0, (sum, i) => sum + i.cartItem.quantity);

  double get subtotal => cartItems.fold(0.0, (sum, i) {
    final orig = (i.product.discountPercentage ?? 0) > 0
        ? i.product.price / (1 - (i.product.discountPercentage! / 100))
        : i.product.price;
    return sum + (orig * i.cartItem.quantity);
  });

  double get grandTotal => cartItems.fold(
    0.0,
    (sum, i) => sum + (i.product.price * i.cartItem.quantity),
  );

  double get discount => subtotal > grandTotal ? subtotal - grandTotal : 0.0;

  Future<void> addProduct(
    int productId, {
    int quantity = 1,
    String? productTitle,
  }) async {
    await _db.cartDao.addToCart(productId, quantity: quantity);
    _cartApi
        .addToCart(
          productId: productId,
          quantity: quantity,
          productTitle: productTitle,
        )
        .catchError((_) => null);
  }

  Future<void> updateQuantity(
    int productId,
    int quantity, {
    String? productTitle,
  }) async {
    await _db.cartDao.updateQuantity(productId, quantity);
    _cartApi
        .updateQuantity(
          productId: productId,
          quantity: quantity,
          productTitle: productTitle,
        )
        .catchError((_) => null);
  }

  Future<void> incrementQuantity(
    int productId,
    int currentQuantity, {
    String? productTitle,
  }) => updateQuantity(
    productId,
    currentQuantity + 1,
    productTitle: productTitle,
  );

  Future<void> decrementQuantity(
    int productId,
    int currentQuantity, {
    String? productTitle,
  }) => updateQuantity(
    productId,
    currentQuantity - 1,
    productTitle: productTitle,
  );

  Future<void> deleteProduct(int productId, {String? productTitle}) async {
    await _db.cartDao.removeFromCart(productId);
    _cartApi
        .removeFromCart(productId: productId, productTitle: productTitle)
        .catchError((_) => null);

    Get.rawSnackbar(
      message: 'Item removed from cart',
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0F172A),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> checkout() async {
    if (cartItems.isEmpty) return;

    final items = cartItems
        .map(
          (i) => {
            'id': i.cartItem.productId,
            'quantity': i.cartItem.quantity,
            'title': i.product.title,
          },
        )
        .toList();

    await _cartApi
        .checkout(items: items, total: grandTotal)
        .catchError((_) => null);

    await clearCart();

    Get.rawSnackbar(
      message: 'Order placed! Saved offline and will sync when connected.',
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF16A34A),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> clearCart() async {
    await _db.cartDao.clearCart();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
