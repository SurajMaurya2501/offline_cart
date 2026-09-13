import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_cart/presentation/controllers/product_details_controller.dart';

class ProductActionBottomBar extends StatelessWidget {
  final ProductDetailsController controller;

  const ProductActionBottomBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Obx(
              () => Container(
                decoration: BoxDecoration(
                  color: controller.isFavourite.value
                      ? const Color(0xFFFEE2E2)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: controller.toggleFavourite,
                  tooltip: 'Add To Favourite',
                  icon: Icon(
                    controller.isFavourite.value
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: controller.isFavourite.value
                        ? Colors.red.shade600
                        : const Color(0xFF475569),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Obx(
                () => ElevatedButton.icon(
                  onPressed: controller.addToCart,
                  icon: const Icon(Icons.shopping_bag_outlined, size: 20),
                  label: Text(
                    controller.isInCart.value
                        ? 'Add More (${controller.cartQuantity.value} in Cart)'
                        : 'Add To Cart',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
