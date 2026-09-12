import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_cart/controllers/favourites_controller.dart';
import 'package:offline_cart/screens/products/product_details/product_details_screen.dart';
import 'package:offline_cart/screens/products/widgets/product_card.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavouritesController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: const Color(0xFF0F172A),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Favourites',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF2563EB)),
          );
        }

        final items = controller.favourites;
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEE2E2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border_rounded,
                    size: 48,
                    color: Color(0xFFE11D48),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No Favourites Yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Items added to your favourites will appear here.',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final product = items[index];
            return ProductCard(
              product: product,
              onTap: () => Get.to(
                () => ProductDetailsScreen(productId: product.id),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.favorite, color: Color(0xFFE11D48)),
                onPressed: () => controller.removeFavourite(product.id),
              ),
            );
          },
        );
      }),
    );
  }
}

