part of 'router.dart';

List<GoRoute> productRoutes(BazaarApi api) => [
      GoRoute(
        path: PathConstants.productDetailsPath(),
        builder: (context, state) => ProductDetailsScreen(
          api: api,
          onBackButtonTap: () => context.go(PathConstants.productListPath),
          productId:
              state.pathParameters[PathConstants.productIdPathParameter]!,
          onItemAddedToCart: () => context.go(PathConstants.cartPath),
          onAuthenticationRequired: () => context.go(PathConstants.signInPath),
        ),
      ),
    ];

List<GoRoute> orderRoutes(BazaarApi api) => [
      GoRoute(
        path: PathConstants.orderDetailsPath(),
        // redirect: ,
        builder: (context, state) => OrderDetailsScreen(
          orderId: state.pathParameters[PathConstants.orderIdPathParameter]!,
          api: api,
          onBackButtonTap: () => context.go(PathConstants.orderListPath),
        ),
      ),
    ];
