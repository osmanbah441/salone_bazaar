import 'package:flutter/material.dart';

class EmptyItemList extends StatelessWidget {
  const EmptyItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/empty_cart_list.png',
            package: 'component_library',
          ),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 80),
            Text(
              'Your cart is currently empty.',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const Text(
              "Don't miss out on amazing deals!",
            ),
            const Text('Browse our collection now.')
          ],
        ),
      ),
    );
  }
}
