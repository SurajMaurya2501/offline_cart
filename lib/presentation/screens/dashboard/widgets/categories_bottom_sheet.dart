import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_cart/presentation/controllers/dashboard_controller.dart';
import 'package:offline_cart/presentation/screens/products/category_products_screen.dart';

class CategoriesBottomSheet extends StatelessWidget {
  final DashboardController controller;

  const CategoriesBottomSheet({super.key, required this.controller});

  static void show(BuildContext context, DashboardController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => CategoriesBottomSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.category_rounded, color: Color(0xFF2563EB)),
                  const SizedBox(width: 8),
                  Obx(
                    () => Text(
                      'Categories (${controller.categories.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Obx(() {
                if (controller.categories.isEmpty) {
                  return const Center(child: Text('No categories available'));
                }
                return ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.categories.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = controller.categories[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(
                            0xFF2563EB,
                          ).withValues(alpha: 0.1),
                          child: Text(
                            item.name.isNotEmpty
                                ? item.name[0].toUpperCase()
                                : '#',
                            style: const TextStyle(
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          item.slug,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Get.to(
                            () => CategoryProductsScreen(
                              categorySlug: item.slug,
                              categoryName: item.name,
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
