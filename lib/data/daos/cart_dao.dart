import 'package:drift/drift.dart';
import 'package:offline_cart/data/database/app_database.dart';
import 'package:offline_cart/data/tables/cart_table.dart';

part 'cart_dao.g.dart';

@DriftAccessor(tables: [CartTable])
class CartDao extends DatabaseAccessor<AppDatabase> with _$CartDaoMixin {
  CartDao(super.db);

  Future<void> addToCart(int productId, {int quantity = 1}) async {
    final existing = await (select(
      cartTable,
    )..where((t) => t.productId.equals(productId))).getSingleOrNull();
    if (existing != null) {
      await (update(
        cartTable,
      )..where((t) => t.productId.equals(productId))).write(
        CartTableCompanion(quantity: Value(existing.quantity + quantity)),
      );
    } else {
      await into(cartTable).insert(
        CartTableCompanion.insert(
          productId: Value(productId),
          quantity: quantity,
        ),
      );
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
    } else {
      await (update(cartTable)..where((t) => t.productId.equals(productId)))
          .write(CartTableCompanion(quantity: Value(quantity)));
    }
  }

  Future<int> removeFromCart(int productId) {
    return (delete(
      cartTable,
    )..where((t) => t.productId.equals(productId))).go();
  }

  Future<CartTableData?> getCartItem(int productId) {
    return (select(
      cartTable,
    )..where((t) => t.productId.equals(productId))).getSingleOrNull();
  }

  Stream<CartTableData?> watchCartItem(int productId) {
    return (select(
      cartTable,
    )..where((t) => t.productId.equals(productId))).watchSingleOrNull();
  }

  Stream<bool> watchIsProductInCart(int productId) {
    return watchCartItem(productId).map((item) => item != null);
  }

  Future<List<CartTableData>> getAllCartItems() {
    return select(cartTable).get();
  }

  Stream<List<CartTableData>> watchAllCartItems() {
    return select(cartTable).watch();
  }

  Stream<List<CartItemWithProduct>> watchCartWithProducts() {
    final query = select(cartTable).join([
      innerJoin(
        db.productsTable,
        db.productsTable.id.equalsExp(cartTable.productId),
      ),
    ]);
    return query.watch().map(
      (rows) => rows
          .map(
            (r) => CartItemWithProduct(
              cartItem: r.readTable(cartTable),
              product: r.readTable(db.productsTable),
            ),
          )
          .toList(),
    );
  }

  Future<List<CartItemWithProduct>> getCartWithProducts() {
    final query = select(cartTable).join([
      innerJoin(
        db.productsTable,
        db.productsTable.id.equalsExp(cartTable.productId),
      ),
    ]);
    return query.get().then(
      (rows) => rows
          .map(
            (r) => CartItemWithProduct(
              cartItem: r.readTable(cartTable),
              product: r.readTable(db.productsTable),
            ),
          )
          .toList(),
    );
  }

  Future<int> clearCart() {
    return delete(cartTable).go();
  }
}

class CartItemWithProduct {
  final CartTableData cartItem;
  final ProductsTableData product;

  CartItemWithProduct({required this.cartItem, required this.product});
}
