part of 'router.dart';

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.child,
    super.key,
  });

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
          NavigationDestination(icon: Icon(Icons.explore_outlined), label: 'shop'),
          NavigationDestination(icon: Icon(Icons.shopping_basket_outlined), label: 'cart'),
          NavigationDestination(icon: Icon(Icons.history), label: 'orders'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'profile'),
        ],
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location == _PathConstants.productListPath) return 0;
    if (location == _PathConstants.cartPath) return 1;
    if (location == _PathConstants.ordersPath) return 2;
    if (location == _PathConstants.userProfilePath) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    if (index == 0) context.go(_PathConstants.productListPath);
    if (index == 1) context.go(_PathConstants.cartPath);
    if (index == 2) context.go(_PathConstants.ordersPath);
    if (index == 3) context.go(_PathConstants.userProfilePath);
  }
}