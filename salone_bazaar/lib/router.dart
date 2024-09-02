import 'package:bazaar_api/bazaar_api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in/sign_in.dart';
import 'package:sign_up/sign_up.dart';

part 'path_constant.dart';

final class AppRouter {
  const AppRouter() : _api = const BazaarApi();

  final BazaarApi _api;

  GoRouter get router => GoRouter(
        initialLocation: _PathConstants.signUpPath,
        routes: [
          _signInRoute,
          _signUpRoute,
        ],
      );

  GoRoute get _signInRoute => GoRoute(
        path: _PathConstants.signInPath,
        builder: (context, state) => SignInScreen(
          api: _api,
          onSignInSuccess: () => context.go(_PathConstants.productListPath),
          onSignUpTap: () => context.go(_PathConstants.signUpPath),
          onForgotPasswordTap: () => showDialog(
            context: context,
            builder: (context) => ForgotMyPasswordDialog(
              api: _api,
            ),
          ),
        ),
      );

  GoRoute get _signUpRoute => GoRoute(
        path: _PathConstants.signUpPath,
        builder: (context, state) => SignUpScreen(
          api: _api,
          onCreateRetailerAccount: () {},
          onSignUpSuccess: () => context.go(_PathConstants.productListPath),
          onSignInTap: () => context.go(_PathConstants.signInPath),
        ),
      );
}
