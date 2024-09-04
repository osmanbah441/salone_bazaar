class Cart {
  final String cartId;
  final String userId;
  List<CartItem> items;
  double totalCartPrice;

  Cart({
    required this.cartId,
    required this.userId,
    required this.items,
    required this.totalCartPrice,
  });
}

class CartItem {
  final String productId;
  final String name;
  final double unitPrice;
  int quantity;

  final String imageUrl;

  CartItem({
    required this.productId,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.imageUrl,
  });

  double get totalPrice => unitPrice * quantity;
}
