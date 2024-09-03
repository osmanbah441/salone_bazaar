import 'package:bazaar_api/bazaar_api.dart';
import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key, required this.api});

  final BazaarApi api;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('product list screen'),
      ),
    );
  }
}
