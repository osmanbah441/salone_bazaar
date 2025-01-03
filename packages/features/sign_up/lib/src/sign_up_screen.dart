import 'package:bazaar_api/bazaar_api.dart';
import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

import 'account_type_selection_widget.dart';
import 'buyer_fields_widget.dart';
import 'seller_fields_widget.dart';
import 'sign_up_notifier.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    required this.onSignUpSuccess,
    required this.onSignInTap,
    required this.api,
    required this.onCreateRetailerAccount,
  });

  final VoidCallback onSignUpSuccess;
  final VoidCallback onSignInTap;
  final VoidCallback onCreateRetailerAccount;
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
                    children: [
                      Text(
                        'Sign up for SaloneBazaar',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Spacing.height24,
                      switch (_notifier.createAccountFor) {
                        CreateAccountFor.buyer => BuyerFieldsWidget(
                            emailController: _buyerEmailController,
                            passwordController: _buyerPasswordController,
                            enabled: !_notifier.submissionStatus.isInProgress,
                            onContinueWithGoogleTap:
                                _notifier.continueWithGoogle,
                            onEmailChanged: _notifier.onBuyerEmailChanged,
                            emailAlreadyRegistered: _notifier
                                .submissionStatus.isBuyerEmailAlreadyRegistered,
                            isValidationTriggered:
                                _notifier.isValidationTriggered,
                          ),
                        CreateAccountFor.seller => SellerFieldsWidget(
                            emailController: _sellerEmailController,
                            passwordController: _sellerPasswordController,
                            businessNameController: _businessNameController,
                            phoneNumberController: _phoneNumberController,
                            emailAlreadyRegistered: _notifier.submissionStatus
                                .isSellerEmailAlreadyRegistered,
                            enabled: !_notifier.submissionStatus.isInProgress,
                            isValidationTriggered:
                                _notifier.isValidationTriggered,
                            onEmailChanged: _notifier.onSellerEmailChanged,
                          ),
                        CreateAccountFor.none => AccountTypeSelectionWidget(
                            onSelectBuyer: () => _notifier
                                .selectAccountType(CreateAccountFor.buyer),
                            onSelectSeller: () => _notifier
                                .selectAccountType(CreateAccountFor.seller),
                          ),
                      },
                      if (!_notifier.createAccountFor.isNone)
                        (_notifier.submissionStatus.isInProgress)
                            ? ExpandedElevatedButton.inProgress(
                                label: 'Loading')
                            : ExpandedElevatedButton(
                                icon: const Icon(Icons.person_add),
                                label: 'Sign Up',
                                onTap: _notifier.createAccountFor.isBuyer
                                    ? () =>
                                        _notifier.signUpWithEmailAndPassword(
                                          formKey: _formKey,
                                          email: _buyerEmailController.text,
                                          password:
                                              _buyerPasswordController.text,
                                        )
                                    : () =>
                                        _notifier.signUpWithEmailAndPassword(
                                          formKey: _formKey,
                                          email: _sellerEmailController.text,
                                          password:
                                              _sellerPasswordController.text,
                                        ),
                              ),
                      if (_notifier.createAccountFor.isBuyer)
                        TextButton(
                          onPressed: () => _notifier
                              .selectAccountType(CreateAccountFor.seller),
                          child: const Text('Create Seller Account'),
                        ),
                      if (_notifier.createAccountFor.isSeller)
                        TextButton(
                          onPressed: () => _notifier
                              .selectAccountType(CreateAccountFor.buyer),
                          child: const Text('Create Buyer Account'),
                        ),
                      RowTextWithButton(
                        text: 'Already have an account?',
                        buttonLabel: 'Sign In',
                        onButtonTap: _notifier.submissionStatus.isInProgress
                            ? null
                            : widget.onSignInTap,
                      ),
                      RowTextWithButton(
                        text: 'Addd?',
                        buttonLabel: 'Scccccc',
                        onButtonTap: _notifier.submissionStatus.isInProgress
                            ? null
                            : widget.onCreateRetailerAccount,
                      ),
                    ]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
