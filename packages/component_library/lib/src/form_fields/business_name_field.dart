import 'autovalidating_text_field.dart';

class BusinessNameField extends AutovalidatingTextField {
  const BusinessNameField({
    super.key,
    required super.controller,
    super.labelText = 'BUSINESS NAME',
    super.enabled = true,
    super.onChanged,
  });

  @override
  String? validator(String? value) {
    return value == null || value.isEmpty ? 'enter your business name.' : null;
  }
}
