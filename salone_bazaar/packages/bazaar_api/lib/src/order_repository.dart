import 'package:bazaar_api/src/auth_service.dart';
import 'package:bazaar_api/src/cart_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain_models/domain_models.dart';

class OrdersRepository {
  const OrdersRepository();
  static final _ordersRef = FirebaseFirestore.instance.collection('orders');

  static get _uid => AuthService().currentUser!.uid;

  Future<void> create() async {
    final cart = await CartRepository().get();
    final currentUser = AuthService().currentUser!;

    final orderItems = cart.items
        .map(
          (e) => OrdersItem(
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
      userId: currentUser.uid,
      items: orderItems,
      date: DateTime.now(),
    );
    await doc.set(newOrders.toMap());

    await CartRepository().clearCart();
  }

  Future<OrderListPage> getOrderssForUser({
    String status = '',
  }) async {
    Query query = _ordersRef.where('userId', isEqualTo: _uid);

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

  Future<Orders> getOrders(String orderId) async {
    final orderDoc = await _ordersRef.doc(orderId).get();
    if (orderDoc.exists) return Orders.fromMap(orderDoc.data()!);
    throw const NotFoundResultException();
  }

  Future<Orders> updateOrdersStatus(String orderId, OrderStatus status) async =>
      _updateOrders(orderId, status: status);

  Future<Orders> assignOrdersToDeliveryCrew({
    required String orderId,
    required String crewId,
  }) =>
      _updateOrders(orderId, crewId: crewId, status: OrderStatus.pending);

  Future<Orders> _updateOrders(
    String orderId, {
    required OrderStatus status,
    String? crewId,
  }) async {
    final newOrders = await getOrders(orderId).then((order) => Orders(
          status: status,
          deliveryCrewId: crewId,
          total: order.total,
          id: order.id,
          userId: order.userId,
          items: order.items,
          date: order.date,
        ));

    await _ordersRef.doc(orderId).update(newOrders.toMap());

    return getOrders(orderId);
  }
}
