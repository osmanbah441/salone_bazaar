import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

class EmailAndPasswordForm extends StatelessWidget {
  const EmailAndPasswordForm({
    super.key,
    required this.buttonLabel,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.isEmailAndPasswordSubmissionStatusInProgress,
    required this.emailFieldErrorText,
    required this.passwordFieldErrorText,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onEmailAndPasswordSubmit,
  });

  final String buttonLabel;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final bool isEmailAndPasswordSubmissionStatusInProgress;
  final String? emailFieldErrorText;
  final String? passwordFieldErrorText;
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;
  final VoidCallback onEmailAndPasswordSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          focusNode: emailFocusNode,
          textInputAction: TextInputAction.next,
          onChanged: onEmailChanged,
          enabled: !isEmailAndPasswordSubmissionStatusInProgress,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.email),
            enabled: !isEmailAndPasswordSubmissionStatusInProgress,
            labelText: 'email',
            errorText: emailFieldErrorText,
          ),
        ),
        Spacing.height16,
        TextField(
          focusNode: passwordFocusNode,
          enabled: !isEmailAndPasswordSubmissionStatusInProgress,
          onChanged: onPasswordChanged,
          textInputAction: TextInputAction.next,
          obscureText: true,
          obscuringCharacter: '*',
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.lock),
            labelText: 'Password',
            enabled: !isEmailAndPasswordSubmissionStatusInProgress,
            errorText: passwordFieldErrorText,
          ),
        ),
        Spacing.height24,
        isEmailAndPasswordSubmissionStatusInProgress
            ? ExpandedElevatedButton.inProgress(
                label: 'Loading',
              )
            : ExpandedElevatedButton(
                onTap: onEmailAndPasswordSubmit,
                label: buttonLabel,
                icon: const Icon(Icons.login),
              ),
      ],
    );
  }
}
