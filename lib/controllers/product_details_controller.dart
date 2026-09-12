import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_cart/data/database/app_database.dart';

class ProductDetailsController extends GetxController {
  final int productId;
  final AppDatabase _db;

  final product = Rxn<ProductsTableData>();
  final isLoading = true.obs;
  final isFavourite = false.obs;
  final isInCart = false.obs;
  final cartQuantity = 0.obs;
  final currentImageIndex = 0.obs;

  StreamSubscription? _productSub;
  StreamSubscription? _favSub;
  StreamSubscription? _cartSub;

  ProductDetailsController({required this.productId, AppDatabase? database})
    : _db = database ?? AppDatabase.instance;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
    _bindStreams();
  }

  void _loadInitialData() async {
    final item = await _db.productsDao.getProductById(productId);
    if (item != null) {
      product.value = item;
      isLoading.value = false;
    }
  }

  void _bindStreams() {
    _productSub = _db.productsDao.watchProductById(productId).listen((item) {
      if (item != null) {
        product.value = item;
      }
      isLoading.value = false;
    });

    _favSub = _db.favouritesDao.watchIsFavourite(productId).listen((fav) {
      isFavourite.value = fav;
    });

    _cartSub = _db.cartDao.watchCartItem(productId).listen((cartItem) {
      if (cartItem != null) {
        isInCart.value = true;
        cartQuantity.value = cartItem.quantity;
      } else {
        isInCart.value = false;
        cartQuantity.value = 0;
      }
    });
  }

  void setImageIndex(int index) {
    currentImageIndex.value = index;
  }

  Future<void> toggleFavourite() async {
    final added = await _db.favouritesDao.toggleFavourite(productId);
    Get.rawSnackbar(
      message: added ? 'Added to favourites' : 'Removed from favourites',
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0F172A),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> addToCart() async {
    await _db.cartDao.addToCart(productId);
    Get.rawSnackbar(
      message: 'Product added to cart',
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0F172A),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onClose() {
    _productSub?.cancel();
    _favSub?.cancel();
    _cartSub?.cancel();
    super.onClose();
  }
}
