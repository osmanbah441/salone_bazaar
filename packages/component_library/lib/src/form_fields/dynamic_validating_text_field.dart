import 'package:flutter/material.dart';

/// A reusable Flutter widget that provides dynamic validation for text fields.
///
/// This widget dynamically adjusts its validation behavior based on user interaction:
///
/// - Initially, it validates on unfocus [AutovalidateMode.onUnfocus], providing
///   immediate feedback when the user leaves the field.
/// - After losing focus for the first time, it switches to validate on [AutovalidateMode.onUserInteraction]
//    offering a more responsive experience as the user types.
/// - If [TextFormField.validator] method is called,  it switches to validate [AutovalidateMode.onUserInteraction].
///
/// This widget is designed to be extended to provide custom validation logic.
abstract class DynamicValidatingTextField extends StatefulWidget {
  const DynamicValidatingTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.autocorrect = false,
    this.enabled = true,
    this.onChanged,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final bool enabled;
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final String obscuringCharacter;
  final Widget? suffixIcon;
  final bool autocorrect;
  final void Function(String?)? onChanged;
  String? validator(String? value);

  @override
  State<DynamicValidatingTextField> createState() =>
      _DynamicValidatingTextFieldState();
}

class _DynamicValidatingTextFieldState
    extends State<DynamicValidatingTextField> {
  late final ValueNotifier<AutovalidateMode> _valueNotifier;

  @override
  void initState() {
    super.initState();
    _valueNotifier = ValueNotifier(AutovalidateMode.onUnfocus);
  }

  @override
  void dispose() {
    _valueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _valueNotifier,
      builder: (context, autovalidateMode, child) => TextFormField(
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        obscuringCharacter: widget.obscuringCharacter,
        autocorrect: widget.autocorrect,
        enabled: widget.enabled,
        controller: widget.controller,
        validator: (value) {
          // If a validation has occurred, force validation on user interaction.
          _valueNotifier.value = AutovalidateMode.onUserInteraction;
          return widget.validator(value);
        },
        onChanged: widget.onChanged,
        autovalidateMode: autovalidateMode,
        decoration: InputDecoration(
          suffixIcon: widget.suffixIcon,
          labelText: widget.labelText.toUpperCase(),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
