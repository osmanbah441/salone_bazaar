import 'package:domain_models/domain_models.dart';

class CartRepository {
  const CartRepository();
  static final _cart = Cart(
    cartId: 'cart_1',
    userId: 'user_1',
    items: [],
    totalCartPrice: 0.0,
  );

  Future<void> add(Product product) async {
    final item = CartItem(
        imageUrl: product.imageUrl,
        name: product.name,
        productId: product.id,
        quantity: 1,
        unitPrice: product.price);

    // Check if the item already exists in the cart
    for (var item in _cart.items) {
      if (item.productId == product.id) {
        return; // Item already in the cart, no need to add again
      }
    }

    // Add the new item to the cart
    _cart.items.add(item);

    // Update the total cart price
    _updateTotalCartPrice();
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    for (var item in _cart.items) {
      if (item.productId == productId) {
        item.quantity = quantity;
        _updateTotalCartPrice();
        return;
      }
    }
  }

  Future<void> removeItemFromCart(String productId) async {
    _cart.items.removeWhere((item) => item.productId == productId);
    _updateTotalCartPrice();
  }

  Future<void> clearCart() async {
    _cart.items.clear();
    _updateTotalCartPrice();
  }

  Future<Cart> get() async {
    return _cart;
  }

  void _updateTotalCartPrice() {
    _cart.totalCartPrice = _cart.items.fold(
      0.0,
      (total, item) => total + item.totalPrice,
    );
  }
}
