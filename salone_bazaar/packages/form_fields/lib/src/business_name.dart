import 'package:equatable/equatable.dart';
import 'form_fields.dart';

class BusinessName extends FormInput<String, BusinessNameValidationError>
    with EquatableMixin {
  const BusinessName.unvalidated([
    super.value = '',
  ]) : super.unvalidated();

  const BusinessName.validated(super.value) : super.validated();

  @override
  BusinessNameValidationError? validator(String value) {
    return value.isEmpty ? BusinessNameValidationError.empty : null;
  }

  @override
  List<Object?> get props => [value];
}

enum BusinessNameValidationError {
  empty;

  String get message => 'enter your business name.';
}
