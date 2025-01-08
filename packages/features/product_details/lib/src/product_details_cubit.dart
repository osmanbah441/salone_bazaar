import 'dart:async';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_repository/product_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:cart_repository/cart_repository.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit({
    required this.productId,
    required ProductsRepository productRepository,
    required UserRepository userRepository,
    required CartRepository cartRepository,
  })  : _userRepository = userRepository,
        _productRepository = productRepository,
        _cartRepository = cartRepository,
        super(const ProductDetailsInProgress()) {
    _fetchProductDetails();
  }

  final String productId;
  final UserRepository _userRepository;
  final ProductsRepository _productRepository;
  final CartRepository _cartRepository;

  Future<void> _fetchProductDetails() async {
    try {
      final product = await _productRepository.getSingleProduct(productId);
      emit(ProductDetailsSuccess(product: product!));
    } catch (error) {
      emit(const ProductDetailsFailure());
    }
  }

  Future<void> refetch() async {
    emit(const ProductDetailsInProgress());
    _fetchProductDetails();
  }

  Future<void> addProductToCart(Product item) async {
    final lastState = state;
    if (lastState is ProductDetailsSuccess) {
      emit(lastState.copyWith(isAddToCartLoading: true));
    }

    try {
      final uid = _userRepository.currentUser?.uid;
      if (uid == null) throw const UserAuthenticationRequiredException();
      await _cartRepository.addProductToCart(product: item, uid: uid);
      emit(ProductDetailsSuccess(product: item, isAddedToCartSuccessful: true));
    } catch (error) {
      if (lastState is ProductDetailsSuccess) {
        emit(ProductDetailsSuccess(
          product: lastState.product,
          productCartError: error,
        ));
      }
    }
  }
}
