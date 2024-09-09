import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_list_bloc.dart';

class CategoryMenuPage extends StatelessWidget {
  const CategoryMenuPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListBloc, ProductListState>(
      builder: (context, state) {
        final selectedCategory = (state.filter is ProductListFilterByCategory)
            ? (state.filter as ProductListFilterByCategory).category
            : null;

        return Center(
          child: Container(
            padding: const EdgeInsets.only(top: 40.0),
            color: Theme.of(context).colorScheme.primary,
            child: ListView(
              children: ProductCategory.values
                  .map((category) => _BuildCategory(
                        category: category,
                        context: context,
                        selectedCategory: selectedCategory,
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}

class _BuildCategory extends StatelessWidget {
  const _BuildCategory({
    required this.category,
    required this.context,
    required this.selectedCategory,
  });

  final ProductCategory category;
  final BuildContext context;
  final ProductCategory? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final categoryString = category.name.toUpperCase();
    final ThemeData theme = Theme.of(context);
    final isSelected = selectedCategory == category;

    return GestureDetector(
      onTap: () {
        _releaseFocus(context);
        final bloc = context.read<ProductListBloc>();
        bloc.add(ProductListTagChanged(isSelected ? null : category));
      },
      child: isSelected
          ? Column(
              children: <Widget>[
                const SizedBox(height: 16.0),
                Text(
                  categoryString,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14.0),
                Container(
                  width: 70.0,
                  height: 2.0,
                  color: theme.colorScheme.primaryContainer,
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                categoryString,
                textAlign: TextAlign.center,
              ),
            ),
    );
  }
}

void _releaseFocus(BuildContext context) {
  FocusScope.of(context).unfocus();
}
