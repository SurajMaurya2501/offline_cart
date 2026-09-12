import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_cart/data/database/app_database.dart';

enum ProductSortOption {
  none('Default'),
  priceAsc('Price: Low to High'),
  priceDesc('Price: High to Low'),
  ratingDesc('Rating: High to Low'),
  ratingAsc('Rating: Low to High');

  final String label;
  const ProductSortOption(this.label);
}

class CategoryProductsController extends GetxController {
  final AppDatabase _db = AppDatabase.instance;

  final selectedCategorySlug = ''.obs;
  final selectedCategoryName = ''.obs;
  final searchQuery = ''.obs;
  final selectedSort = ProductSortOption.none.obs;
  final isLoading = false.obs;

  final allProducts = <ProductsTableData>[].obs;
  final categories = <CategoriesTabelData>[].obs;

  StreamSubscription? _productsSubscription;
  StreamSubscription? _categoriesSubscription;

  CategoryProductsController({String? initialSlug, String? initialName}) {
    if (initialSlug != null && initialSlug.isNotEmpty) {
      selectedCategorySlug.value = initialSlug;
      selectedCategoryName.value = initialName ?? initialSlug;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _watchCategories();
    if (selectedCategorySlug.value.isNotEmpty) {
      _watchProductsForSelectedCategory();
    }
  }

  void _watchCategories() {
    _categoriesSubscription?.cancel();
    _categoriesSubscription = _db.categoryDao.watchAllCategories().listen((
      list,
    ) {
      categories.value = list;
      // If no category was initially set, pick the first available one
      if (selectedCategorySlug.value.isEmpty && list.isNotEmpty) {
        selectCategory(list.first.slug, list.first.name);
      }
    });
  }

  void selectCategory(String slug, String name) {
    if (selectedCategorySlug.value == slug &&
        selectedCategoryName.value == name) {
      return;
    }
    selectedCategorySlug.value = slug;
    selectedCategoryName.value = name;
    searchQuery.value = '';
    _watchProductsForSelectedCategory();
  }

  void _watchProductsForSelectedCategory() {
    isLoading.value = true;
    _productsSubscription?.cancel();
    _productsSubscription = _db.productsDao
        .watchProductsByCategory(
          selectedCategorySlug.value,
          altCategory: selectedCategoryName.value,
        )
        .listen(
          (data) {
            allProducts.value = data;
            isLoading.value = false;
          },
          onError: (error) {
            debugPrint('Error fetching products by category: $error');
            isLoading.value = false;
          },
        );
  }

  Future<void> refreshProducts() async {
    if (selectedCategorySlug.value.isEmpty) return;
    try {
      final fresh = await _db.productsDao.getProductsByCategory(
        selectedCategorySlug.value,
        altCategory: selectedCategoryName.value,
      );
      allProducts.value = fresh;
    } catch (e) {
      debugPrint('Error refreshing products: $e');
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  void setSortOption(ProductSortOption option) {
    selectedSort.value = option;
  }

  List<ProductsTableData> get filteredProducts {
    var list = allProducts.toList();
    final query = searchQuery.value.trim().toLowerCase();

    if (query.isNotEmpty) {
      list = list.where((p) {
        final title = p.title.toLowerCase();
        final brand = (p.brand ?? '').toLowerCase();
        final category = p.category.toLowerCase();
        final description = p.description.toLowerCase();
        return title.contains(query) ||
            brand.contains(query) ||
            category.contains(query) ||
            description.contains(query);
      }).toList();
    }

    switch (selectedSort.value) {
      case ProductSortOption.priceAsc:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSortOption.priceDesc:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSortOption.ratingDesc:
        list.sort((a, b) => (b.rating ?? 0.0).compareTo(a.rating ?? 0.0));
        break;
      case ProductSortOption.ratingAsc:
        list.sort((a, b) => (a.rating ?? 0.0).compareTo(b.rating ?? 0.0));
        break;
      case ProductSortOption.none:
        break;
    }

    return list;
  }

  bool get hasSearchQuery => searchQuery.value.trim().isNotEmpty;

  @override
  void onClose() {
    _productsSubscription?.cancel();
    _categoriesSubscription?.cancel();
    super.onClose();
  }
}
