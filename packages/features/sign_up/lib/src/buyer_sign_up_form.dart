import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:sign_up/src/sign_up_notifier.dart';

class BuyerSignUpForm extends StatefulWidget {
  const BuyerSignUpForm({
    super.key,
    required this.notifier,
  });

  final SignUpNotifier notifier;

  @override
  State<BuyerSignUpForm> createState() => _BuyerSignUpFormState();
}

class _BuyerSignUpFormState extends State<BuyerSignUpForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _buyerEmailController;
  late final TextEditingController _buyerPasswordController;

  @override
  void initState() {
    super.initState();
    _buyerEmailController = TextEditingController();
    _buyerPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _buyerEmailController.dispose();
    _buyerPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final submissionStatus = widget.notifier.submissionStatus;

    return Form(
      key: _formKey,
      child: Column(
        spacing: 16,
        children: [
          ExpandedElevatedButton.google(
            onTap: !submissionStatus.isInProgress
                ? widget.notifier.continueWithGoogle
                : null,
          ),
          const Text('or'),
          EmailField(
            onChanged: widget.notifier.onEmailChanged,
            controller: _buyerEmailController,
            enabled: !submissionStatus.isInProgress,
            isAlreadyRegistered: submissionStatus.isEmailAlreadyRegistered,
          ),
          PasswordField(
            controller: _buyerPasswordController,
            enabled: !submissionStatus.isInProgress,
          ),
          ExpandedElevatedButton(
            icon: const Icon(Icons.person_add),
            label: 'Create Account',
            onTap: submissionStatus.isInProgress
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      widget.notifier.createBuyerAccount(
                        email: _buyerEmailController.text,
                        password: _buyerPasswordController.text,
                      );
                    }
                  },
          ),
          BazaarTextButton(
            label: 'Create Seller Account',
            onTap: submissionStatus.isInProgress
                ? null
                : () => widget.notifier.selectAccountType(AccountType.seller),
          ),
        ],
      ),
    );
  }
}
