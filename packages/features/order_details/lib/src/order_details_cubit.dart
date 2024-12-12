import 'package:domain_models/domain_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bazaar_api/bazaar_api.dart';

part 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailState> {
  OrderDetailsCubit({
    required this.orderId,
    required this.api,
  }) : super(const OrderDetailsInProgress()) {
    _fetchOrder();
  }

  final String orderId;
  final BazaarApi api;

  void _fetchOrder() async {
    try {
      final [role, order] =
          await Future.wait([api.auth.getUserRole(), api.order.get(orderId)]);
      emit(OrderDetailsSuccess(
          order: order as Order, userRole: role as UserRole));
    } catch (e) {
      emit(const OrderDetailsFailure());
    }
  }

  // update the status to 1 to complete the order
  void updateOrderStatusToCompleted() async {
    final isSucessState = state is OrderDetailsSuccess;
    if (isSucessState) {
      try {
        final previousState = state as OrderDetailsSuccess;
        final newOrder = await api.order.updateStatus(
          orderId,
          OrderStatus.completed,
        );
        emit(previousState.copyWith(order: newOrder));
      } catch (e) {
        emit(const OrderDetailsFailure());
      }
    }
  }

  void assignDeliveryCrew(String userId) async {
    final isSucessState = state is OrderDetailsSuccess;
    if (isSucessState) {
      try {
        final previousState = state as OrderDetailsSuccess;
        final newOrder = await api.order.assignToDeliveryCrew(
          orderId: orderId,
          crewId: userId,
        );
        emit(previousState.copyWith(order: newOrder));
      } catch (e) {
        emit(const OrderDetailsFailure());
      }
    }
  }
}
