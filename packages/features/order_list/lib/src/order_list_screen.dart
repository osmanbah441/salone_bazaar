import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:order_repository/order_repository.dart';
import 'package:user_repository/user_repository.dart';

import 'horizontal_list_filter.dart';
import 'order_list_bloc.dart';
import 'order_page_list_view.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({
    super.key,
    required this.onOrderSelected,
    required this.ordersRepository,
    required this.userRepository,
  });

  final void Function(String id) onOrderSelected;
  final OrdersRepository ordersRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderListBloc>(
        create: (_) => OrderListBloc(
              ordersRepository: ordersRepository,
              userRepository: userRepository,
            ),
        child: OrderListView(
          onOrderSelected: onOrderSelected,
        ));
  }
}

@visibleForTesting
class OrderListView extends StatefulWidget {
  const OrderListView({
    super.key,
    required this.onOrderSelected,
  });

  final void Function(String) onOrderSelected;

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  final _pagingController = PagingController<int, Orders>(
    firstPageKey: 1,
  );

  OrderListBloc get _bloc => context.read<OrderListBloc>();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageNumber) {
      if (pageNumber > 1) _bloc.add(OrderListNextPageRequested(pageNumber));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderListBloc, OrderListState>(
      listener: (context, state) {
        if (state.refreshError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('refresh errror text message')),
          );
        }

        _pagingController.value = state.toPagingState();
      },
      builder: (context, state) {
        final title = state.userRole.isAdmin
            ? "Manage Orders"
            : state.userRole.isDeliveryCrew
                ? "Assigned Orders"
                : "Orders History";
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Text(title),
            ),
            body: Column(
              children: [
                const FilterHorizontalList(),
                Expanded(
                  child: RefreshIndicator(
                      onRefresh: () {
                        _bloc.add(const OrderListRefreshed());

                        final stateChangeFuture = _bloc.stream.first;
                        return stateChangeFuture;
                      },
                      child: OrderPageListView(
                        pagingController: _pagingController,
                        onOrderSelected: widget.onOrderSelected,
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

extension on OrderListState {
  PagingState<int, Orders> toPagingState() {
    return PagingState(
      itemList: itemList,
      nextPageKey: nextPage,
      error: error,
    );
  }
}
