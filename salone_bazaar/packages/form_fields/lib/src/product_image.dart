import 'package:equatable/equatable.dart';

import 'form_fields.dart';

class ProductImage extends FormInput<String, ProductImageValidationError>
    with EquatableMixin {
  const ProductImage.unvalidated([
    super.value = '',
  ]) : super.unvalidated();

  const ProductImage.validated(super.value) : super.validated();

  @override
  ProductImageValidationError? validator(String value) {
    return value.isEmpty ? ProductImageValidationError.empty : null;
  }

  @override
  List<Object?> get props => [value];
}

enum ProductImageValidationError {
  empty;

  String get message => 'Please select an image for the product.';
}
