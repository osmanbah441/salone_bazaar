import 'package:bazaar_api/bazaar_api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_list/product_list.dart';
import 'package:register_retailer/register_retailer.dart';
import 'package:sign_in/sign_in.dart';
import 'package:sign_up/sign_up.dart';

part 'path_constant.dart';

final class AppRouter {
  const AppRouter() : _api = const BazaarApi();

  final BazaarApi _api;

  GoRouter get router => GoRouter(
        initialLocation: _PathConstants.productListPath,
        routes: [
          _signInRoute,
          _signUpRoute,
          _regiserRetailerRoute,
          _productListRoute,
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
          onCreateRetailerAccount: () =>
              context.go(_PathConstants.registerRetailerPath),
          onSignUpSuccess: () => context.go(_PathConstants.productListPath),
          onSignInTap: () => context.go(_PathConstants.signInPath),
        ),
      );

  GoRoute get _regiserRetailerRoute => GoRoute(
        path: _PathConstants.registerRetailerPath,
        builder: (context, state) => RetailerRegistrationScreen(
          api: _api,
          onRegistrationSuccess: () {},
          onCreateAccountTap: () => context.go(_PathConstants.signUpPath),
        ),
      );

  GoRoute get _productListRoute => GoRoute(
      path: _PathConstants.productListPath,
      builder: (context, state) => ProductListScreen(
            api: _api,
          ));
}
