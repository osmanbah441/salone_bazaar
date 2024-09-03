import 'dart:async';

import 'package:bazaar_api/bazaar_api.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

final class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc({
    required BazaarApi api,
  })  : _api = api,
        super(const ProductListState()) {
    _registerEventHandlers();

    add(const ProductFirstPageRequested());
  }

  final BazaarApi _api;

  void _registerEventHandlers() => on<ProductListEvent>(
        (event, emitter) async => switch (event) {
          ProductListTagChanged() =>
            _handleProductListTagChanged(emitter, event),
          ProductListSearchTermChanged() =>
            _handleProductListSearchTermChanged(emitter, event),
          ProductListRefreshed() => _handleProductListRefreshed(emitter, event),
          ProductListNextPageRequested() =>
            _handleProductListNextPageRequested(emitter, event),
          ProductListFailedFetchRetried() =>
            _handleProductListFailedFetchRetried(emitter),
          ProductFirstPageRequested() =>
            _handleProductListUsernameObtained(emitter),
        },
        transformer: (eventStream, eventHandler) {
          final nonDebounceEventStream = eventStream.where(
            (event) => event is! ProductListSearchTermChanged,
          );

          final debounceEventStream = eventStream
              .whereType<ProductListSearchTermChanged>()
              .debounceTime(const Duration(seconds: 1))
              .where((event) {
            final previousFilter = state.filter;
            final previousSearchTerm =
                previousFilter is ProductListFilterBySearchTerm
                    ? previousFilter.searchTerm
                    : '';

            return event.searchTerm != previousSearchTerm;
          });

          final mergedEventStream = MergeStream([
            nonDebounceEventStream,
            debounceEventStream,
          ]);

          final restartableTransformer = restartable<ProductListEvent>();
          return restartableTransformer(mergedEventStream, eventHandler);
        },
      );

  Future<void> _handleProductListFailedFetchRetried(Emitter emitter) {
    emitter(state.copyWithNewError(null));
    final firstPageFetchStream = _fetchProductPage(1);

    return emitter.onEach<ProductListState>(
      firstPageFetchStream.asStream(),
      onData: emitter.call,
    );
  }

  Future<void> _handleProductListUsernameObtained(Emitter emitter) {
    emitter(ProductListState(filter: state.filter));

    final firstPageFetchStream = _fetchProductPage(1);

    return emitter.onEach<ProductListState>(
      firstPageFetchStream.asStream(),
      onData: emitter.call,
    );
  }

  Future<void> _handleProductListTagChanged(
    Emitter emitter,
    ProductListTagChanged event,
  ) {
    emitter(
      ProductListState.loadingNewTag(event.tag),
    );

    final firstPageFetchStream = _fetchProductPage(
      1,
    );

    return emitter.onEach<ProductListState>(
      firstPageFetchStream.asStream(),
      onData: emitter.call,
    );
  }

  Future<void> _handleProductListSearchTermChanged(
    Emitter emitter,
    ProductListSearchTermChanged event,
  ) {
    emitter(ProductListState.loadingNewSearchTerm(event.searchTerm));

    final firstPageFetchStream = _fetchProductPage(
      1,
    );

    return emitter.onEach<ProductListState>(
      firstPageFetchStream.asStream(),
      onData: emitter.call,
    );
  }

  Future<void> _handleProductListRefreshed(
    Emitter emitter,
    ProductListRefreshed event,
  ) {
    final firstPageFetchStream = _fetchProductPage(
      1,
      isRefresh: true,
    );

    return emitter.onEach<ProductListState>(
      firstPageFetchStream.asStream(),
      onData: emitter.call,
    );
  }

  Future<void> _handleProductListNextPageRequested(
    Emitter emitter,
    ProductListNextPageRequested event,
  ) {
    emitter(
      state.copyWithNewError(null),
    );

    final nextPageFetchStream = _fetchProductPage(
      event.pageNumber,
    );

    return emitter.onEach<ProductListState>(
      nextPageFetchStream.asStream(),
      onData: emitter.call,
    );
  }

  Future<ProductListState> _fetchProductPage(
    int page, {
    bool isRefresh = false,
  }) async {
    final currentlyAppliedFilter = state.filter;

    try {
      final newPage = await _api.product.getProductListPage(
        page: page,
        category: currentlyAppliedFilter is ProductListFilterByCategory
            ? currentlyAppliedFilter.category.name
            : ProductCategory.all.name,
        searchTerm: currentlyAppliedFilter is ProductListFilterBySearchTerm
            ? currentlyAppliedFilter.searchTerm
            : '',
      );

      final newItemList = newPage.productList;
      final oldItemList = state.itemList ?? [];
      final completeItemList =
          isRefresh || page == 1 ? newItemList : (oldItemList + newItemList);

      final nextPage = newPage.isLastPage ? null : page + 1;

      return ProductListState.success(
        nextPage: nextPage,
        itemList: completeItemList,
        filter: currentlyAppliedFilter,
        isRefresh: isRefresh,
      );
    } catch (error) {
      if (error is EmptySearchResultException) {
        return ProductListState.noItemsFound(
          currentlyAppliedFilter,
        );
      }

      if (isRefresh) {
        return state.copyWithNewRefreshError(
          error,
        );
      } else {
        return state.copyWithNewError(
          error,
        );
      }
    }
  }
}
