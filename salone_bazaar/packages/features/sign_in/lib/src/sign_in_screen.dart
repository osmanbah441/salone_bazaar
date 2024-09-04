import 'package:bazaar_api/bazaar_api.dart';
import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sign_in_cubit.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({
    super.key,
    required this.api,
    required this.onSignInSuccess,
    required this.onSignUpTap,
    required this.onForgotPasswordTap,
  });

  final BazaarApi api;
  final VoidCallback onSignInSuccess;
  final VoidCallback onSignUpTap;
  final VoidCallback onForgotPasswordTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(api),
      child: SigninScreenView(
        onSignInSuccess: onSignInSuccess,
        onSignUpTap: onSignUpTap,
        onForgotPasswordTap: onForgotPasswordTap,
      ),
    );
  }
}

@visibleForTesting
class SigninScreenView extends StatefulWidget {
  const SigninScreenView({
    super.key,
    required this.onSignInSuccess,
    required this.onSignUpTap,
    required this.onForgotPasswordTap,
  });

  final VoidCallback onSignInSuccess;
  final VoidCallback onSignUpTap;
  final VoidCallback onForgotPasswordTap;

  @override
  State<SigninScreenView> createState() => _SigninScreenViewState();
}

class _SigninScreenViewState extends State<SigninScreenView> {
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  SignInCubit get _cubit => context.read<SignInCubit>();

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
    return BlocConsumer<SignInCubit, SignInState>(
      listenWhen: (previous, current) =>
          previous.emailAndPasswordSubmissionStatus !=
          current.emailAndPasswordSubmissionStatus,
      listener: (context, state) {
        if (state.emailAndPasswordSubmissionStatus.isSuccess) {
          widget.onSignInSuccess();
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
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacing.height80,
                    Text(
                      'Sign in to saloneBazaar',
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
                      buttonLabel: 'Sign in',
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
                        
            
                    Spacing.height8,
                    TextButton(
                      onPressed: state.emailAndPasswordSubmissionStatus.isInProgress
                          ? null
                          : widget.onForgotPasswordTap,
                      child: const Text('Reset password'),
                    ),
                    Spacing.height8,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No account yet?'),
                        TextButton(
                          onPressed: widget.onSignUpTap,
                          child: const Text("create account"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
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
