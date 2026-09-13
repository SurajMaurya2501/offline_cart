import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:offline_cart/presentation/controllers/product_sync_controller.dart';
import 'package:offline_cart/core/services/auth_service.dart';
import 'package:offline_cart/data/daos/user_dao.dart';
import 'package:offline_cart/data/database/app_database.dart';
import 'package:offline_cart/data/models/user_model.dart';
import 'package:offline_cart/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:offline_cart/presentation/widgets/sync_progress_dialog.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final UserDao _userDao = AppDatabase().userDao;
  final ProductSyncController _syncController = Get.put(
    ProductSyncController(),
  );

  final isLoading = false.obs;
  final currentUser = Rxn<UserModel>();

  ProductSyncController get syncController => _syncController;

  @override
  void onInit() {
    super.onInit();
    _loadStoredUser();
  }

  Future<void> _loadStoredUser() async {
    final user = await _userDao.getCurrentUser();
    if (user != null) {
      currentUser.value = UserModel(
        id: user.id,
        displayName: user.name,
        email: user.email,
        photoUrl: user.profileImage,
      );
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      final user = await _authService.signInWithGoogle();
      if (user == null) {
        isLoading.value = false;
        return;
      }
      await _userDao.saveUserModel(user);
      currentUser.value = user;
      isLoading.value = false;
      await syncCatalog();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Sign In Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Future<void> syncCatalog() async {
    SyncProgressDialog.show(_syncController, onRetry: _runSync);
    await _runSync();
  }

  Future<void> _runSync() async {
    final success = await _syncController.syncCatalog();
    if (success) {
      await Future.delayed(const Duration(milliseconds: 700));
      Get.back(); // close dialog
      Get.offAll(() => const DashboardScreen());
    }
  }

  Future<void> syncCategories() async {
    Future<void> retry() async {
      final success = await _syncController.syncCategories();
      if (success) {
        await Future.delayed(const Duration(milliseconds: 700));
        Get.back();
        Get.offAll(() => const DashboardScreen());
      }
    }

    SyncProgressDialog.show(_syncController, onRetry: retry);
    await retry();
  }

  Future<void> syncProducts() async {
    Future<void> retry() async {
      final success = await _syncController.syncProducts();
      if (success) {
        await Future.delayed(const Duration(milliseconds: 700));
        Get.back();
        Get.offAll(() => const DashboardScreen());
      }
    }

    SyncProgressDialog.show(_syncController, onRetry: retry);
    await retry();
  }

  Future<void> signOut() async {
    try {
      try {
        await _authService.signOut();
      } catch (e) {
        debugPrint(
          'AuthService signOut error (proceeding with local cleanup): $e',
        );
      }
      await AppDatabase.instance.clearAllData();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
      currentUser.value = null;
      _syncController.reset();
    } catch (e) {
      Get.snackbar(
        'Sign Out Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
