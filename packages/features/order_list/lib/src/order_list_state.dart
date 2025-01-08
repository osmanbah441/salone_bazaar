part of 'order_list_bloc.dart';

final class OrderListState extends Equatable {
  const OrderListState({
    this.itemList,
    this.nextPage,
    this.filter,
    this.error,
    this.refreshError,
    this.userRole = UserRole.customer,
  });

  final List<Orders>? itemList;
  final int? nextPage;
  final OrderListFilter? filter;
  final dynamic error;
  final dynamic refreshError;
  final UserRole userRole;

  const OrderListState.noItemsFound(OrderListFilter? filter)
      : this(
          itemList: const [],
          nextPage: 1,
          filter: filter,
          error: null,
        );

  const OrderListState.success({
    required int? nextPage,
    required List<Orders> itemList,
    required OrderListFilter? filter,
    required bool isRefresh,
    required UserRole userRole,
  }) : this(
            nextPage: nextPage,
            itemList: itemList,
            filter: filter,
            userRole: userRole);

  OrderListState.loadingNewTag(OrderStatus? status)
      : this(
          filter: status != null ? OrderListFilterByStatus(status) : null,
        );

  OrderListState copyWithNewError(
    dynamic error,
  ) =>
      OrderListState(
        itemList: itemList,
        nextPage: nextPage,
        error: error,
        filter: filter,
        userRole: userRole,
        refreshError: null,
      );

  OrderListState copyWithNewRefreshError(
    dynamic refreshError,
  ) =>
      OrderListState(
        itemList: itemList,
        nextPage: nextPage,
        error: error,
        filter: filter,
        userRole: userRole,
        refreshError: refreshError,
      );

  OrderListState copyWithUpdatedOrder(
    Orders updatedOrder,
  ) {
    return OrderListState(
      itemList: itemList?.map((order) {
        if (order.id == updatedOrder.id) {
          return updatedOrder;
        } else {
          return order;
        }
      }).toList(),
      nextPage: nextPage,
      error: error,
      filter: filter,
      userRole: userRole,
      refreshError: null,
    );
  }

  @override
  List<Object?> get props => [
        itemList,
        nextPage,
        filter,
        error,
        refreshError,
      ];
}

abstract base class OrderListFilter extends Equatable {
  const OrderListFilter();

  @override
  List<Object?> get props => [];
}

final class OrderListFilterByStatus extends OrderListFilter {
  const OrderListFilterByStatus(this.status);

  final OrderStatus status;

  @override
  List<Object?> get props => [status];
}

// add more filter which extends [OrderListFilter]
