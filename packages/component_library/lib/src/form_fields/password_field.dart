import 'package:flutter/material.dart';

import 'autovalidating_text_field.dart';

class PasswordField extends AutovalidatingTextField {
  const PasswordField({
    super.key,
    required super.controller,
    super.obscureText = true,
    super.keyboardType = TextInputType.visiblePassword,
    super.onChanged,
    super.labelText = 'PASSWORD',
    super.enabled = true,
    super.suffixIcon = const Icon(Icons.lock),
  });

  @override
  String? validator(String? value) {
    return (value == null || value.isEmpty)
        ? "Password can't be empty"
        : (value.length < 8)
            ? "Password must be at least 8 characters"
            : null;
  }
}
