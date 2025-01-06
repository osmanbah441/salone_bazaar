import 'package:bazaar_api/bazaar_api.dart';

import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:component_library/component_library.dart';
import 'package:map_tracking/map_tracking.dart';
import 'package:user_repository/user_repository.dart';

import 'cart_cubit.dart';
import 'cart_list_tile.dart';

class UserCartScreen extends StatelessWidget {
  const UserCartScreen({
    required this.userRepository,
    required this.api,
    required this.onItemTap,
    super.key,
  });

  final BazaarApi api;
  final Function(String) onItemTap;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartCubit>(
      create: (_) => CartCubit(api, userRepository),
      child: CartView(
        onItemTap: onItemTap,
      ),
    );
  }
}

@visibleForTesting
class CartView extends StatelessWidget {
  const CartView({
    super.key,
    required this.onItemTap,
  });

  final Function(String) onItemTap;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        final cartUpdateError =
            state is CartStateSuccess ? state.cartUpdateError : null;
        if (cartUpdateError != null) {
          final snackBar =
              cartUpdateError is UserAuthenticationRequiredException
                  ? const AuthenticationRequiredErrorSnackBar()
                  : const GenericErrorSnackBar();

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cart'),
          ),
          body: SafeArea(
              child: switch (state) {
            CartStateInprogress() => const CenteredCircularProgressIndicator(),
            CartStateSuccess() => _Cart(state.cart, onItemTap),
            CartStateFailure() => ExceptionIndicator(
                onTryAgain: () {
                  final cubit = context.read<CartCubit>();
                  cubit.refetch();
                },
              ),
          }),
        );
      },
    );
  }
}

class _Cart extends StatelessWidget {
  const _Cart(this.cart, this.onItemTap);
  final Cart cart;
  final Function(String) onItemTap;

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: (cart.items.isEmpty)
          ? const EmptyItemList()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return CartListTile(
                        onItemTap: () => onItemTap(item.productId),
                        imageUrl: item.imageUrl,
                        price: item.unitPrice,
                        quantity: item.quantity,
                        name: item.name,
                        onDecrement: () => cartCubit.updateCartQuantity(
                            item.productId, item.quantity - 1),
                        onIncrement: () => cartCubit.updateCartQuantity(
                            item.productId, item.quantity + 1),
                      );
                    },
                  ),
                ),
                ExpandedElevatedButton(
                    label: 'buy now',
                    onTap: () => showDialog(
                          context: context,
                          builder: (_) => _CartSummaryDialog(
                            totalPrice: cart.totalCartPrice,
                            onOrderConfirmed: (lat, long) =>
                                cartCubit.createOrder(lat, long),
                          ),
                        ))
              ],
            ),
    );
  }
}

class _CartSummaryDialog extends StatelessWidget {
  const _CartSummaryDialog({
    required this.onOrderConfirmed,
    required this.totalPrice,
  });

  final Function(double latitude, double longitude) onOrderConfirmed;
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmation Order'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Your order will be processed and delivered.'),
          const SizedBox(height: 8),
          Text(
            'Choose location',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const LocationPicker(),
          const SizedBox(height: 8),
          Text(
            'Total Order Price: SLL${totalPrice.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Close the dialog
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onOrderConfirmed(LocationPicker.latitude, LocationPicker.longitude);
            Navigator.of(context).pop();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
