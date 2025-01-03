import 'package:flutter/material.dart';

import 'dynamic_validating_text_field.dart';

class EmailField extends DynamicValidatingTextField {
  const EmailField({
    super.key,
    required super.controller,
    super.onChanged,
    required super.isValidationTriggered,
    super.keyboardType = TextInputType.emailAddress,
    super.enabled = true,
    super.labelText = 'EMAIL',
    this.isAlreadyRegistered = false,
    super.suffixIcon = const Icon(Icons.alternate_email),
  });

  static final _emailRegex = RegExp(
    '^(([\\w-]+\\.)+[\\w-]+|([a-zA-Z]|[\\w-]{2,}))@((([0-1]?'
    '[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.'
    '([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])'
    ')|([a-zA-Z]+[\\w-]+\\.)+[a-zA-Z]{2,4})\$',
  );

  final bool isAlreadyRegistered;

  @override
  String? validator(String? value) {
    return (value == null || value.isEmpty)
        ? "Email can't be empty"
        : (!_emailRegex.hasMatch(value))
            ? 'invalid email address.'
            : isAlreadyRegistered
                ? 'email already registered.'
                : null;
  }
}
