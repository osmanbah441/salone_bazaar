import 'package:bazaar_api/bazaar_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:component_library/component_library.dart';

import 'retailer_registration_cubit.dart';

class RetailerRegistrationScreen extends StatelessWidget {
  const RetailerRegistrationScreen({
    super.key,
    required this.api,
    required this.onRegistrationSuccess,
    required this.onCreateAccountTap,
  });

  final BazaarApi api;
  final VoidCallback onRegistrationSuccess;
  final VoidCallback onCreateAccountTap;


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RetailerRegistrationCubit(api),
      child: RetailerRegistrationScreenView(
        onRegistrationSuccess: onRegistrationSuccess,
        onCreateAccountTap: onCreateAccountTap,
      ),
    );
  }
}

@visibleForTesting
class RetailerRegistrationScreenView extends StatefulWidget {
  const RetailerRegistrationScreenView({
    super.key,
    required this.onRegistrationSuccess,
    required this.onCreateAccountTap,
  });

  final VoidCallback onRegistrationSuccess;
  final VoidCallback onCreateAccountTap;


  @override
  State<RetailerRegistrationScreenView> createState() =>
      _RetailerRegistrationScreenViewState();
}

class _RetailerRegistrationScreenViewState
    extends State<RetailerRegistrationScreenView> {
  final FocusNode _businessNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();

  static const _marketingText = 'Ready to grow your business? Join our marketplace and reach more customers than ever before. Register as a retailer today and start showcasing your products to a wider audience!';

  RetailerRegistrationCubit get _cubit =>
      context.read<RetailerRegistrationCubit>();

  @override
  void initState() {
    super.initState();
    _setupFocusNodes();
  }

  void _setupFocusNodes() {
    _businessNameFocusNode.addListener(() {
      if (!_businessNameFocusNode.hasFocus) _cubit.onBusinessNameUnfocused();
    });

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) _cubit.onEmailUnfocused();
    });

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) _cubit.onPasswordUnfocused();
    });

    _phoneNumberFocusNode.addListener(() {
      if (!_phoneNumberFocusNode.hasFocus) _cubit.onPhoneNumberUnfocused();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RetailerRegistrationCubit, RetailerRegistrationState>(
      listenWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus,
      listener: (context, state) {
        if (state.submissionStatus.isSuccess) {
          widget.onRegistrationSuccess();
          return;
        }

        if (state.submissionStatus == SubmissionStatus.genericError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Registration failed, please try again.'),
              ),
            );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                   Text(
                  'Create a Retailer saloneBazaar Account',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Spacing.height16,
                const Text(_marketingText),
                Spacing.height24,
                Spacing.height24,
                TextField(
                  focusNode: _businessNameFocusNode,
                  enabled: !state.submissionStatus.isInProgress,
                  onChanged: _cubit.onBusinessNameChanged,
                  decoration: InputDecoration(
                    labelText: 'BUSINESS NAME',
                    errorText: state.businessName.error?.message,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  focusNode: _phoneNumberFocusNode,
                  onChanged: _cubit.onPhoneNumberChanged,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.phone),
                    enabled: !state.submissionStatus.isInProgress,
                    labelText: 'PHONE NUMBER',
                    errorText: state.phoneNumber.error?.message,
                  ),
                ),
                const SizedBox(height: 16),
                EmailAndPasswordForm(
                  buttonLabel: 'Register Business',
                  emailFocusNode: _emailFocusNode,
                  passwordFocusNode: _passwordFocusNode,
                  onEmailChanged: _cubit.onEmailChanged,
                  onPasswordChanged: _cubit.onPasswordChanged,
                  emailFieldErrorText: state.email.error?.message,
                  passwordFieldErrorText: state.password.error?.message,
                  onEmailAndPasswordSubmit: _cubit.onSubmit,
                  isEmailAndPasswordSubmissionStatusInProgress:
                      state.submissionStatus.isInProgress,
                ),
                const SizedBox(height: 24),
             
             RowTextWithButton(text: 'Want to buy something?', buttonLabel: 'Create account.', onButtonTap: widget.onCreateAccountTap,)
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _businessNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }
}
