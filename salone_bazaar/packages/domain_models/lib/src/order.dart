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

class OrderItem {
  final String productId;
  final String name;
  final String imageUrl;
  final double unitPrice;
  final int quantity;

  const OrderItem({
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
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      unitPrice: map['unitPrice'],
      quantity: map['quantity'],
      totalPrice: map['totalPrice'],
    );
  }
}

class Order {
  final String id;
  final String userId;
  final OrderStatus status;
  final List<OrderItem> items;
  final DateTime date;
  final String? deliveryCrewId;
  final double? latitude;
  final double? longitude;

  const Order({
    required this.id,
    required this.userId,
    this.status = OrderStatus.pending,
    required this.items,
    required this.date,
    this.deliveryCrewId,
    this.latitude,
    this.longitude,
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
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Create an Orders from a Map
  factory Order.fromMap(Map<String, dynamic> map) {
    final orderItems = List<OrderItem>.from(
      map['items'].map((item) => OrderItem.fromMap(item)),
    );
    return Order(
        id: map['orderId'],
        userId: map['userId'],
        items: orderItems,
        date: DateTime.parse(map['date']),
        total: map['total'],
        status: OrderStatus._getStatus(map['status']),
        deliveryCrewId: map['deliveryCrewId'],
        latitude: map['latitude'],
        longitude: map['longitude']);
  }
}

class OrderListPage {
  const OrderListPage({
    required this.isLastPage,
    required this.orderList,
  });

  final bool isLastPage;
  final List<Order> orderList;
}
