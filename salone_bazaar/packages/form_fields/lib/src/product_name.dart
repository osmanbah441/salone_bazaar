import 'package:equatable/equatable.dart';

import 'form_fields.dart';

class ProductName extends FormInput<String, ProductNameValidationError>
    with EquatableMixin {
  const ProductName.unvalidated([
    super.value = '',
  ]) : super.unvalidated();

  const ProductName.validated(super.value) : super.validated();

  @override
  ProductNameValidationError? validator(String value) {
    return value.isEmpty ? ProductNameValidationError.empty : null;
  }

  @override
  List<Object?> get props => [value];
}

enum ProductNameValidationError {
  empty;

  String get message => 'Please enter a product name.';
}
