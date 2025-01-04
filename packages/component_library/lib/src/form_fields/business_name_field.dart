import 'package:component_library/src/form_fields/dynamic_validating_text_field.dart';

class BusinessNameField extends DynamicValidatingTextField {
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
