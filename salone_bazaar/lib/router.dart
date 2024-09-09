import 'package:bazaar_api/bazaar_api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_list/order_list.dart';
import 'package:product_details/product_details.dart';
import 'package:product_list/product_list.dart';
import 'package:register_retailer/register_retailer.dart';
import 'package:sign_in/sign_in.dart';
import 'package:sign_up/sign_up.dart';
import 'package:user_cart/user_cart.dart';
import 'package:user_profile/user_profile.dart';
import 'package:add_product/add_product.dart';

part 'routes/product_routes.dart';
part 'routes/bottom_nav_routes.dart';
part 'routes/users.dart';

final class AppRouter {
  const AppRouter() : _api = const BazaarApi();

  final BazaarApi _api;

  GoRouter get router => GoRouter(
        initialLocation: PathConstants.signInPath,
        routes: [
          bottomNavRoute(_api),
          ...registrationRoutes(_api),
          ...productRoutes(_api),
        ],
      );
}

abstract final class PathConstants {
  const PathConstants._();

  // params are used like http path-parameter
  static const productIdPathParameter = 'productId';

  // the product
  static String productListPath = '/products';
  static const productAddPath = '/product-add';
  static String productDetailsPath([String? productId]) =>
      '$productListPath/${productId ?? ":$productIdPathParameter"}';

  // user
  static String get signInPath => '/sign-in';
  static String get signUpPath => '/sign-up';
  static String get registerRetailerPath => '/register-retailer';
  static String get userProfilePath => '/user-profile';

  static String get cartPath => '/cart';

  static String get orderListPath => '/orders';
}
