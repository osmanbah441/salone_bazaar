import 'package:bazaar_api/bazaar_api.dart';
import 'package:flutter/material.dart';
import 'package:component_library/component_library.dart';

import 'forgot_my_password_notifier.dart';

class ForgotMyPasswordDialog extends StatefulWidget {
  const ForgotMyPasswordDialog({super.key, required this.api});
  final BazaarApi api;

  @override
  State<ForgotMyPasswordDialog> createState() => _ForgotMyPasswordDialogState();
}

class _ForgotMyPasswordDialogState extends State<ForgotMyPasswordDialog> {
  late final TextEditingController _emailController;
  late final ForgotPasswordNotifier _notifier;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _notifier = ForgotPasswordNotifier(widget.api);
    _notifier.addListener(_listener);
  }

  void _listener() {
    if (_notifier.submissionStatus.isSuccess) {
      Navigator.maybePop(context);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('check your email to reset your password.'),
            duration: Duration(
              seconds: 8,
            ),
          ),
        );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _notifier.removeListener(_listener);
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Forgot password?'),
      content: Form(
        key: _formKey,
        child: ListenableBuilder(
          listenable: _notifier,
          builder: (context, child) => Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              EmailField(
                controller: _emailController,
                isValidationTriggered: _notifier.isValidationTriggered,
                enabled: !_notifier.submissionStatus.isInProgress,
              ),
              if (_notifier.submissionStatus.hasError)
                const Text('check your internet connection & retry.'),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _notifier.submissionStatus.isInProgress
              ? null
              : () => Navigator.pop(context),
          child: const Text('cancel'),
        ),
        _notifier.submissionStatus.isInProgress
            ? const InProgressTextButton(label: 'confirm')
            : TextButton(
                onPressed: () => _notifier.resetPassword(
                  formKey: _formKey,
                  email: _emailController.text,
                ),
                child: const Text('confirm'),
              )
      ],
    );
  }
}
