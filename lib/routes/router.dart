import 'package:bazaar_api/bazaar_api.dart';
import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_list/order_list.dart';
import 'package:product_details/product_details.dart';
import 'package:product_list/product_list.dart';
import 'package:sign_in/sign_in.dart';
import 'package:sign_up/sign_up.dart';
import 'package:user_cart/user_cart.dart';
import 'package:user_profile/user_profile.dart';
import 'package:order_details/order_details.dart';
import 'package:user_repository/user_repository.dart';

part 'routes.dart';
part 'scaffold_with_navbar.dart';

final class AppRouter {
  const AppRouter() : _api = const BazaarApi();

  final BazaarApi _api;

  GoRouter get router {
    final route = Routes(api: _api, userRepository: UserRepository());
    return GoRouter(
      initialLocation: PathConstants.productListPath,
      routes: [
        ShellRoute(
            // bottom navigation route
            builder: (_, __, child) => _ScaffoldWithNavBar(child: child),
            routes: [
              route.productListRoute,
              route.userCartRoute,
              route.orderListRoute,
              route.userProfileRoute,
            ]),
        route.orderDetailsRoute,
        route.productDetailsRoute,
        route.signInRoute,
        route.signUpRoute,
        // add routes here
      ],
    );
  }
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
