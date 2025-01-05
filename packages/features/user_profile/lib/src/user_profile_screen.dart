import 'package:bazaar_api/bazaar_api.dart';
import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

import 'user_profile_notifier.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({
    super.key,
    required this.api,
    required this.onAuthentionRequired,
    required this.onSignOutSuccess,
  });

  final BazaarApi api;
  final VoidCallback onSignOutSuccess;
  final VoidCallback onAuthentionRequired;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late final UserProfileNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = UserProfileNotifier(widget.api);

    _notifier.addListener(_listener);
  }

  void _listener() {
    switch (_notifier.submissionStatus) {
      case UserProfileSubmissionStatus.idle:
        return;

      case UserProfileSubmissionStatus.authenticationRequired:
        ScaffoldMessenger.of(context).showSnackBar(
          const AuthenticationRequiredErrorSnackBar(),
        );
        widget.onAuthentionRequired();

      case UserProfileSubmissionStatus.signoutSuccess:
        widget.onSignOutSuccess();
    }
  }

  @override
  void dispose() {
    _notifier.removeListener(_listener);
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: false,
        ),
        body: ListenableBuilder(
          listenable: _notifier,
          builder: (context, child) {
            return switch (_notifier.state) {
              UserProfileState.inprogress =>
                const CenteredCircularProgressIndicator(),
              UserProfileState.success => _User(_notifier),
              UserProfileState.error =>
                ExceptionIndicator(onTryAgain: _notifier.refetch),
            };
          },
        ),
      ),
    );
  }
}

class _User extends StatefulWidget {
  const _User(this.notifier);

  final UserProfileNotifier notifier;

  @override
  State<_User> createState() => _UserState();
}

class _UserState extends State<_User> {
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(
      text: widget.notifier.user?.displayName,
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const UserProfileImage(),
          const SizedBox(height: 48),
          EmailField(
            initialValue: widget.notifier.user?.email,
            enabled: false,
          ),
          UsernameField(
            controller: _usernameController,
          ),
          ExpandedElevatedButton(
            onTap: widget.notifier.signOut,
            label: 'Sign Out',
          ),
        ],
      ),
    );
  }
}
