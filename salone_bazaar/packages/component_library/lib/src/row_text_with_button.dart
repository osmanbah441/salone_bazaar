import 'package:flutter/material.dart';

class RowTextWithButton extends StatelessWidget {
  const RowTextWithButton({
    super.key,
    required this.text,
    required this.buttonLabel,
    this.onButtonTap,
  });

  final String text;
  final String buttonLabel;
  final VoidCallback? onButtonTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        TextButton(
          onPressed: onButtonTap,
          child: Text(buttonLabel),
        ),
      ],
    );
  }
}
