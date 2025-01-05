import 'autovalidating_text_field.dart';

class UsernameField extends AutovalidatingTextField {
  const UsernameField({
    super.key,
    required super.controller,
    super.labelText = 'username',
    super.initialValue,
    super.onFieldSubmitted,
  });

  @override
  String? validator(String? value) {
    return (value == null || value.isEmpty)
        ? "must not be empty"
        : (value.length < 3)
            ? "must be at least 3 character"
            : null;
  }
}
