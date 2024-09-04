part of 'product_details_cubit.dart';

sealed class ProductDetailsState extends Equatable {
  const ProductDetailsState();
}

class ProductDetailsInProgress extends ProductDetailsState {
  const ProductDetailsInProgress();

  @override
  List<Object?> get props => [];
}

class ProductDetailsSuccess extends ProductDetailsState {
  const ProductDetailsSuccess({
    required this.product,
    this.productCartError,
    this.isAddToCartLoading = false,
    this.isAddedToCartSuccessful = false,
  });

  final Product product;
  final dynamic productCartError;
  final bool isAddToCartLoading;
  final bool isAddedToCartSuccessful;

  ProductDetailsSuccess copyWith({bool? isAddToCartLoading}) =>
      ProductDetailsSuccess(
        product: product,
        isAddToCartLoading: isAddToCartLoading ?? this.isAddToCartLoading,
      );

  @override
  List<Object?> get props => [
        product,
        productCartError,
        isAddToCartLoading,
      ];
}

class ProductDetailsFailure extends ProductDetailsState {
  const ProductDetailsFailure();

  @override
  List<Object?> get props => [];
}
