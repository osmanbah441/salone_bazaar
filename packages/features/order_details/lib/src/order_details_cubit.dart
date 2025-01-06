import 'package:domain_models/domain_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bazaar_api/bazaar_api.dart';
import 'package:user_repository/user_repository.dart';

part 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailState> {
  OrderDetailsCubit(
      {required this.orderId, required this.api, required this.userRepository})
      : super(const OrderDetailsInProgress()) {
    _fetchOrder();
  }

  final String orderId;
  final BazaarApi api;
  final UserRepository userRepository;

  void _fetchOrder() async {
    try {
      final order = await api.order.get(orderId);
      emit(
        OrderDetailsSuccess(
            order: order, userRole: await userRepository.getUserRole()),
      );
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
