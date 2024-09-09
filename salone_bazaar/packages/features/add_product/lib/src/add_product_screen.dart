import 'package:bazaar_api/bazaar_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_product_cubit.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({
    super.key,
    required this.api,
    required this.onAddAddProductSuccess,
  });

  final BazaarApi api;
  final VoidCallback onAddAddProductSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddProductCubit(api),
      child:
          AddProductScreenView(onAddAddProductSuccess: onAddAddProductSuccess),
    );
  }
}

@visibleForTesting
class AddProductScreenView extends StatefulWidget {
  const AddProductScreenView({
    super.key,
    required this.onAddAddProductSuccess,
  });

  final VoidCallback onAddAddProductSuccess;

  @override
  State<AddProductScreenView> createState() => _AddProductScreenViewState();
}

class _AddProductScreenViewState extends State<AddProductScreenView> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _imageFocusNode = FocusNode();

  AddProductCubit get _cubit => context.read<AddProductCubit>();

  @override
  void initState() {
    super.initState();
    _setupFocusNodes();
  }

  void _setupFocusNodes() {
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) _cubit.onProductNameUnfocused();
    });
    _descriptionFocusNode.addListener(() {
      if (!_descriptionFocusNode.hasFocus) {
        _cubit.onProductDescriptionUnfocused();
      }
    });
    _priceFocusNode.addListener(() {
      if (!_priceFocusNode.hasFocus) _cubit.onProductPriceUnfocused();
    });
    _imageFocusNode.addListener(() {
      if (!_imageFocusNode.hasFocus) _cubit.onProductImageUnfocused();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddProductCubit, AddProductState>(
      listener: (context, state) {
        if (state.submissionStatus.isSuccess) {
          widget.onAddAddProductSuccess();
        } else if (state.submissionStatus == SubmissionStatus.genericError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Failed to add product')));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  focusNode: _nameFocusNode,
                  onChanged: _cubit.onProductNameChanged,
                  decoration:
                      const InputDecoration(labelText: 'AddProduct Name'),
                ),
                TextField(
                  focusNode: _descriptionFocusNode,
                  onChanged: _cubit.onProductDescriptionChanged,
                  decoration: const InputDecoration(
                      labelText: 'AddProduct Description'),
                ),
                TextField(
                  focusNode: _priceFocusNode,
                  onChanged: _cubit.onProductPriceChanged,
                  decoration:
                      const InputDecoration(labelText: 'AddProduct Price'),
                ),
                // TODO: add image.
                ElevatedButton(
                  onPressed: state.submissionStatus.isInProgress
                      ? null
                      : _cubit.onSubmit,
                  child: const Text('Add AddProduct'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }
}
