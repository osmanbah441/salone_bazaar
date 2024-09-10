
import 'package:form_fields/src/form_fields.dart';

final class Username extends FormInput<String, UsernameValidationError> {
  const Username.unvalidated([super.value = '']) : super.unvalidated();
  const Username.validated(super.value) : super.validated();

  @override
  UsernameValidationError? validator(String value) {
    return value.isEmpty
        ? UsernameValidationError.empty
        : (value.length < 3)
            ? UsernameValidationError.invalid
            : null;
  }
}

enum UsernameValidationError {
  empty,
  invalid;

  String get message => switch (this) {
        UsernameValidationError.empty => 'enter a password.',
        UsernameValidationError.invalid =>
          'username should be at least 3 characters',
      };
}
