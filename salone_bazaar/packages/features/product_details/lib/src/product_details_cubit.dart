import 'dart:async';
import 'package:bazaar_api/bazaar_api.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit({required this.productId, required BazaarApi api})
      : _api = api,
        super(const ProductDetailsInProgress()) {
    _fetchProductDetails();
  }

  final String productId;
  final BazaarApi _api;

  Future<void> _fetchProductDetails() async {
    try {
      final product = await _api.product.getProductDetails(productId);
      emit(ProductDetailsSuccess(product: product));
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
      await _api.cart.addItemToCart(item);
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
