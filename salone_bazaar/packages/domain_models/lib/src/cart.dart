class CartItem {
  final String productId;
  final String name;
  final String imageUrl;
  final double unitPrice;
  int quantity;

  CartItem(
      {required this.productId,
      required this.name,
      required this.unitPrice,
      required this.quantity,
      required this.imageUrl,
      double totalPrice = 0.0});

  double get totalPrice => unitPrice * quantity;

  // Convert a CartItemTester into a Map
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }

  // Create a CartItemTester from a Map
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      unitPrice: map['unitPrice'],
      quantity: map['quantity'],
      totalPrice: map['totalPrice'],
    );
  }
}

class Cart {
  final String cartId;
  final String userId;
  final List<CartItem> items;

  Cart({
    required this.cartId,
    required this.userId,
    required this.items,
    double totalCartPrice = 0.0,
  });

  double get totalCartPrice =>
      items.fold(0.0, (total, item) => total + item.totalPrice);

  // Convert a Cart into a Map
  Map<String, dynamic> toMap() {
    return {
      'cartId': cartId,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalCartPrice': totalCartPrice,
    };
  }

  // Create a Cart from a Map
  factory Cart.fromMap(Map<String, dynamic> map) {
    final cartItems = List<CartItem>.from(map['items'].map(
      (item) => CartItem.fromMap(item),
    ));

    return Cart(
      cartId: map['cartId'],
      userId: map['userId'],
      items: cartItems,
      totalCartPrice: map['totalCartPrice'],
    );
  }
}
