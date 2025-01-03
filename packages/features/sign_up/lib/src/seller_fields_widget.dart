import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

class SellerFieldsWidget extends StatelessWidget {
  const SellerFieldsWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.businessNameController,
    required this.phoneNumberController,
    this.enabled = true,
    this.onEmailChanged,
    this.isValidationTriggered = false,
    this.emailAlreadyRegistered = false,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController businessNameController;
  final TextEditingController phoneNumberController;
  final bool enabled;
  final void Function(String?)? onEmailChanged;
  final bool isValidationTriggered;
  final bool emailAlreadyRegistered;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        BusinessNameField(
          controller: businessNameController,
          enabled: enabled,
          isValidationTriggered: isValidationTriggered,
        ),
        PhoneNumberField(
          enabled: enabled,
          controller: phoneNumberController,
          isValidationTriggered: isValidationTriggered,
        ),
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
