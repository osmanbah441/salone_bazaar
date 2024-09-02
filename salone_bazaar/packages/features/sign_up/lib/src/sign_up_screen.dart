import 'package:bazaar_api/bazaar_api.dart';
import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sign_up_cubit.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({
    super.key,
    required this.api,
    required this.onSignUpSuccess,
    required this.onSignInTap,
    required this.onCreateRetailerAccount,
  });

  final BazaarApi api;
  final VoidCallback onSignUpSuccess;
  final VoidCallback onSignInTap;
  final VoidCallback onCreateRetailerAccount;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(api),
      child: SignUpScreenView(
        onCreateRetailerAccount: onCreateRetailerAccount,
        onSignUpSuccess: onSignUpSuccess,
        onSignInTap: onSignInTap,
      ),
    );
  }
}

@visibleForTesting
class SignUpScreenView extends StatefulWidget {
  const SignUpScreenView({
    super.key,
    required this.onSignUpSuccess,
    required this.onSignInTap,
    required this.onCreateRetailerAccount,
  });

  final VoidCallback onSignUpSuccess;
  final VoidCallback onSignInTap;
  final VoidCallback onCreateRetailerAccount;

  @override
  State<SignUpScreenView> createState() => _SignUpScreenViewState();
}

class _SignUpScreenViewState extends State<SignUpScreenView> {
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  SignUpCubit get _cubit => context.read<SignUpCubit>();

  @override
  void initState() {
    super.initState();
    _setupPasswordFocusNode();
    _setupEmailFocusNode();
  }

  void _setupEmailFocusNode() => _emailFocusNode.addListener(() {
        if (!_emailFocusNode.hasFocus) {
          _cubit.onEmailUnfocused();
        }
      });

  void _setupPasswordFocusNode() => _passwordFocusNode.addListener(() {
        if (!_passwordFocusNode.hasFocus) {
          _cubit.onPasswordUnfocused();
        }
      });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listenWhen: (previous, current) =>
          previous.emailAndPasswordSubmissionStatus !=
          current.emailAndPasswordSubmissionStatus,
      listener: (context, state) {
        if (state.emailAndPasswordSubmissionStatus.isSuccess) {
          widget.onSignUpSuccess();
          return;
        }

        if (state.emailAndPasswordSubmissionStatus.hasSubmissionError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              state.emailAndPasswordSubmissionStatus.isInvalidCredentialsError
                  ? const SnackBar(
                      content: Text('invalid email or password'),
                    )
                  : const GenericErrorSnackBar(),
            );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Create a saloneBazaar Account',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Spacing.height24,
                ExpandedElevatedButton.google(
                  onTap: _cubit.signInWithGoogle,
                ),
                Spacing.height24,
                const Text('OR'),
                Spacing.height24,
                EmailAndPasswordForm(
                  buttonLabel: 'Create account',
                  emailFocusNode: _emailFocusNode,
                  passwordFocusNode: _passwordFocusNode,
                  onEmailChanged: _cubit.onEmailChanged,
                  onPasswordChanged: _cubit.onPasswordChanged,
                  emailFieldErrorText: state.email.error?.message,
                  passwordFieldErrorText: state.password.error?.message,
                  onEmailAndPasswordSubmit: _cubit.onSubmit,
                  isEmailAndPasswordSubmissionStatusInProgress:
                      state.emailAndPasswordSubmissionStatus.isInProgress,
                ),
                Spacing.height24,
                Spacing.height16,
                RowTextWithButton(
                  text: 'Already have an account?',
                  buttonLabel: 'Sign In',
                  onButtonTap: widget.onSignInTap,
                ),
                RowTextWithButton(
                  text: 'Are you a business owner?',
                  buttonLabel: 'Create an account',
                  onButtonTap: widget.onCreateRetailerAccount,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }
}
