import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_cart/presentation/controllers/product_details_controller.dart';

class ProductImagesCarousel extends StatelessWidget {
  final ProductDetailsController controller;
  final List<String> images;
  final double? discountPercentage;

  const ProductImagesCarousel({
    super.key,
    required this.controller,
    required this.images,
    this.discountPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final displayImages = images.isNotEmpty ? images : [''];

    return Stack(
      children: [
        Container(
          height: 320,
          width: double.infinity,
          color: const Color(0xFFF1F5F9),
          child: PageView.builder(
            itemCount: displayImages.length,
            onPageChanged: controller.setImageIndex,
            itemBuilder: (context, index) {
              final imageUrl = displayImages[index];
              return CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (_, _) => const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF2563EB),
                  ),
                ),
                errorWidget: (_, _, _) => const Center(
                  child: Icon(
                    Icons.broken_image_rounded,
                    size: 64,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
        if (discountPercentage != null && discountPercentage! > 0)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.shade600,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '-${discountPercentage!.toStringAsFixed(0)}% OFF',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (displayImages.length > 1)
          Positioned(
            bottom: 14,
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  displayImages.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: controller.currentImageIndex.value == index ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: controller.currentImageIndex.value == index
                          ? const Color(0xFF2563EB)
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

