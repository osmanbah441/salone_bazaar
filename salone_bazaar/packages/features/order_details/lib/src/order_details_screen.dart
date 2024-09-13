import 'package:bazaar_api/bazaar_api.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:component_library/component_library.dart';

import 'order_details_cubit.dart';
import 'update_order_dialog.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({
    super.key,
    required this.onBackButtonTap,
    required this.orderId,
    required this.api,
  });

  final String orderId;
  final BazaarApi api;

  final VoidCallback onBackButtonTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderDetailsCubit>(
      create: (context) => OrderDetailsCubit(
        orderId: orderId,
        api: api,
      ),
      child: OrderDetailsView(
        onBackButtonTap: onBackButtonTap,
      ),
    );
  }
}

@visibleForTesting
class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({
    super.key,
    required this.onBackButtonTap,
  });

  final VoidCallback onBackButtonTap;

  void _showEditDialog(BuildContext context, OrderDetailsSuccess state) {
    final cubit = context.read<OrderDetailsCubit>();
    showDialog(
      context: context,
      builder: (context) => state.userRole.isAdmin
          ? AssignOrderToDeliveryCrewDialog(
              deliveryUsers: const [],
              onAssigned: cubit.assignDeliveryCrew,
            )
          : UpdateOrderToCompletedDialog(
              alreadyUpdated: state.order.status == OrderStatus.completed,
              onUpdate: cubit.updateOrderStatusToCompleted,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsCubit, OrderDetailState>(
      builder: (context, state) {
        return Scaffold(
          appBar: state is OrderDetailsSuccess
              ? AppBar(
                  centerTitle: true,
                  title: Text('order ${state.order.status.name}'),
                  leading: BackButton(onPressed: onBackButtonTap),
                  actions: state.userRole.isAdminOrDeliveryCrew
                      ? [
                          IconButton(
                            onPressed: () => _showEditDialog(context, state),
                            icon: const Icon(Icons.edit),
                          )
                        ]
                      : null,
                )
              : null,
          body: SafeArea(
            child: switch (state) {
              OrderDetailsInProgress() =>
                const CenteredCircularProgressIndicator(),
              OrderDetailsSuccess() => _OrderDetails(order: state.order),
              OrderDetailsFailure() => const ExceptionIndicator()
            },
          ),
        );
      },
    );
  }
}

class _OrderDetails extends StatelessWidget {
  const _OrderDetails({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: order.items.length,
      itemBuilder: (BuildContext context, int index) {
        final orderItem = order.items[index];

        final textStyle = TextStyle(
          color: Colors.white,
          fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
        );

        return Stack(
          children: [
            Image.network(
              orderItem.imageUrl,
              color: Colors.black.withOpacity(0.4),
              width: double.infinity,
              colorBlendMode: BlendMode.darken,
              height: 300,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Text(orderItem.name, style: textStyle),
            ),
            Positioned(
              bottom: 64,
              left: 16,
              child: Text('unit price', style: textStyle),
            ),
            Positioned(
              bottom: 64,
              right: 16,
              child: Text(orderItem.unitPrice.toString(), style: textStyle),
            ),
            Positioned(
              bottom: 32,
              left: 16,
              child: Text('quantity', style: textStyle),
            ),
            Positioned(
              bottom: 32,
              right: 16,
              child: Text(orderItem.quantity.toString(), style: textStyle),
            ),
            Positioned(
              bottom: 8,
              left: 16,
              child: Text('price', style: textStyle),
            ),
            Positioned(
              bottom: 8,
              right: 16,
              child: Text(orderItem.totalPrice.toString(), style: textStyle),
            ),
          ],
        );
      },
    );
  }
}
