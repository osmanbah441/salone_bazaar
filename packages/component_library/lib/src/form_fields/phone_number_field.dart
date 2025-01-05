import 'autovalidating_text_field.dart';

class PhoneNumberField extends AutovalidatingTextField {
  const PhoneNumberField({
    super.key,
    required super.controller,
    super.labelText = 'Phone number',
    super.enabled = true,
    super.onChanged,
  });

  static final _phoneNumberRegex = RegExp(r'^\+?[1-9]\d{1,14}$');

  @override
  String? validator(String? value) {
    return value == null || value.isEmpty
        ? 'enter your phone number.'
        : !_phoneNumberRegex.hasMatch(value)
            ? 'invalid phone number.'
            : null;
  }
}
