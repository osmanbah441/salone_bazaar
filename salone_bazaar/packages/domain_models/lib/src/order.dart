import 'package:intl/intl.dart';

enum OrderStatus {
  pending,
  ongoing,
  completed;

  static OrderStatus _getStatus(String status) {
    switch (status) {
      case 'pending':
        return OrderStatus.pending;

      case 'ongoing':
        return OrderStatus.ongoing;

      case 'completed':
        return OrderStatus.completed;

      default:
        throw ('unknown order status');
    }
  }
}

class OrdersItem {
  final String productId;
  final String name;
  final String imageUrl;
  final double unitPrice;
  final int quantity;

  const OrdersItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
    double totalPrice = 0.0,
  });

  double get totalPrice => unitPrice * quantity;

  // Convert an OrdersItem into a Map
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'imageUrl': imageUrl,
    };
  }

  // Create an OrdersItem from a Map
  factory OrdersItem.fromMap(Map<String, dynamic> map) {
    return OrdersItem(
      productId: map['productId'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      unitPrice: map['unitPrice'],
      quantity: map['quantity'],
      totalPrice: map['totalPrice'],
    );
  }
}

class Orders {
  final String id;
  final String userId;
  final OrderStatus status;
  final List<OrdersItem> items;
  final DateTime date;
  final String? deliveryCrewId;

  const Orders({
    required this.id,
    required this.userId,
    this.status = OrderStatus.pending,
    required this.items,
    required this.date,
    this.deliveryCrewId,
    double total = 0.0,
  });

  double get total => items.fold(0.0, (total, item) => total + item.totalPrice);

  String get getFormattedDate => DateFormat('d MMM y').format(date);

  Map<String, dynamic> toMap() {
    return {
      'orderId': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'date': date.toIso8601String(),
      'status': status.name,
      'deliveryCrewId': deliveryCrewId,
    };
  }

  // Create an Orders from a Map
  factory Orders.fromMap(Map<String, dynamic> map) {
    final orderItems = List<OrdersItem>.from(
      map['items'].map((item) => OrdersItem.fromMap(item)),
    );
    return Orders(
        id: map['orderId'],
        userId: map['userId'],
        items: orderItems,
        date: DateTime.parse(map['date']),
        total: map['total'],
        status: OrderStatus._getStatus(map['status']),
        deliveryCrewId: map['deliveryCrewId']);
  }
}

class OrderListPage {
  const OrderListPage({
    required this.isLastPage,
    required this.orderList,
  });

  final bool isLastPage;
  final List<Orders> orderList;
}
