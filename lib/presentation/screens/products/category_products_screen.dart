import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_cart/presentation/controllers/category_products_controller.dart';
import 'package:offline_cart/presentation/screens/products/product_details/product_details_screen.dart';
import 'package:offline_cart/presentation/screens/products/widgets/empty_state_view.dart';
import 'package:offline_cart/presentation/screens/products/widgets/product_card.dart';
import 'package:offline_cart/presentation/screens/products/widgets/product_search_bar.dart';
import 'package:offline_cart/presentation/screens/products/widgets/product_sort_sheet.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categorySlug;
  final String categoryName;

  const CategoryProductsScreen({
    super.key,
    required this.categorySlug,
    required this.categoryName,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  late final CategoryProductsController controller;
  late final TextEditingController searchTextController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      CategoryProductsController(
        initialSlug: widget.categorySlug,
        initialName: widget.categoryName,
      ),
    );
    controller.selectCategory(widget.categorySlug, widget.categoryName);
    searchTextController = TextEditingController();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    Get.delete<CategoryProductsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.selectedCategoryName.value,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                '${controller.filteredProducts.length} items',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Obx(
            () => ProductSearchBar(
              textController: searchTextController,
              hasActiveFilter:
                  controller.selectedSort.value != ProductSortOption.none,
              onChanged: controller.setSearchQuery,
              onClear: () {
                searchTextController.clear();
                controller.clearSearch();
              },
              onSortTap: () => ProductSortSheet.show(
                context,
                selectedSort: controller.selectedSort.value,
                onSelected: controller.setSortOption,
              ),
            ),
          ),

          // Categories horizontal chips bar
          _buildCategoryChips(),

          // Active Sort Indicator
          _buildActiveSortPill(),

          // Product List with Pull to Refresh
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                );
              }

              final products = controller.filteredProducts;

              if (products.isEmpty) {
                return RefreshIndicator(
                  onRefresh: controller.refreshProducts,
                  color: const Color(0xFF2563EB),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: EmptyProductsView(
                        isSearch: controller.hasSearchQuery,
                        onResetSearch: () {
                          searchTextController.clear();
                          controller.clearSearch();
                        },
                      ),
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshProducts,
                color: const Color(0xFF2563EB),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 4, bottom: 24),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final item = products[index];
                    return ProductCard(
                      product: item,
                      onTap: () => Get.to(
                        () => ProductDetailsScreen(productId: item.id),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Obx(() {
      final categories = controller.categories;
      final activeSlug = controller.selectedCategorySlug.value.toLowerCase();
      final activeName = controller.selectedCategoryName.value.toLowerCase();

      if (categories.isEmpty) return const SizedBox.shrink();

      return SizedBox(
        height: 38,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              for (int i = 0; i < categories.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                _CategoryChip(
                  key: ValueKey(categories[i].slug),
                  label: categories[i].name,
                  isSelected:
                      categories[i].slug.toLowerCase() == activeSlug ||
                      categories[i].name.toLowerCase() == activeName,
                  onTap: () => controller.selectCategory(
                    categories[i].slug,
                    categories[i].name,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildActiveSortPill() {
    return Obx(() {
      final sort = controller.selectedSort.value;
      if (sort == ProductSortOption.none) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.sort_rounded,
                    size: 14,
                    color: Color(0xFF2563EB),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    sort.label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () =>
                        controller.setSortOption(ProductSortOption.none),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _CategoryChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> {
  @override
  void initState() {
    super.initState();
    if (widget.isSelected) _scrollToMe();
  }

  @override
  void didUpdateWidget(covariant _CategoryChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) _scrollToMe();
  }

  void _scrollToMe() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Scrollable.ensureVisible(
          context,
          alignment: 0.5,
          duration: const Duration(milliseconds: 300),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            widget.onTap();
            _scrollToMe();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: widget.isSelected ? const Color(0xFF2563EB) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isSelected
                    ? const Color(0xFF2563EB)
                    : Colors.grey.shade300,
                width: widget.isSelected ? 1.5 : 1.0,
              ),
              boxShadow: widget.isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    widget.isSelected ? FontWeight.bold : FontWeight.w500,
                color: widget.isSelected
                    ? Colors.white
                    : const Color(0xFF475569),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
