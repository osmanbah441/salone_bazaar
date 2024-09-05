import 'package:equatable/equatable.dart';

import 'form_fields.dart';

class ProductPrice extends FormInput<double, ProductPriceValidationError>
    with EquatableMixin {
  const ProductPrice.unvalidated([
    super.value = 0.0,
  ]) : super.unvalidated();

  const ProductPrice.validated(super.value) : super.validated();

  @override
  ProductPriceValidationError? validator(double value) {
    return value <= 0 ? ProductPriceValidationError.invalid : null;
  }

  @override
  List<Object?> get props => [value];
}

enum ProductPriceValidationError {
  invalid;

  String get message => 'Please enter a valid price greater than zero.';
}
