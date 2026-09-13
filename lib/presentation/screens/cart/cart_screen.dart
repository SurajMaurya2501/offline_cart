import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_cart/presentation/controllers/cart_controller.dart';
import 'package:offline_cart/presentation/screens/products/product_details/product_details_screen.dart';
import 'package:offline_cart/presentation/widgets/sync_status_banner.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());

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
          'Shopping Cart',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Obx(() {
            if (controller.cartItems.isEmpty) return const SizedBox.shrink();
            return IconButton(
              tooltip: 'Clear Cart',
              icon: Icon(
                Icons.delete_sweep_rounded,
                color: Colors.red.shade600,
              ),
              onPressed: () => _confirmClearCart(context, controller),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF2563EB)),
          );
        }

        final items = controller.cartItems;
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEF2FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.remove_shopping_cart_rounded,
                    size: 48,
                    color: Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your cart is empty',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Add products from the catalog to get started.',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: SyncStatusBanner(),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final entry = items[index];
                  final product = entry.product;
                  final quantity = entry.cartItem.quantity;
                  final itemTotal = product.price * quantity;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Get.to(
                            () => ProductDetailsScreen(productId: product.id),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 80,
                              height: 80,
                              color: const Color(0xFFF1F5F9),
                              child: CachedNetworkImage(
                                imageUrl: product.thumbnail,
                                fit: BoxFit.cover,
                                placeholder: (_, _) => const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (_, _, _) => const Icon(
                                  Icons.broken_image_rounded,
                                  color: Colors.grey,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => Get.to(
                                        () => ProductDetailsScreen(
                                          productId: product.id,
                                        ),
                                      ),
                                      child: Text(
                                        product.title,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.red.shade400,
                                      size: 20,
                                    ),
                                    onPressed: () => controller.deleteProduct(
                                      product.id,
                                      productTitle: product.title,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${product.price.toStringAsFixed(2)} each',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${itemTotal.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () =>
                                              controller.decrementQuantity(
                                                product.id,
                                                quantity,
                                                productTitle: product.title,
                                              ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(6),
                                            child: Icon(Icons.remove, size: 16),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Text(
                                            '$quantity',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () =>
                                              controller.incrementQuantity(
                                                product.id,
                                                quantity,
                                                productTitle: product.title,
                                              ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(6),
                                            child: Icon(Icons.add, size: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildCartSummary(controller),
          ],
        );
      }),
    );
  }

  Widget _buildCartSummary(CartController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total ${controller.itemCount == 1 ? 'item' : 'items'}',
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                Text(
                  '${controller.itemCount}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal',
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                Text(
                  '\$${controller.subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Discount',
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                Text(
                  controller.discount > 0
                      ? '-\$${controller.discount.toStringAsFixed(2)}'
                      : '\$0.00',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: controller.discount > 0
                        ? const Color(0xFF059669)
                        : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Grand Total',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  '\$${controller.grandTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.checkout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClearCart(BuildContext context, CartController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cart'),
        content: const Text(
          'Are you sure you want to remove all items from your cart?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back();
              controller.clearCart();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
