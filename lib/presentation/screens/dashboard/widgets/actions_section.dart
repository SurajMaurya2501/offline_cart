import 'package:flutter/material.dart';
import 'package:offline_cart/presentation/controllers/dashboard_controller.dart';
import 'package:offline_cart/presentation/screens/dashboard/widgets/action_button.dart';
import 'package:offline_cart/presentation/screens/dashboard/widgets/categories_bottom_sheet.dart';

class ActionsSection extends StatelessWidget {
  final DashboardController controller;

  const ActionsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 14),
        ActionButton(
          title: 'View Categories',
          subtitle: 'Explore all synced product categories',
          icon: Icons.category_outlined,
          color: const Color(0xFF2563EB),
          onTap: () => CategoriesBottomSheet.show(context, controller),
        ),
        const SizedBox(height: 10),
        ActionButton(
          title: 'Refresh Data',
          subtitle: 'Sync latest categories and products',
          icon: Icons.sync_rounded,
          color: const Color(0xFF059669),
          onTap: controller.refreshData,
        ),
        const SizedBox(height: 10),
        ActionButton(
          title: 'Logout',
          subtitle: 'Sign out and clear local session',
          icon: Icons.logout_rounded,
          color: const Color(0xFFDC2626),
          onTap: controller.logout,
        ),
      ],
    );
  }
}
