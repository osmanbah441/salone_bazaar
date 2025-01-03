import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

class AccountTypeSelectionWidget extends StatelessWidget {
  const AccountTypeSelectionWidget({
    super.key,
    required this.onSelectBuyer,
    required this.onSelectSeller,
  });

  final VoidCallback onSelectBuyer;
  final VoidCallback onSelectSeller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Create a buyer or seller account today and experience the convenience of buying or selling anything you desire, whenever it suits you.',
          textAlign: TextAlign.center,
        ),
        Spacing.height24,
        TextButton(
          onPressed: onSelectBuyer,
          child: const Text('Create Buyer Account'),
        ),
        const Text('or'),
        ElevatedButton(
          onPressed: onSelectSeller,
          child: const Text('Create Seller Account'),
        ),
      ],
    );
  }
}
