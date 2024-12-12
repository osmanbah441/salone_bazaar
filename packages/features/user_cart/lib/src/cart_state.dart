part of 'cart_cubit.dart';

sealed class CartState {
  const CartState();
}

class CartStateInprogress extends CartState {}

class CartStateFailure extends CartState {
  const CartStateFailure({required this.error});

  final dynamic error;
}

class CartStateSuccess extends CartState {
  const CartStateSuccess({required this.cart, this.cartUpdateError});

  final Cart cart;
  final dynamic cartUpdateError;

  CartStateSuccess.noItemsFound()
      : this(
          cart: Cart(
            cartId: '',
            userId: '',
            items: [],
            totalCartPrice: 0.0,
          ),
          cartUpdateError: null,
        );
}
