import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain_models/domain_models.dart';

class OrdersRepository {
  const OrdersRepository();
  static final _ordersRef = FirebaseFirestore.instance.collection('orders');

  Future<void> create(double lat, double long, String uid, Cart cart) async {
    final orderItems = cart.items
        .map(
          (e) => OrderItem(
            productId: e.productId,
            name: e.name,
            imageUrl: e.imageUrl,
            unitPrice: e.unitPrice,
            quantity: e.quantity,
          ),
        )
        .toList();

    final doc = _ordersRef.doc();
    Orders newOrders = Orders(
      id: doc.id,
      userId: uid,
      items: orderItems,
      date: DateTime.now(),
      latitude: lat,
      longitude: long,
    );
    await doc.set(newOrders.toMap());
  }

  Future<OrderListPage> getAllOrders({
    String status = '',
    UserRole role = UserRole.customer,
    required String uid,
  }) async {
    Query query = role == UserRole.admin
        ? _ordersRef
        : role == UserRole.deliveryCrew
            ? _ordersRef.where('deliveryCrewId', isEqualTo: uid)
            : _ordersRef.where('userId', isEqualTo: uid);

    if (status.isNotEmpty) {
      query = query.where('status', isEqualTo: status);
    }

    final snapshot = await query.get() as QuerySnapshot<Map<String, dynamic>>;

    if (snapshot.docs.isEmpty) {
      return const OrderListPage(isLastPage: true, orderList: []);
    }
    final orders =
        snapshot.docs.map((doc) => Orders.fromMap(doc.data())).toList();
    return OrderListPage(isLastPage: true, orderList: orders);
  }

  Future<Orders> getSingleOrder(String orderId) async {
    final orderDoc = await _ordersRef.doc(orderId).get();
    if (orderDoc.exists) return Orders.fromMap(orderDoc.data()!);
    throw const NotFoundResultException();
  }

  Future<Orders> updateOrderStatus(
    String orderId,
    OrderStatus status,
  ) async {
    await _ordersRef.doc(orderId).update({"status": status.name});
    return getSingleOrder(orderId);
  }

  Future<Orders> assignOrderToDeliveryCrew({
    required String orderId,
    required String crewId,
  }) async {
    await _ordersRef.doc(orderId).update({
      "deliveryCrewId": crewId,
      "status": OrderStatus.ongoing,
    });

    return getSingleOrder(orderId);
  }
}
