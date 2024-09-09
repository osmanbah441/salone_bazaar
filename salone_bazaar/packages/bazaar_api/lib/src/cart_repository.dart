import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain_models/domain_models.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartRepository {
  const CartRepository();

  static final _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  static final _ref =
      FirebaseFirestore.instance.collection('carts').doc(_currentUserId);

  Future<void> updateQuantity(String productId, int quantity) async {
    final cartDoc = await _ref.get();
    if (cartDoc.exists) {
      Cart cart = Cart.fromMap(cartDoc.data()!);

      for (var item in cart.items) {
        if (item.productId == productId) {
          item.quantity = quantity;
        }
      }

      await _ref.update(cart.toMap());
    }
  }

  Future<void> removeItemFromCart(String productId) async {
    final cartDoc = await _ref.get();
    if (cartDoc.exists) {
      Cart cart = Cart.fromMap(cartDoc.data()!);

      cart.items.removeWhere((item) => item.productId == productId);

      await _ref.update(cart.toMap());
    }
  }

  Future<void> clearCart() async {
    final cartDoc = await _ref.get();
    if (cartDoc.exists) {
      // Clear the cart items and set the total cart price to 0
      await _ref.update({
        'items': [],
        'totalCartPrice': 0,
      });
    }
  }

  Future<Cart> get() async {
    final cartDoc = await _ref.get();

    if (cartDoc.exists) {
      return Cart.fromMap(cartDoc.data()!);
    } else {
      return Cart(cartId: _currentUserId, userId: _currentUserId, items: []);
    }
  }

  Future<void> add(Product product) async {
    final cartItem = CartItem(
      productId: product.id!,
      name: product.name,
      unitPrice: product.price,
      quantity: 1,
      imageUrl: product.imageUrl,
    );
    final cartDoc = await _ref.get();
    Cart cart;

    if (cartDoc.exists) {
      cart = Cart.fromMap(cartDoc.data()!);

      for (var item in cart.items) {
        if (item.productId == cartItem.productId) return;
      }

      cart.items.add(cartItem);
    } else {
      cart = Cart(
        cartId: _currentUserId,
        userId: _currentUserId,
        items: [cartItem],
      );
    }

    await _ref.set(cart.toMap());
  }
}
