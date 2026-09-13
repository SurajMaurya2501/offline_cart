import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_cart/data/network/sync_manager.dart';
import 'presentation/screens/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(SyncManager(), permanent: true);
  runApp(const ProductCatalog());
}

class ProductCatalog extends StatelessWidget {
  final bool isLoggedIn;

  const ProductCatalog({super.key, this.isLoggedIn = false});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Product Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const SplashScreen(),
    );
  }
}
