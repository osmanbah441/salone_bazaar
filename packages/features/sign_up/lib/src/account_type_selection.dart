import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:sign_up/src/sign_up_notifier.dart';

class AccountTypeSelection extends StatelessWidget {
  const AccountTypeSelection({
    super.key,
    required SignUpNotifier notifier,
  }) : _notifier = notifier;

  final SignUpNotifier _notifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        const Text(
          'Create a buyer or seller account today and experience the convenience of buying or selling anything you desire, whenever it suits you.',
          textAlign: TextAlign.center,
        ),
        Spacing.height24,
        ExpandedElevatedButton(
          onTap: () => _notifier.selectAccountType(AccountType.buyer),
          label: 'Create Buyer Account',
        ),
        const Text('or'),
        ExpandedElevatedButton(
          onTap: () => _notifier.selectAccountType(AccountType.seller),
          label: 'Create Seller Account',
        ),
      ],
    );
  }
}
