import 'package:bazaar_api/bazaar_api.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._api) : super(CartStateInprogress()) {
    _fetchCart();
  }

  final BazaarApi _api;

  void _fetchCart() async {
    try {
      final cart = await _api.cart.get();
      emit(CartStateSuccess(cart: cart));
    } on Exception catch (e) {
      emit(CartStateFailure(error: e));
    }
  }

  void refetch() {
    emit(CartStateInprogress());
    _fetchCart();
  }

  void createOrder() async {
    await _api.order.create();
    refetch();
  }

  void updateCartQuantity(String id, int newQty) async {
    if (newQty < 1) return;
    await _api.cart.updateQuantity(id, newQty);
    refetch();
  }
}
