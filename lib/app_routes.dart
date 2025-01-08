import 'package:cart_repository/cart_repository.dart';
import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_details/order_details.dart';
import 'package:order_repository/order_repository.dart';
import 'package:product_details/product_details.dart';
import 'package:product_repository/product_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:order_list/order_list.dart';
import 'package:product_list/product_list.dart';
import 'package:sign_in/sign_in.dart';
import 'package:sign_up/sign_up.dart';
import 'package:user_cart/user_cart.dart';
import 'package:user_profile/user_profile.dart';

class AppRoutes {
  const AppRoutes({
    this.userRepository = const UserRepository(),
    this.productsRepository = const ProductsRepository(),
    this.cartRepository = const CartRepository(),
    this.ordersRepository = const OrdersRepository(),
  });

  final UserRepository userRepository;
  final ProductsRepository productsRepository;
  final CartRepository cartRepository;
  final OrdersRepository ordersRepository;

  GoRoute get productDetailsRoute => GoRoute(
        path: PathConstants.productDetailsPath(),
        builder: (context, state) => ProductDetailsScreen(
          userRepository: userRepository,
          productRepository: productsRepository,
          cartRepository: cartRepository,
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
          ordersRepository: ordersRepository,
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
          productsRepository: productsRepository,
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
          ordersRepository: ordersRepository,
          userRepository: userRepository,
          cartRepository: cartRepository,
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
          ordersRepository: ordersRepository,
        ),
      );
}

abstract final class PathConstants {
  const PathConstants._();

  // params are used like http path-parameter
  static const productIdPathParameter = 'productId';
  static const orderIdPathParameter = 'orderId';

  // the product
  static String productListPath = '/products';
  static String productDetailsPath([String? productId]) =>
      '$productListPath/${productId ?? ":$productIdPathParameter"}';

  // user
  static String get signInPath => '/sign-in';
  static String get signUpPath => '/sign-up';
  static String get userProfilePath => '/user-profile';

  static String get cartPath => '/cart';

  static String get orderListPath => '/orders';
  static String orderDetailsPath([String? orderId]) =>
      '$orderListPath/${orderId ?? ":$orderIdPathParameter"}';
}

abstract class Redirect {
  static String? toSignIn(BuildContext context, UserRepository userRepository) {
    if (userRepository.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const AuthenticationRequiredErrorSnackBar(),
      );
      return PathConstants.signInPath;
    }
    return null;
  }
}
