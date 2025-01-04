import 'package:component_library/src/centered_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class BazaarTextButton extends StatelessWidget {
  const BazaarTextButton({
    super.key,
    this.onTap,
    required this.label,
    this.icon,
    this.color,
  });

  final VoidCallback? onTap;
  final String label;
  final Widget? icon;
  final Color? color;

  BazaarTextButton.inprogress({required String label, Key? key})
      : this(
          label: label,
          icon: Transform.scale(
            scale: 0.5,
            child: const CenteredCircularProgressIndicator(),
          ),
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return icon != null
        ? TextButton.icon(
            icon: icon!,
            label: Text(label),
            onPressed: onTap,
          )
        : TextButton(
            onPressed: onTap,
            child: Text(label),
          );
  }
}
