import 'package:equatable/equatable.dart';
import 'form_fields.dart';

class BusinessAddress extends FormInput<String, BusinessAddressValidationError>
    with EquatableMixin {
  const BusinessAddress.unvalidated([
    super.value = '',
  ]) : super.unvalidated();

  const BusinessAddress.validated(super.value) : super.validated();

  @override
  BusinessAddressValidationError? validator(String value) {
    return value.isEmpty ? BusinessAddressValidationError.empty : null;
  }

  @override
  List<Object?> get props => [value];
}

enum BusinessAddressValidationError {
  empty;

  String get message => 'enter your business address.';
}
