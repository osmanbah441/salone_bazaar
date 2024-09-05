part of '../router.dart';

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
