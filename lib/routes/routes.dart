part of 'router.dart';

class Routes {
  const Routes({
    required this.api,
    required this.userRepository,
  });
  final BazaarApi api;
  final UserRepository userRepository;

  GoRoute get productDetailsRoute => GoRoute(
        path: PathConstants.productDetailsPath(),
        builder: (context, state) => ProductDetailsScreen(
          api: api,
          onBackButtonTap: () => context.go(PathConstants.productListPath),
          productId:
              state.pathParameters[PathConstants.productIdPathParameter]!,
          onItemAddedToCart: () => context.go(PathConstants.cartPath),
          onAuthenticationRequired: () => context.go(PathConstants.signInPath),
        ),
      );

  GoRoute get orderDetailsRoute => GoRoute(
        path: PathConstants.orderDetailsPath(),
        builder: (context, state) => OrderDetailsScreen(
          orderId: state.pathParameters[PathConstants.orderIdPathParameter]!,
          userRepository: userRepository,
          api: api,
          onBackButtonTap: () => context.go(PathConstants.orderListPath),
        ),
      );

  GoRoute get signInRoute => GoRoute(
        path: PathConstants.signInPath,
        builder: (context, state) => SignInScreen(
          userRepository: userRepository,
          onSignInSuccess: () => context.go(PathConstants.productListPath),
          onSignUpTap: () => context.go(PathConstants.signUpPath),
          onForgotPasswordTap: () => showDialog(
            context: context,
            builder: (context) => ForgotMyPasswordDialog(
              userRepository: userRepository,
            ),
          ),
        ),
      );

  GoRoute get signUpRoute => GoRoute(
        path: PathConstants.signUpPath,
        builder: (context, state) => SignUpScreen(
          userRepository: userRepository,
          onSignUpSuccess: () => context.go(PathConstants.productListPath),
          onSignInTap: () => context.go(PathConstants.signInPath),
        ),
      );

  GoRoute get productListRoute => GoRoute(
        // product list
        path: PathConstants.productListPath,
        builder: (context, state) => ProductListScreen(
          onProductSelected: (id) =>
              context.go(PathConstants.productDetailsPath(id)),
          api: api,
        ),
      );

  GoRoute get userProfileRoute => GoRoute(
      // user profile
      redirect: (context, state) => Redirect.toSignIn(context, userRepository),
      path: PathConstants.userProfilePath,
      builder: (context, state) => UserProfileScreen(
            onAuthentionRequired: () => context.go(PathConstants.signInPath),
            onSignOutSuccess: () => context.go(PathConstants.signInPath),
            userRepository: userRepository,
          ));

  GoRoute get userCartRoute => GoRoute(
        // cart
        redirect: (context, state) =>
            Redirect.toSignIn(context, userRepository),
        path: PathConstants.cartPath,
        builder: (context, state) => UserCartScreen(
          userRepository: userRepository,
          api: api,
          onItemTap: (id) => context.go(
            PathConstants.productDetailsPath(id),
          ),
        ),
      );

  GoRoute get orderListRoute => GoRoute(
        //  orders
        redirect: (context, state) =>
            Redirect.toSignIn(context, userRepository),
        path: PathConstants.orderListPath,
        builder: (context, state) => OrderListScreen(
          userRepository: userRepository,
          onOrderSelected: (id) => context.go(
            PathConstants.orderDetailsPath(id),
          ),
          api: api,
        ),
      );
}
