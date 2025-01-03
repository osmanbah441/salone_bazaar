import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

class BuyerFieldsWidget extends StatelessWidget {
  const BuyerFieldsWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.enabled = true,
    this.onContinueWithGoogleTap,
    this.onEmailChanged,
    this.isValidationTriggered = false,
    this.emailAlreadyRegistered = false,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool enabled;
  final VoidCallback? onContinueWithGoogleTap;
  final void Function(String?)? onEmailChanged;
  final bool isValidationTriggered;
  final bool emailAlreadyRegistered;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        ExpandedElevatedButton.google(
          onTap: enabled ? onContinueWithGoogleTap : null,
        ),
        const Text('or'),
        EmailField(
          onChanged: onEmailChanged,
          controller: emailController,
          enabled: enabled,
          isValidationTriggered: isValidationTriggered,
          isAlreadyRegistered: emailAlreadyRegistered,
        ),
        PasswordField(
          controller: passwordController,
          enabled: enabled,
          isValidationTriggered: isValidationTriggered,
        ),
      ],
    );
  }
}
