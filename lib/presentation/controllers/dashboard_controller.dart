import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:offline_cart/presentation/controllers/auth_controller.dart';
import 'package:offline_cart/data/local/database/app_database.dart';
import 'package:offline_cart/presentation/screens/auth/login_screen.dart';

class DashboardController extends GetxController {
  final user = Rxn<UserTableData>();
  final categories = <CategoriesTableData>[].obs;
  final products = <ProductsTableData>[].obs;
  final lastSyncDate = Rxn<DateTime>();

  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    final db = AppDatabase.instance;
    user.bindStream(
      db
          .select(db.userTable)
          .watch()
          .map((list) => list.isNotEmpty ? list.first : null),
    );
    categories.bindStream(db.categoryDao.watchAllCategories());
    products.bindStream(db.productsDao.watchAllProducts());
    loadLastSyncDate();
  }

  Future<void> loadLastSyncDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString('last_sync_date');
    if (dateStr != null) {
      lastSyncDate.value = DateTime.tryParse(dateStr);
    } else if (categories.isNotEmpty || products.isNotEmpty) {
      lastSyncDate.value = DateTime.now();
    }
  }

  Future<void> refreshData() async {
    await authController.syncCatalog();
    await loadLastSyncDate();
  }

  Future<void> logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Logout'),
        content: const Text(
          'Are you sure you want to log out of your session? All locally stored data will be erased.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Get.back(result: true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      Get.dialog(
        const PopScope(
          canPop: false,
          child: Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Erasing local data and logging out...',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
      try {
        await authController.signOut();
        lastSyncDate.value = null;
      } finally {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      }
      Get.offAll(() => const LoginScreen());
    }
  }

  String formatSyncDate(DateTime? dt) {
    if (dt == null) return 'Never synced';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes} min ago';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $hour:$minute $ampm';
  }
}
