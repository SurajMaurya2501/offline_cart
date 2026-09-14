import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:offline_cart/presentation/controllers/auth_controller.dart';
import 'package:offline_cart/data/local/database/app_database.dart';
import 'package:offline_cart/presentation/screens/auth/login_screen.dart';
import 'package:offline_cart/presentation/widgets/logout_dialog.dart';

const _syncDatePrefsKey = 'last_sync_date';

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
    final dateStr = prefs.getString(_syncDatePrefsKey);
    if (dateStr != null) {
      lastSyncDate.value = DateTime.tryParse(dateStr);
      return;
    }
    // No stored timestamp yet but we already have data on disk - probably an
    // upgrade from before we started tracking this. Just stamp it now.
    if (categories.isNotEmpty || products.isNotEmpty) {
      lastSyncDate.value = DateTime.now();
    }
  }

  Future<void> refreshData() async {
    await authController.syncCatalog();
    await loadLastSyncDate();
  }

  Future<void> logout() async {
    final confirmed = await LogoutDialog.confirm();
    if (!confirmed) return;

    LogoutDialog.showProgress();
    try {
      await authController.signOut();
      lastSyncDate.value = null;
    } finally {
      LogoutDialog.dismissProgress();
    }
    Get.offAll(() => const LoginScreen());
  }

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  // Not pulling in intl just for one label - this covers what we need.
  String formatSyncDate(DateTime? dt) {
    if (dt == null) return 'Never synced';

    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes} min ago';

    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '${dt.day} ${_months[dt.month - 1]} ${dt.year}, $hour:$minute $ampm';
  }
}
