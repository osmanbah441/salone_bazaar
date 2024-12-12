import 'package:equatable/equatable.dart';
import 'form_fields.dart';

class ProductDescription
    extends FormInput<String, ProductDescriptionValidationError>
    with EquatableMixin {
  const ProductDescription.unvalidated([
    super.value = '',
  ]) : super.unvalidated();

  const ProductDescription.validated(super.value) : super.validated();

  @override
  ProductDescriptionValidationError? validator(String value) {
    return value.isEmpty ? ProductDescriptionValidationError.empty : null;
  }

  @override
  List<Object?> get props => [value];
}

enum ProductDescriptionValidationError {
  empty;

  String get message => 'Please provide a product description.';
}
