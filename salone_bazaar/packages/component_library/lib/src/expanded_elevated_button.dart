import 'package:flutter/material.dart';

class ExpandedElevatedButton extends StatelessWidget {
  static const double _elevatedButtonHeight = 48;

  const ExpandedElevatedButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.color,
  });

  ExpandedElevatedButton.google({Key? key, VoidCallback? onTap})
      : this(
          key: key,
          onTap: onTap,
          icon: Image.asset(
            'assets/google_icon.png',
            height: 32,
            package: 'component_library',
          ),
          label: 'Continue with google',
        );

  ExpandedElevatedButton.inProgress({required String label, Key? key})
      : this(
          label: label,
          icon: Transform.scale(
            scale: 0.5,
            child: const CircularProgressIndicator(),
          ),
          key: key,
        );

  const ExpandedElevatedButton.signOut({Key? key, VoidCallback? onTap})
      : this(
            key: key,
            label: 'Sign Out',
            icon: const Icon(Icons.logout),
            onTap: onTap,
            color: const Color.fromARGB(255, 254, 148, 140));

  final VoidCallback? onTap;
  final String label;
  final Widget? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(backgroundColor: color);
    final labelText = Text(label);
    return SizedBox(
      height: _elevatedButtonHeight,
      width: double.infinity,
      child: icon != null
          ? ElevatedButton.icon(
              style: style,
              onPressed: onTap,
              label: labelText,
              icon: icon,
            )
          : ElevatedButton(
              style: style,
              onPressed: onTap,
              child: labelText,
            ),
    );
  }
}
