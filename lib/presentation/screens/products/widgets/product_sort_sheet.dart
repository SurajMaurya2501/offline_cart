import 'package:flutter/material.dart';
import 'package:offline_cart/presentation/controllers/category_products_controller.dart';

class ProductSortSheet extends StatelessWidget {
  final ProductSortOption selectedSort;
  final ValueChanged<ProductSortOption> onSelected;

  const ProductSortSheet({
    super.key,
    required this.selectedSort,
    required this.onSelected,
  });

  static void show(
    BuildContext context, {
    required ProductSortOption selectedSort,
    required ValueChanged<ProductSortOption> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) =>
          ProductSortSheet(selectedSort: selectedSort, onSelected: onSelected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Sort Products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            ...ProductSortOption.values.map((option) {
              final isSelected = option == selectedSort;
              IconData icon;
              switch (option) {
                case ProductSortOption.priceAsc:
                  icon = Icons.arrow_upward_rounded;
                  break;
                case ProductSortOption.priceDesc:
                  icon = Icons.arrow_downward_rounded;
                  break;
                case ProductSortOption.ratingDesc:
                  icon = Icons.star_rounded;
                  break;
                case ProductSortOption.ratingAsc:
                  icon = Icons.star_outline_rounded;
                  break;
                case ProductSortOption.none:
                  icon = Icons.restart_alt_rounded;
                  break;
              }

              return ListTile(
                leading: Icon(
                  icon,
                  color: isSelected
                      ? const Color(0xFF2563EB)
                      : Colors.grey.shade600,
                ),
                title: Text(
                  option.label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF1E293B),
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_rounded, color: Color(0xFF2563EB))
                    : null,
                onTap: () {
                  onSelected(option);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
