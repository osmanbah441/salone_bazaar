part of '../router.dart';

List<GoRoute> productRoutes(BazaarApi api) => [
      GoRoute(
        path: PathConstants.productDetailsPath(),
        builder: (context, state) => ProductDetailsScreen(
          api: api,
          onBackButtonTap: () => context.go(PathConstants.productListPath),
          productId:
              state.pathParameters[PathConstants.productIdPathParameter]!,
          onItemAddedToCart: () => context.go(PathConstants.cartPath),
          onAuthenticationRequired: () {},
        ),
      ),

      GoRoute(
        path: PathConstants.productAddPath,
        builder: (context, state) => AddProductScreen(
          api: api,
          onAddAddProductSuccess: () {},
        ),
      )
      // Add more
    ];
