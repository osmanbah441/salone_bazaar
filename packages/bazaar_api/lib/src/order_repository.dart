import 'package:bazaar_api/src/auth_service.dart';
import 'package:bazaar_api/src/cart_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain_models/domain_models.dart' as domain;

class OrdersRepository {
  const OrdersRepository();
  static final _ordersRef = FirebaseFirestore.instance.collection('orders');

  Future<void> create(double lat, double long) async {
    final cart = await const CartRepository().get();
    final currentUser = const AuthService().currentUser!;

    final orderItems = cart.items
        .map(
          (e) => domain.OrderItem(
            productId: e.productId,
            name: e.name,
            imageUrl: e.imageUrl,
            unitPrice: e.unitPrice,
            quantity: e.quantity,
          ),
        )
        .toList();

    final doc = _ordersRef.doc();
    domain.Order newOrders = domain.Order(
      id: doc.id,
      userId: currentUser.uid,
      items: orderItems,
      date: DateTime.now(),
      latitude: lat,
      longitude: long,
    );
    await doc.set(newOrders.toMap());

    await const CartRepository().clearCart();
  }

  Future<domain.OrderListPage> getAll({
    String status = '',
  }) async {
    final uid = const AuthService().currentUser!.uid;
    final role = await const AuthService().getUserRole();
    role == domain.UserRole.deliveryCrew;

    Query query = role == domain.UserRole.admin
        ? _ordersRef
        : role == domain.UserRole.deliveryCrew
            ? _ordersRef.where('deliveryCrewId', isEqualTo: uid)
            : _ordersRef.where('userId', isEqualTo: uid);

    if (status.isNotEmpty) {
      query = query.where('status', isEqualTo: status);
    }

    final snapshot = await query.get() as QuerySnapshot<Map<String, dynamic>>;

    if (snapshot.docs.isEmpty) {
      return const domain.OrderListPage(isLastPage: true, orderList: []);
    }
    final orders =
        snapshot.docs.map((doc) => domain.Order.fromMap(doc.data())).toList();
    return domain.OrderListPage(isLastPage: true, orderList: orders);
  }

  Future<domain.Order> get(String orderId) async {
    final orderDoc = await _ordersRef.doc(orderId).get();
    if (orderDoc.exists) return domain.Order.fromMap(orderDoc.data()!);
    throw const domain.NotFoundResultException();
  }

  Future<domain.Order> updateStatus(
    String orderId,
    domain.OrderStatus status,
  ) async {
    await _ordersRef.doc(orderId).update({"status": status.name});
    return get(orderId);
  }

  Future<domain.Order> assignToDeliveryCrew({
    required String orderId,
    required String crewId,
  }) async {
    await _ordersRef.doc(orderId).update({
      "deliveryCrewId": crewId,
      "status": domain.OrderStatus.ongoing,
    });

    return get(orderId);
  }
}
