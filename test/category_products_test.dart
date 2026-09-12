import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:offline_cart/controllers/category_products_controller.dart';
import 'package:offline_cart/data/database/app_database.dart';
import 'package:offline_cart/screens/products/widgets/product_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/path_provider'),
        (MethodCall methodCall) async => '.',
      );

  group('CategoryProductsController Logic Tests', () {
    late CategoryProductsController controller;

    setUp(() {
      Get.testMode = true;
      controller = CategoryProductsController(
        initialSlug: 'beauty',
        initialName: 'Beauty',
      );

      // Populate mock products into allProducts observable
      controller.allProducts.value = [
        const ProductsTableData(
          id: 1,
          title: 'Essence Mascara Lash Princess',
          description: 'A lash mascara with curling effect',
          category: 'beauty',
          price: 9.99,
          discountPercentage: 7.17,
          rating: 4.94,
          stock: 5,
          brand: 'Essence',
          thumbnail: 'https://example.com/mascara.png',
          images: ['https://example.com/mascara1.png'],
        ),
        const ProductsTableData(
          id: 2,
          title: 'Eyeshadow Palette with Mirror',
          description: 'A colorful palette of eyeshadows',
          category: 'beauty',
          price: 19.99,
          discountPercentage: 5.5,
          rating: 3.28,
          stock: 44,
          brand: 'Glamour Beauty',
          thumbnail: 'https://example.com/palette.png',
          images: ['https://example.com/palette1.png'],
        ),
        const ProductsTableData(
          id: 3,
          title: 'Powder Canister Matte Finish',
          description: 'Long-lasting translucent loose powder',
          category: 'beauty',
          price: 14.99,
          discountPercentage: 10.0,
          rating: 4.5,
          stock: 12,
          brand: 'Velvet Touch',
          thumbnail: 'https://example.com/powder.png',
          images: ['https://example.com/powder1.png'],
        ),
      ];
    });

    tearDown(() {
      Get.reset();
    });

    test('Initial filteredProducts contains all items', () {
      expect(controller.filteredProducts.length, 3);
    });

    test('Search filter matches title, brand, or description', () {
      controller.setSearchQuery('mascara');
      expect(controller.filteredProducts.length, 1);
      expect(
        controller.filteredProducts.first.title,
        'Essence Mascara Lash Princess',
      );

      controller.setSearchQuery('Velvet');
      expect(controller.filteredProducts.length, 1);
      expect(controller.filteredProducts.first.brand, 'Velvet Touch');

      controller.setSearchQuery('non-existent');
      expect(controller.filteredProducts.isEmpty, true);

      controller.clearSearch();
      expect(controller.filteredProducts.length, 3);
    });

    test('Sort by Price: Low to High and High to Low', () {
      controller.setSortOption(ProductSortOption.priceAsc);
      final ascList = controller.filteredProducts;
      expect(ascList.first.price, 9.99);
      expect(ascList.last.price, 19.99);

      controller.setSortOption(ProductSortOption.priceDesc);
      final descList = controller.filteredProducts;
      expect(descList.first.price, 19.99);
      expect(descList.last.price, 9.99);
    });

    test('Sort by Rating: High to Low and Low to High', () {
      controller.setSortOption(ProductSortOption.ratingDesc);
      final highRatingList = controller.filteredProducts;
      expect(highRatingList.first.rating, 4.94);
      expect(highRatingList.last.rating, 3.28);

      controller.setSortOption(ProductSortOption.ratingAsc);
      final lowRatingList = controller.filteredProducts;
      expect(lowRatingList.first.rating, 3.28);
      expect(lowRatingList.last.rating, 4.94);
    });

    test('selectCategory updates selected category slug and name', () {
      controller.selectCategory('fragrances', 'Fragrances');
      expect(controller.selectedCategorySlug.value, 'fragrances');
      expect(controller.selectedCategoryName.value, 'Fragrances');
    });
  });

  group('ProductCard Widget Display Tests', () {
    testWidgets(
      'renders all required fields: Image, Name, Brand, Category, Price, Rating, Discount %, Stock',
      (tester) async {
        const testProduct = ProductsTableData(
          id: 10,
          title: 'Calvin Klein CK One',
          description: 'Classic unisex eau de toilette perfume',
          category: 'fragrances',
          price: 49.99,
          discountPercentage: 15.0,
          rating: 4.85,
          stock: 8,
          brand: 'Calvin Klein',
          thumbnail: 'https://example.com/ck.png',
          images: ['https://example.com/ck.png'],
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: ProductCard(product: testProduct)),
          ),
        );

        // Verify Product Name
        expect(find.text('Calvin Klein CK One'), findsOneWidget);

        // Verify Brand
        expect(find.text('CALVIN KLEIN'), findsOneWidget);

        // Verify Category
        expect(find.text('fragrances'), findsOneWidget);

        // Verify Price
        expect(find.text('\$49.99'), findsOneWidget);

        // Verify Rating
        expect(find.text('4.8'), findsOneWidget);

        // Verify Discount %
        expect(find.text('-15%'), findsOneWidget);

        // Verify Stock badge
        expect(find.text('Only 8 left'), findsOneWidget);
      },
    );

    testWidgets('Category chips highlight selected category with blue color', (
      tester,
    ) async {
      final testController = CategoryProductsController(
        initialSlug: 'beauty',
        initialName: 'Beauty',
      );
      Get.put(testController);

      testController.categories.value = const [
        CategoriesTabelData(slug: 'beauty', name: 'Beauty', url: ''),
        CategoriesTabelData(slug: 'fragrances', name: 'Fragrances', url: ''),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Obx(() {
              final categories = testController.categories;
              return SizedBox(
                height: 38,
                child: ListView.separated(
                  key: ValueKey(
                    'chips_${testController.selectedCategorySlug.value}',
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return Obx(() {
                      final isSelected =
                          cat.slug.toLowerCase() ==
                          testController.selectedCategorySlug.value
                              .toLowerCase();
                      return InkWell(
                        key: ValueKey(cat.slug),
                        onTap: () =>
                            testController.selectCategory(cat.slug, cat.name),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF2563EB)
                                : Colors.white,
                          ),
                          child: Text(cat.name),
                        ),
                      );
                    });
                  },
                ),
              );
            }),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find AnimatedContainer for Beauty and Fragrances
      AnimatedContainer getContainer(String slug) {
        final inkWell = find.byKey(ValueKey(slug));
        return tester.widget<AnimatedContainer>(
          find.descendant(
            of: inkWell,
            matching: find.byType(AnimatedContainer),
          ),
        );
      }

      // Initially Beauty is selected (blue), Fragrances is unselected (white)
      var beautyContainer = getContainer('beauty');
      var fragrancesContainer = getContainer('fragrances');
      expect(
        (beautyContainer.decoration as BoxDecoration).color,
        const Color(0xFF2563EB),
      );
      expect(
        (fragrancesContainer.decoration as BoxDecoration).color,
        Colors.white,
      );

      // Tap Fragrances chip
      await tester.tap(find.byKey(const ValueKey('fragrances')));
      await tester.pumpAndSettle();

      // Now Fragrances is selected (blue), Beauty is unselected (white)
      beautyContainer = getContainer('beauty');
      fragrancesContainer = getContainer('fragrances');
      expect((beautyContainer.decoration as BoxDecoration).color, Colors.white);
      expect(
        (fragrancesContainer.decoration as BoxDecoration).color,
        const Color(0xFF2563EB),
      );
    });
  });
}
