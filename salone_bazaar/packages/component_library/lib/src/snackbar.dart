import 'package:flutter/material.dart';

class GenericErrorSnackBar extends SnackBar {
  const GenericErrorSnackBar({super.key})
      : super(
          content:
              const Center(child: Text('no connect to the internet exception')),
        );
}


class AuthenticationRequiredErrorSnackBar extends SnackBar {
   const AuthenticationRequiredErrorSnackBar({super.key})
      : super(
          content: const Text('authentication is requried error message'),
          duration: const Duration(seconds: 2),
        );
}

