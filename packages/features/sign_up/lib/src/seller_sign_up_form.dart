import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:sign_up/src/sign_up_notifier.dart';

class SellerSignUpForm extends StatefulWidget {
  const SellerSignUpForm({
    super.key,
    required this.notifier,
  });

  final SignUpNotifier notifier;

  @override
  State<SellerSignUpForm> createState() => _SellerSignUpFormState();
}

class _SellerSignUpFormState extends State<SellerSignUpForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _sellerEmailController;
  late final TextEditingController _sellerPasswordController;
  late final TextEditingController _businessNameController;
  late final TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _sellerEmailController = TextEditingController();
    _sellerPasswordController = TextEditingController();
    _businessNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _sellerEmailController.dispose();
    _sellerPasswordController.dispose();
    _businessNameController.dispose();
    _phoneNumberController.dispose();
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
          BusinessNameField(
            controller: _businessNameController,
            enabled: !submissionStatus.isInProgress,
          ),
          PhoneNumberField(
            enabled: !submissionStatus.isInProgress,
            controller: _phoneNumberController,
          ),
          EmailField(
            onChanged: widget.notifier.onEmailChanged,
            controller: _sellerEmailController,
            enabled: !submissionStatus.isInProgress,
            isAlreadyRegistered: submissionStatus.isEmailAlreadyRegistered,
          ),
          PasswordField(
            controller: _sellerPasswordController,
            enabled: !submissionStatus.isInProgress,
          ),
          ExpandedElevatedButton(
            icon: const Icon(Icons.person_add),
            label: 'Create Account',
            onTap: submissionStatus.isInProgress
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      widget.notifier.createSellerAccount(
                        email: _sellerEmailController.text,
                        password: _sellerPasswordController.text,
                        businessName: _businessNameController.text,
                        phoneNumber: _phoneNumberController.text,
                      );
                    }
                  },
          ),
          BazaarTextButton(
            label: 'Create Buyer Account',
            onTap: submissionStatus.isInProgress
                ? null
                : () => widget.notifier.selectAccountType(AccountType.buyer),
          ),
        ],
      ),
    );
  }
}
