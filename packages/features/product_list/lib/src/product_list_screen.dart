import 'package:bazaar_api/bazaar_api.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:product_list/src/backdrop.dart';
import 'package:product_list/src/category_menu_page.dart';

import 'product_list_bloc.dart';
import 'product_page_grid_view.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({
    super.key,
    required this.onProductSelected,
    required this.api,
  });

  final Function(String) onProductSelected;

  final BazaarApi api;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductListBloc>(
      create: (_) => ProductListBloc(api: api),
      child: ProductListView(
        onProductSelected: onProductSelected,
      ),
    );
  }
}

@visibleForTesting
class ProductListView extends StatefulWidget {
  const ProductListView({
    super.key,
    required this.onProductSelected,
  });

  final Function(String) onProductSelected;

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final _pagingController = PagingController<int, Product>(
    firstPageKey: 1,
  );

  final TextEditingController _searchBarController = TextEditingController();

  ProductListBloc get _bloc => context.read<ProductListBloc>();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageNumber) {
      if (pageNumber > 1) _bloc.add(ProductListNextPageRequested(pageNumber));
    });

    _searchBarController.addListener(() {
      _bloc.add(ProductListSearchTermChanged(_searchBarController.text));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductListBloc, ProductListState>(
      listener: (context, state) {
        final searchBarText = _searchBarController.text;
        final isSearching = state.filter != null &&
            state.filter is ProductListFilterBySearchTerm;
        if (searchBarText.isNotEmpty && !isSearching) {
          _searchBarController.text = '';
        }

        if (state.refreshError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('refresh errror text message')),
          );
        }

        _pagingController.value = state.toPagingState();
      },
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            _bloc.add(const ProductListRefreshed());

            final stateChangeFuture = _bloc.stream.first;
            return stateChangeFuture;
          },
          child: BlocBuilder<ProductListBloc, ProductListState>(
            builder: (context, state) {
              final currentlyAppliedFilter = state.filter;

              return Backdrop(
                currentCategory:
                    currentlyAppliedFilter is ProductListFilterByCategory
                        ? currentlyAppliedFilter.category
                        : ProductCategory.all,
                frontLayer: ProductPagedGridView(
                  pagingController: _pagingController,
                  onProductSelected: widget.onProductSelected,
                ),
                backLayer: const CategoryMenuPage(),
                frontTitle: const Text('SaloneBazaar'),
                backTitle: const Text('Fliter Items'),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchBarController.dispose();
    super.dispose();
  }
}

extension on ProductListState {
  PagingState<int, Product> toPagingState() {
    return PagingState(
      itemList: itemList,
      nextPageKey: nextPage,
      error: error,
    );
  }
}
