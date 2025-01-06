import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

import 'account_type_selection.dart';
import 'buyer_sign_up_form.dart';
import 'seller_sign_up_form.dart';
import 'sign_up_notifier.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    required this.onSignUpSuccess,
    required this.onSignInTap,
    required this.userRepository,
  });

  final VoidCallback onSignUpSuccess;
  final VoidCallback onSignInTap;
  final UserRepository userRepository;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final SignUpNotifier _notifier;

  @override
  void initState() {
    super.initState();

    _notifier = SignUpNotifier(widget.userRepository);
    _notifier.addListener(_listener);
  }

  @override
  void dispose() {
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListenableBuilder(
            listenable: _notifier,
            builder: (context, child) => Column(
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTypeForm() => switch (_notifier.accountType) {
        AccountType.buyer => BuyerSignUpForm(notifier: _notifier),
        AccountType.seller => SellerSignUpForm(notifier: _notifier),
        AccountType.none => AccountTypeSelection(notifier: _notifier),
      };
}
