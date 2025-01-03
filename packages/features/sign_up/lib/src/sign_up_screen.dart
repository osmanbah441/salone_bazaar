import 'package:bazaar_api/bazaar_api.dart';
import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

import 'sign_up_notifier.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    required this.onSignUpSuccess,
    required this.onSignInTap,
    required this.api,
  });

  final VoidCallback onSignUpSuccess;
  final VoidCallback onSignInTap;
  final BazaarApi api;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController _buyerEmailController;
  late final TextEditingController _buyerPasswordController;
  late final TextEditingController _sellerEmailController;
  late final TextEditingController _sellerPasswordController;
  late final TextEditingController _businessNameController;
  late final TextEditingController _phoneNumberController;
  late final GlobalKey<FormState> _formKey;
  late final SignUpNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _buyerEmailController = TextEditingController();
    _buyerPasswordController = TextEditingController();
    _sellerEmailController = TextEditingController();
    _sellerPasswordController = TextEditingController();
    _businessNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _notifier = SignUpNotifier(widget.api);
    _notifier.addListener(_listener);
  }

  @override
  void dispose() {
    _buyerEmailController.dispose();
    _buyerPasswordController.dispose();
    _sellerEmailController.dispose();
    _sellerPasswordController.dispose();
    _businessNameController.dispose();
    _phoneNumberController.dispose();
    _notifier.removeListener(_listener);
    _notifier.dispose();
    super.dispose();
  }

  void _listener() {
    if (_notifier.submissionStatus.isSuccess) {
      widget.onSignUpSuccess();
    } else if (_notifier.submissionStatus.isNetworkError) {
      ScaffoldMessenger.of(context).showSnackBar(const GenericErrorSnackBar());
    } else if (_notifier.submissionStatus.isGoogleSignInError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Google sign-in error')));
    }
  }

  void _submit() => switch (_notifier.createAccountFor) {
        AccountType.buyer => _notifier.createAccount(
            formKey: _formKey,
            email: _buyerEmailController.text,
            password: _buyerPasswordController.text,
          ),
        AccountType.seller => _notifier.createAccount(
            formKey: _formKey,
            email: _sellerEmailController.text,
            password: _sellerPasswordController.text,
            businessName: _businessNameController.text,
            phoneNumber: _phoneNumberController.text,
          ),
        AccountType.none => null,
      };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListenableBuilder(
              listenable: _notifier,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 16,
                  children: [
                    Text(
                      'Sign up for SaloneBazaar',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Spacing.height24,
                    _buildAccountTypeForm(),
                    if (!_notifier.createAccountFor.isNone) ...[
                      (_notifier.submissionStatus.isInProgress)
                          ? ExpandedElevatedButton.inProgress(
                              label: 'Loading',
                            )
                          : ExpandedElevatedButton(
                              icon: const Icon(Icons.person_add),
                              label: 'Sign Up',
                              onTap: _submit,
                            ),
                      TextButton(
                        onPressed: _notifier.submissionStatus.isInProgress
                            ? null
                            : () => _notifier.selectAccountType(
                                  _notifier.createAccountFor.isBuyer
                                      ? AccountType.seller
                                      : AccountType.buyer,
                                ),
                        child: Text(
                          _notifier.createAccountFor.isBuyer
                              ? 'Create Seller Account'
                              : 'Create Buyer Account',
                        ),
                      ),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: _notifier.submissionStatus.isInProgress
                              ? null
                              : widget.onSignInTap,
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: _notifier.submissionStatus.isInProgress
                                  ? Colors.grey
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTypeForm() => switch (_notifier.createAccountFor) {
        AccountType.buyer => Column(
            spacing: 16,
            children: [
              ExpandedElevatedButton.google(
                onTap: !_notifier.submissionStatus.isInProgress
                    ? _notifier.continueWithGoogle
                    : null,
              ),
              const Text('or'),
              EmailField(
                onChanged: _notifier.onBuyerEmailChanged,
                controller: _buyerEmailController,
                enabled: !_notifier.submissionStatus.isInProgress,
                isValidationTriggered: _notifier.isValidationTriggeredForBuyer,
                isAlreadyRegistered:
                    _notifier.submissionStatus.isBuyerEmailAlreadyRegistered,
              ),
              PasswordField(
                controller: _buyerPasswordController,
                enabled: !_notifier.submissionStatus.isInProgress,
                isValidationTriggered:
                    _notifier.submissionStatus.isBuyerEmailAlreadyRegistered,
              ),
            ],
          ),
        AccountType.seller => Column(
            spacing: 16,
            children: [
              BusinessNameField(
                controller: _businessNameController,
                enabled: !_notifier.submissionStatus.isInProgress,
                isValidationTriggered: _notifier.isValidationTriggeredForSeller,
              ),
              PhoneNumberField(
                enabled: !_notifier.submissionStatus.isInProgress,
                controller: _phoneNumberController,
                isValidationTriggered: _notifier.isValidationTriggeredForSeller,
              ),
              EmailField(
                onChanged: _notifier.onSellerEmailChanged,
                controller: _sellerEmailController,
                enabled: !_notifier.submissionStatus.isInProgress,
                isValidationTriggered: _notifier.isValidationTriggeredForSeller,
                isAlreadyRegistered:
                    _notifier.submissionStatus.isSellerEmailAlreadyRegistered,
              ),
              PasswordField(
                controller: _sellerPasswordController,
                enabled: !_notifier.submissionStatus.isInProgress,
                isValidationTriggered: _notifier.isValidationTriggeredForSeller,
              ),
            ],
          ),
        AccountType.none => Column(
            children: [
              const Text(
                'Create a buyer or seller account today and experience the convenience of buying or selling anything you desire, whenever it suits you.',
                textAlign: TextAlign.center,
              ),
              Spacing.height24,
              TextButton(
                onPressed: () => _notifier.selectAccountType(AccountType.buyer),
                child: const Text('Create Buyer Account'),
              ),
              const Text('or'),
              ElevatedButton(
                onPressed: () =>
                    _notifier.selectAccountType(AccountType.seller),
                child: const Text('Create Seller Account'),
              ),
            ],
          ),
      };
}
