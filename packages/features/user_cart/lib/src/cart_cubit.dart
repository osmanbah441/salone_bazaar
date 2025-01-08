import 'package:cart_repository/cart_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:order_repository/order_repository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._cartRepository, this._userRepository, this._ordersRepository)
      : super(CartStateInprogress()) {
    _fetchCart();
  }

  final CartRepository _cartRepository;
  final UserRepository _userRepository;
  final OrdersRepository _ordersRepository;

  void _fetchCart() async {
    try {
      final cart = await _cartRepository
          .getAllCartProduct(_userRepository.currentUser!.uid!);
      emit(CartStateSuccess(cart: cart));
    } on Exception catch (e) {
      emit(CartStateFailure(error: e));
    }
  }

  void refetch() {
    emit(CartStateInprogress());
    _fetchCart();
  }

  void createOrder(lat, long) async {
    final uid = _userRepository.currentUser!.uid!;

    final cart = await _cartRepository.getAllCartProduct(uid);
    await _ordersRepository.create(lat, long, uid, cart);
    await _cartRepository.removeAllProductFromCart(uid);
    refetch();
  }

  void updateCartQuantity(String id, int newQty) async {
    if (newQty < 1) return;
    await _cartRepository.updateCartProductQuantity(
      productId: id,
      uid: _userRepository.currentUser!.uid!,
      quantity: newQty,
    );
    refetch();
  }
}
