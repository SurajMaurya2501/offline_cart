import 'package:flutter/material.dart';

class EmptyProductsView extends StatelessWidget {
  final bool isSearch;
  final VoidCallback? onResetSearch;

  const EmptyProductsView({
    super.key,
    required this.isSearch,
    this.onResetSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSearch
                    ? Icons.search_off_rounded
                    : Icons.inventory_2_outlined,
                size: 56,
                color: const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isSearch
                  ? 'No matching products found.'
                  : 'No products available.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
            if (isSearch && onResetSearch != null) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: onResetSearch,
                icon: const Icon(Icons.clear_rounded, size: 18),
                label: const Text('Clear Search'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF2563EB),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
