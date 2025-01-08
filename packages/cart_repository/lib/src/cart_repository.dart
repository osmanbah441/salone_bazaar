import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain_models/domain_models.dart';

class CartRepository {
  const CartRepository();
  static final _cartRef = FirebaseFirestore.instance.collection('carts');

  Future<void> updateCartProductQuantity({
    required String uid,
    required String productId,
    required int quantity,
  }) async {
    final cartDoc = await _cartRef.doc(uid).get();
    if (cartDoc.exists) {
      Cart cart = Cart.fromMap(cartDoc.data()!);

      for (var item in cart.items) {
        if (item.productId == productId) {
          item.quantity = quantity;
        }
      }

      await _cartRef.doc(uid).update(cart.toMap());
    }
  }

  Future<void> removeProductFromCart({
    required String productId,
    required String uid,
  }) async {
    final cartDoc = await _cartRef.doc(uid).get();
    if (cartDoc.exists) {
      Cart cart = Cart.fromMap(cartDoc.data()!);

      cart.items.removeWhere((item) => item.productId == productId);

      await _cartRef.doc(uid).update(cart.toMap());
    }
  }

  Future<void> removeAllProductFromCart(String uid) async {
    final cartDoc = await _cartRef.doc(uid).get();
    if (cartDoc.exists) {
      // Clear the cart items and set the total cart price to 0
      await _cartRef.doc(uid).update({
        'items': [],
        'totalCartPrice': 0,
      });
    }
  }

  Future<Cart> getAllCartProduct(String uid) async {
    final cartDoc = await _cartRef.doc(uid).get();

    if (cartDoc.exists) {
      return Cart.fromMap(cartDoc.data()!);
    } else {
      return Cart(cartId: uid, userId: uid, items: []);
    }
  }

  Future<void> addProductToCart(
      {required String uid, required Product product}) async {
    try {
      final cartItem = CartItem(
        productId: product.id!,
        name: product.name,
        unitPrice: product.price,
        quantity: 1,
        imageUrl: product.imageUrl,
      );
      final cartDoc = await _cartRef.doc().get();
      Cart cart;

      if (cartDoc.exists) {
        cart = Cart.fromMap(cartDoc.data()!);

        for (var item in cart.items) {
          if (item.productId == cartItem.productId) return;
        }

        cart.items.add(cartItem);
      } else {
        cart = Cart(
          cartId: uid,
          userId: uid,
          items: [cartItem],
        );
      }

      await _cartRef.doc(uid).set(cart.toMap());
    } catch (e) {
      rethrow;
    }
  }
}
