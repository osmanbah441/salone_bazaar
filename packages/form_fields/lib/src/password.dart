import 'form_fields.dart';

final class Password extends FormInput<String, PasswordValidationError> {
  const Password.unvalidated([super.value = '']) : super.unvalidated();
  const Password.validated(super.value) : super.validated();

  @override
  PasswordValidationError? validator(String value) {
    return value.isEmpty
        ? PasswordValidationError.empty
        : (value.length < 8)
            ? PasswordValidationError.invalid
            : null;
  }
}

enum PasswordValidationError {
  empty,
  invalid;

  String get message => switch (this) {
        PasswordValidationError.empty => 'enter a password.',
        PasswordValidationError.invalid =>
          'password should be at least 8 characters',
      };
}
