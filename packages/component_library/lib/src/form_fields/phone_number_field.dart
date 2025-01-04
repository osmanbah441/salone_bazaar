import 'package:component_library/src/form_fields/dynamic_validating_text_field.dart';

class PhoneNumberField extends DynamicValidatingTextField {
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
