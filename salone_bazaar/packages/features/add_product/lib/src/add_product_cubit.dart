import 'package:bazaar_api/bazaar_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit(this.api) : super(const AddProductState());

  final BazaarApi api;

  void onProductNameChanged(String newValue) {
    final newProductName = state.productName.shouldValidate
        ? ProductName.validated(newValue)
        : ProductName.unvalidated(newValue);
    emit(state.copyWith(productName: newProductName));
  }

  void onProductNameUnfocused() {
    final newProductName = ProductName.validated(state.productName.value);
    final newState = state.copyWith(productName: newProductName);
    emit(newState);
  }

  void onProductDescriptionChanged(String newValue) {
    final newProductDescription = state.productDescription.shouldValidate
        ? ProductDescription.validated(newValue)
        : ProductDescription.unvalidated(newValue);
    emit(state.copyWith(productDescription: newProductDescription));
  }

  void onProductDescriptionUnfocused() {
    final newDecription =
        ProductDescription.validated(state.productDescription.value);
    final newState = state.copyWith(productDescription: newDecription);
    emit(newState);
  }

  void onProductPriceChanged(String newValue) {
    final price = double.tryParse(newValue) ?? 0.0;
    final newProductPrice = state.productPrice.shouldValidate
        ? ProductPrice.validated(price)
        : ProductPrice.unvalidated(price);
    emit(state.copyWith(productPrice: newProductPrice));
  }

  void onProductPriceUnfocused() {
    final newProductPrice = ProductPrice.validated(state.productPrice.value);
    final newState = state.copyWith(productPrice: newProductPrice);
    emit(newState);
  }

  void onImagePicked(String path) {
    final newProductImage = ProductImage.validated(path);
    emit(state.copyWith(productImage: newProductImage));
  }

  void onProductImageUnfocused() {
    final newProductImage = ProductImage.validated(state.productImage.value);
    final newState = state.copyWith(productImage: newProductImage);
    emit(newState);
  }

  Future<void> onSubmit() async {
    final productName = ProductName.validated(state.productName.value);
    final productDescription =
        ProductDescription.validated(state.productDescription.value);
    final productPrice = ProductPrice.validated(state.productPrice.value);
    final productImage = ProductImage.validated(state.productImage.value);

    if (productName.isValid &&
        productDescription.isValid &&
        productPrice.isValid &&
        productImage.isValid) {
      try {
        await api.product.add(
          name: productName.value,
          description: productDescription.value,
          price: productPrice.value,
          imagePath: productImage.value,
        );
        emit(state.copyWith(submissionStatus: SubmissionStatus.success));
      } catch (e) {
        emit(state.copyWith(submissionStatus: SubmissionStatus.genericError));
      }
    } else {
      emit(state.copyWith(submissionStatus: SubmissionStatus.idle));
    }
  }
}
