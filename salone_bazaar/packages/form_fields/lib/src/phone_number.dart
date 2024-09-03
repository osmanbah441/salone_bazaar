import 'package:equatable/equatable.dart';
import 'form_fields.dart';

class PhoneNumber extends FormInput<String, PhoneNumberValidationError>
    with EquatableMixin {
  const PhoneNumber.unvalidated([
    super.value = '',
  ]) : super.unvalidated();

  const PhoneNumber.validated(super.value) : super.validated();

  static final _phoneNumberRegex = RegExp(r'^\+?[1-9]\d{1,14}$');

  @override
  PhoneNumberValidationError? validator(String value) {
    return value.isEmpty
        ? PhoneNumberValidationError.empty
        : (_phoneNumberRegex.hasMatch(value)
            ? null
            : PhoneNumberValidationError.invalid);
  }

  @override
  List<Object?> get props => [value];
}

enum PhoneNumberValidationError {
  empty,
  invalid;

  String get message => switch (this) {
        PhoneNumberValidationError.empty => 'enter your phone number.',
        PhoneNumberValidationError.invalid => 'invalid phone number.',
      };
}
