import 'package:bazaar_api/bazaar_api.dart';
import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:sign_in/src/sign_in_notifier.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
    required this.onSignInSuccess,
    required this.onSignUpTap,
    required this.onForgotPasswordTap,
    required this.api,
  });

  final VoidCallback onSignInSuccess;
  final VoidCallback onSignUpTap;
  final VoidCallback onForgotPasswordTap;
  final BazaarApi api;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final GlobalKey<FormState> _formKey;
  late final SignInNotifier _notifer;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _notifer = SignInNotifier(widget.api);
    _notifer.addListener(_listener);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _notifer.removeListener(_listener);
    _notifer.dispose();
    super.dispose();
  }

  void _listener() {
    if (_notifer.submissionStatus.isSuccess) {
      widget.onSignInSuccess();
      return;
    }
    if (_notifer.submissionStatus.hasError) {
      final message = _notifer.submissionStatus.isInvalidCredentialsError
          ? "invalid email or password"
          : _notifer.submissionStatus.isGoogleSignError
              ? "google login failed"
              : 'no connect to the internet exception';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListenableBuilder(
            listenable: _notifer,
            builder: (context, child) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 16,
              children: [
                Text(
                  'Sign in to saloneBazaar',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Spacing.height24,
                ExpandedElevatedButton.google(
                  onTap: !_notifer.submissionStatus.isInProgress
                      ? _notifer.continueWithGoogle
                      : null,
                ),
                const Text('or'),
                EmailField(
                  controller: _emailController,
                  enabled: !_notifer.submissionStatus.isInProgress,
                ),
                PasswordField(
                  controller: _passwordController,
                  enabled: !_notifer.submissionStatus.isInProgress,
                ),
                (_notifer.submissionStatus.isInProgress)
                    ? ExpandedElevatedButton.inProgress(label: 'Loading')
                    : ExpandedElevatedButton(
                        icon: const Icon(Icons.login),
                        label: 'Submit',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _notifer.loginWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                          }
                        },
                      ),
                BazaarTextButton(
                  onTap: _notifer.submissionStatus.isInProgress
                      ? null
                      : widget.onForgotPasswordTap,
                  label: 'Reset password',
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No account yet?'),
                    BazaarTextButton(
                      onTap: _notifer.submissionStatus.isInProgress
                          ? null
                          : widget.onSignUpTap,
                      label: "create account",
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
