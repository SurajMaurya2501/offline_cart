import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_cart/data/local/daos/cart_dao.dart';
import 'package:offline_cart/data/local/database/app_database.dart';

class CartController extends GetxController {
  final AppDatabase _db = AppDatabase.instance;
  final cartItems = <CartItemWithProduct>[].obs;
  final isLoading = true.obs;
  StreamSubscription? _subscription;

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

  Future<void> addProduct(int productId, {int quantity = 1}) async {
    await _db.cartDao.addToCart(productId, quantity: quantity);
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    await _db.cartDao.updateQuantity(productId, quantity);
  }

  Future<void> incrementQuantity(int productId, int currentQuantity) =>
      updateQuantity(productId, currentQuantity + 1);

  Future<void> decrementQuantity(int productId, int currentQuantity) =>
      updateQuantity(productId, currentQuantity - 1);

  Future<void> deleteProduct(int productId) async {
    await _db.cartDao.removeFromCart(productId);
    Get.rawSnackbar(
      message: 'Item removed from cart',
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0F172A),
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
