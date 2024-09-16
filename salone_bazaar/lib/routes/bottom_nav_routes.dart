part of 'router.dart';

ShellRoute bottomNavRoute(BazaarApi api) => ShellRoute(
      // bottom navigation route
      builder: (context, state, child) => _ScaffoldWithNavBar(
        child: child,
      ),
      routes: [
        GoRoute(
          // product list
          path: PathConstants.productListPath,
          builder: (context, state) => ProductListScreen(
            onProductSelected: (id) =>
                context.go(PathConstants.productDetailsPath(id)),
            api: api,
          ),
        ),
        GoRoute(
            // user profile
            redirect: (context, state) => Redirect.toSignIn(context, api),
            path: PathConstants.userProfilePath,
            builder: (context, state) => UserProfileScreen(
                  onSignOutSuccess: () => context.go(PathConstants.signInPath),
                  api: api,
                )),
        GoRoute(
          // cart
          redirect: (context, state) => Redirect.toSignIn(context, api),
          path: PathConstants.cartPath,
          builder: (context, state) => UserCartScreen(
            api: api,
            onItemTap: (id) => context.go(
              PathConstants.productDetailsPath(id),
            ),
          ),
        ),
        GoRoute(
          //  orders
          redirect: (context, state) => Redirect.toSignIn(context, api),
          path: PathConstants.orderListPath,
          builder: (context, state) => OrderListScreen(
            onOrderSelected: (id) => context.go(
              PathConstants.orderDetailsPath(id),
            ),
            api: api,
          ),
        ),
      ],
    );

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class _ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [_ScaffoldWithNavBar].
  const _ScaffoldWithNavBar({required this.child});

  /// The widget to display in the body of the Scaffold.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        animationDuration: const Duration(seconds: 2),
        elevation: 4,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.explore_outlined), label: 'shop'),
          NavigationDestination(
              icon: Icon(Icons.shopping_basket_outlined), label: 'cart'),
          NavigationDestination(icon: Icon(Icons.history), label: 'orders'),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: 'profile'),
        ],
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location == PathConstants.productListPath) return 0;
    if (location == PathConstants.cartPath) return 1;
    if (location == PathConstants.orderListPath) return 2;
    if (location == PathConstants.userProfilePath) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    if (index == 0) context.go(PathConstants.productListPath);
    if (index == 1) context.go(PathConstants.cartPath);
    if (index == 2) context.go(PathConstants.orderListPath);
    if (index == 3) context.go(PathConstants.userProfilePath);
  }
}
