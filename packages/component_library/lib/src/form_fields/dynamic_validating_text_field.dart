import 'package:flutter/material.dart';

/// A reusable Flutter widget that provides dynamic validation for text fields.
///
/// This widget dynamically adjusts its validation behavior based on user interaction:
///
/// - Initially, it validates on unfocus [AutovalidateMode.onUnfocus], providing
///   immediate feedback when the user leaves the field.
/// - After losing focus for the first time, it switches to validate on user interaction
///   [AutovalidateMode.onUserInteraction], offering a more responsive experience
///   as the user types.
///
/// - If `[hasValidationErrorOccurred]` is true, it forces validation on user
/// [AutovalidateMode.onUserInteraction] regardless of the focus state.
/// This is useful for ensuring continuous validation after an initial validation error.
///
/// This widget is designed to be extended to provide custom validation logic.
abstract class DynamicValidatingTextField extends StatefulWidget {
  const DynamicValidatingTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.isValidationTriggered,
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

  /// This flag is used to trigger validation on user interaction
  final bool isValidationTriggered;

  @override
  State<DynamicValidatingTextField> createState() =>
      _DynamicValidatingTextFieldState();
}

class _DynamicValidatingTextFieldState
    extends State<DynamicValidatingTextField> {
  // Tracks whether the field has lost focus at least once.
  bool _hasLostFocusOnce = false;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _setFocusListener();
  }

  void _setFocusListener() {
    _focusNode.addListener(() {
      // When focus is lost for the first time, update the state to track it.
      if (!_focusNode.hasFocus && !_hasLostFocusOnce) {
        setState(() {
          _hasLostFocusOnce = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final autovalidateMode = _hasLostFocusOnce
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.onUnfocus;

    return TextFormField(
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      obscuringCharacter: widget.obscuringCharacter,
      autocorrect: widget.autocorrect,
      focusNode: _focusNode,
      enabled: widget.enabled,
      controller: widget.controller,
      validator: widget.validator,
      onChanged: widget.onChanged,
      autovalidateMode: widget.isValidationTriggered
          ? AutovalidateMode.onUserInteraction
          : autovalidateMode,
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText.toUpperCase(),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
