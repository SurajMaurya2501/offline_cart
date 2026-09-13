import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_cart/presentation/controllers/dashboard_controller.dart';
import 'package:offline_cart/presentation/screens/dashboard/widgets/categories_bottom_sheet.dart';
import 'package:offline_cart/presentation/screens/dashboard/widgets/stat_card.dart';

class StatsSection extends StatelessWidget {
  final DashboardController controller;

  const StatsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => StatCard(
              title: 'Categories',
              count: controller.categories.length,
              icon: Icons.grid_view_rounded,
              color: const Color(0xFF4F46E5),
              bgColor: const Color(0xFFEEF2FF),
              onTap: () => CategoriesBottomSheet.show(context, controller),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Obx(
            () => StatCard(
              title: 'Products',
              count: controller.products.length,
              icon: Icons.inventory_2_rounded,
              color: const Color(0xFF0284C7),
              bgColor: const Color(0xFFE0F2FE),
            ),
          ),
        ),
      ],
    );
  }
}
