import 'package:flutter/material.dart';
import 'package:component_library/component_library.dart';
import 'package:user_repository/user_repository.dart';

import 'forgot_my_password_notifier.dart';

class ForgotMyPasswordDialog extends StatefulWidget {
  const ForgotMyPasswordDialog({
    super.key,
    required this.userRepository,
  });
  final UserRepository userRepository;

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
    _notifier = ForgotPasswordNotifier(widget.userRepository);
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
    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, child) => AlertDialog(
        title: const Text('Forgot password?'),
        content: Form(
          key: _formKey,
          child: Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              EmailField(
                controller: _emailController,
                enabled: !_notifier.submissionStatus.isInProgress,
              ),
              if (_notifier.submissionStatus.hasError)
                const Text('check your internet connection & retry.'),
            ],
          ),
        ),
        actions: [
          BazaarTextButton(
            label: 'cancel',
            onTap: _notifier.submissionStatus.isInProgress
                ? null
                : () => Navigator.pop(context),
          ),
          _notifier.submissionStatus.isInProgress
              ? BazaarTextButton.inprogress(label: 'confirm')
              : BazaarTextButton(
                  label: 'confirm',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _notifier.resetPassword(email: _emailController.text);
                    }
                  },
                ),
        ],
      ),
    );
  }
}
