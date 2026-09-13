import 'package:flutter/material.dart';

class ProductSearchBar extends StatelessWidget {
  final TextEditingController textController;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onSortTap;
  final bool hasActiveFilter;

  const ProductSearchBar({
    super.key,
    required this.textController,
    required this.onChanged,
    required this.onClear,
    required this.onSortTap,
    this.hasActiveFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: textController,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: 'Search by title, brand...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF64748B),
                    size: 20,
                  ),
                  suffixIcon: textController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          color: Colors.grey.shade500,
                          onPressed: onClear,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: hasActiveFilter ? const Color(0xFF2563EB) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onSortTap,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.tune_rounded,
                  color: hasActiveFilter
                      ? Colors.white
                      : const Color(0xFF1E293B),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
