import 'package:bazaar_api/bazaar_api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_details/product_details.dart';
import 'package:product_list/product_list.dart';
import 'package:register_retailer/register_retailer.dart';
import 'package:sign_in/sign_in.dart';
import 'package:sign_up/sign_up.dart';
import 'package:user_cart/user_cart.dart';

part 'path_constant.dart';
part 'scaffold_with_nav_bar.dart';

final class AppRouter {
  const AppRouter() : _api = const BazaarApi();

  final BazaarApi _api;

  GoRouter get router => GoRouter(
        initialLocation: _PathConstants.productListPath,
        routes: [
          GoRoute(
            // sign in
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
          ),
          GoRoute(
            // sign  up
            path: _PathConstants.signUpPath,
            builder: (context, state) => SignUpScreen(
              api: _api,
              onCreateRetailerAccount: () =>
                  context.go(_PathConstants.registerRetailerPath),
              onSignUpSuccess: () => context.go(_PathConstants.productListPath),
              onSignInTap: () => context.go(_PathConstants.signInPath),
            ),
          ),
          GoRoute(
            // register retailer
            path: _PathConstants.registerRetailerPath,
            builder: (context, state) => RetailerRegistrationScreen(
              api: _api,
              onRegistrationSuccess: () {},
              onCreateAccountTap: () => context.go(_PathConstants.signUpPath),
              onSignInTap: () => context.go(_PathConstants.signInPath),
            ),
          ),
          GoRoute(
            path: _PathConstants.productDetailsPath(),
            builder: (context, state) => ProductDetailsScreen(
              api: _api,
              onBackButtonTap: () => context.go(_PathConstants.productListPath),
              productId:
                  state.pathParameters[_PathConstants._productIdPathParameter]!,
              onItemAddedToCart: () => context.go(_PathConstants.cartPath),
              onAuthenticationRequired: () {},
            ),
          ),
          ShellRoute(
            // bottom navigation route
            builder: (context, state, child) => ScaffoldWithNavBar(
              child: child,
            ),
            routes: [
              GoRoute(
                // product list
                path: _PathConstants.productListPath,
                builder: (context, state) => ProductListScreen(
                  onProductSelected: (id) =>
                      context.go(_PathConstants.productDetailsPath(id)),
                  api: _api,
                ),
              ),
              GoRoute(
                  // user profile
                  path: _PathConstants.userProfilePath,
                  builder: (context, state) => const UserProfileScreen()),
              GoRoute(
                // cart
                path: _PathConstants.cartPath,
                builder: (context, state) => UserCartScreen(
                  api: _api,
                  onItemTap: (id) =>
                      context.go(_PathConstants.productDetailsPath(id)),
                ),
              ),
              GoRoute(
                  //  orders
                  path: _PathConstants.ordersPath,
                  builder: (context, state) => const OrdersScreen()),
            ],
          ),
        ],
      );
}

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User')),
      body: const Center(child: Text('User screen')),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: const Center(child: Text('Orders screen')),
    );
  }
}
