import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_cart/controllers/product_details_controller.dart';
import 'package:offline_cart/screens/cart/cart_screen.dart';
import 'package:offline_cart/screens/products/product_details/widgets/product_action_bottom_bar.dart';
import 'package:offline_cart/screens/products/product_details/widgets/product_description_section.dart';
import 'package:offline_cart/screens/products/product_details/widgets/product_header_section.dart';
import 'package:offline_cart/screens/products/product_details/widgets/product_images_carousel.dart';
import 'package:offline_cart/screens/products/product_details/widgets/product_price_section.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final ProductDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      ProductDetailsController(productId: widget.productId),
      tag: widget.productId.toString(),
    );
  }

  @override
  void dispose() {
    Get.delete<ProductDetailsController>(tag: widget.productId.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Product Details',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isFavourite.value
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: controller.isFavourite.value
                    ? Colors.red.shade600
                    : const Color(0xFF0F172A),
              ),
              onPressed: controller.toggleFavourite,
            ),
          ),
          IconButton(
            tooltip: 'Cart',
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Color(0xFF0F172A),
            ),
            onPressed: () => Get.to(() => const CartScreen()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF2563EB)),
          );
        }

        final product = controller.product.value;
        if (product == null) {
          return const Center(
            child: Text(
              'Product not found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImagesCarousel(
                controller: controller,
                images: product.images,
                discountPercentage: product.discountPercentage,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductHeaderSection(
                      title: product.title,
                      brand: product.brand,
                      category: product.category,
                      rating: product.rating,
                      stock: product.stock,
                    ),
                    const SizedBox(height: 16),
                    ProductPriceSection(
                      price: product.price,
                      discountPercentage: product.discountPercentage,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(height: 1),
                    ),
                    ProductDescriptionSection(description: product.description),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: ProductActionBottomBar(controller: controller),
    );
  }
}
