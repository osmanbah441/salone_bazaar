part of 'order_details_cubit.dart';

sealed class OrderDetailState {
  const OrderDetailState();
}

class OrderDetailsSuccess extends OrderDetailState {
  final Order order;
  final UserRole userRole;

  const OrderDetailsSuccess({
    required this.order,
    required this.userRole,
  });

  OrderDetailsSuccess copyWith({
    UserRole? userRole,
    Order? order,
  }) =>
      OrderDetailsSuccess(
        order: order ?? this.order,
        userRole: userRole ?? this.userRole,
      );
}

class OrderDetailsInProgress extends OrderDetailState {
  const OrderDetailsInProgress();
}

class OrderDetailsFailure extends OrderDetailState {
  const OrderDetailsFailure();
}
