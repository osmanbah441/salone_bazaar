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
          onCreateRetailerAccount: () =>
              context.go(PathConstants.registerRetailerPath),
          onSignUpSuccess: () => context.go(PathConstants.productListPath),
          onSignInTap: () => context.go(PathConstants.signInPath),
        ),
      ),
      GoRoute(
        // register retailer
        path: PathConstants.registerRetailerPath,
        builder: (context, state) => RetailerRegistrationScreen(
          api: api,
          onRegistrationSuccess: () {},
          onCreateAccountTap: () => context.go(PathConstants.signUpPath),
          onSignInTap: () => context.go(PathConstants.signInPath),
        ),
      ),
    ];
