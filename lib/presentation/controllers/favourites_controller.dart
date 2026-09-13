import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_cart/data/database/app_database.dart';

class FavouritesController extends GetxController {
  final AppDatabase _db = AppDatabase.instance;
  final favourites = <ProductsTableData>[].obs;
  final isLoading = true.obs;
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscription = _db.favouritesDao.watchFavouriteProducts().listen((data) {
      favourites.value = data;
      isLoading.value = false;
    });
  }

  Future<void> removeFavourite(int productId) async {
    await _db.favouritesDao.removeFavourite(productId);
    Get.rawSnackbar(
      message: 'Removed from favourites',
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0F172A),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> addFavourite(int productId) async {
    await _db.favouritesDao.addFavourite(productId);
    Get.rawSnackbar(
      message: 'Added to favourites',
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0F172A),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
