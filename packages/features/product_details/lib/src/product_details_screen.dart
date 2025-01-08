import 'package:cart_repository/cart_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:component_library/component_library.dart';
import 'package:product_repository/product_repository.dart';
import 'package:user_repository/user_repository.dart';

import 'product_details_cubit.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
    super.key,
    required this.productId,
    required this.userRepository,
    required this.onBackButtonTap,
    required this.onItemAddedToCart,
    required this.onAuthenticationRequired,
    required this.productRepository,
    required this.cartRepository,
  });

  final String productId;
  final UserRepository userRepository;
  final VoidCallback onBackButtonTap;
  final ProductsRepository productRepository;
  final VoidCallback onItemAddedToCart;
  final VoidCallback onAuthenticationRequired;
  final CartRepository cartRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductDetailsCubit>(
      create: (_) => ProductDetailsCubit(
        productId: productId,
        productRepository: productRepository,
        cartRepository: cartRepository,
        userRepository: userRepository,
      ),
      child: ProductDetailsView(
        onBackButtonTap: onBackButtonTap,
        onAuthenticationRequired: onAuthenticationRequired,
        onItemAddedToCart: onItemAddedToCart,
      ),
    );
  }
}

@visibleForTesting
class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({
    super.key,
    required this.onBackButtonTap,
    required this.onAuthenticationRequired,
    required this.onItemAddedToCart,
  });

  final VoidCallback onBackButtonTap;
  final VoidCallback onItemAddedToCart;
  final VoidCallback onAuthenticationRequired;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
      listener: (context, state) {
        final productCartError =
            state is ProductDetailsSuccess ? state.productCartError : null;

        if (productCartError != null) {
          final snackBar =
              productCartError is UserAuthenticationRequiredException
                  ? const AuthenticationRequiredErrorSnackBar()
                  : const GenericErrorSnackBar();

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);

          onAuthenticationRequired();
        }

        if (state is ProductDetailsSuccess && state.isAddedToCartSuccessful) {
          onItemAddedToCart();
        }
      },
      builder: (context, state) {
        final cubit = context.read<ProductDetailsCubit>();

        final isSuccessState = state is ProductDetailsSuccess;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: isSuccessState
              ? AppBar(
                  foregroundColor: Colors.white,
                  leading: BackButton(onPressed: onBackButtonTap),
                  backgroundColor: Colors.transparent,
                )
              : null,
          body: switch (state) {
            ProductDetailsInProgress() =>
              const CenteredCircularProgressIndicator(),
            ProductDetailsSuccess() => _Product(product: state.product),
            ProductDetailsFailure() => ExceptionIndicator(
                onTryAgain: () {
                  cubit.refetch();
                },
              ),
          },
          floatingActionButtonLocation:
              isSuccessState ? FloatingActionButtonLocation.centerFloat : null,
          floatingActionButton: isSuccessState
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: state.isAddToCartLoading
                      ? ExpandedElevatedButton.inProgress(label: 'Loading')
                      : ExpandedElevatedButton(
                          icon: const Icon(Icons.shopping_cart),
                          label: 'Add to Cart',
                          onTap: () => cubit.addProductToCart(state.product),
                        ),
                )
              : null,
        );
      },
    );
  }
}

class _Product extends StatelessWidget {
  const _Product({
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            height: 350,
            width: double.infinity,
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            title: Text(
              product.name,
              style: textTheme.titleMedium,
            ),
            trailing: Text(
              product.price.toStringAsFixed(2),
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.description,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
