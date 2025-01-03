part of 'router.dart';

List<GoRoute> registrationRoutes(BazaarApi api) => [
      GoRoute(
        // sign in
        path: PathConstants.signInPath,
        builder: (context, state) => SignInScreen(
          api: api,
          onSignInSuccess: () => context.go(PathConstants.productListPath),
          onSignUpTap: () => context.go(PathConstants.signUpPath),
          onForgotPasswordTap: () => showDialog(
            context: context,
            builder: (context) => ForgotMyPasswordDialog(
              api: api,
            ),
          ),
        ),
      ),
      GoRoute(
        // sign  up
        path: PathConstants.signUpPath,
        builder: (context, state) => SignUpScreen(
          api: api,
          onSignUpSuccess: () => context.go(PathConstants.productListPath),
          onSignInTap: () => context.go(PathConstants.signInPath),
        ),
      ),
    ];
