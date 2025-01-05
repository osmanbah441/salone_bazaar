import 'package:bazaar_api/bazaar_api.dart';
import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_profile_cubit.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen(
      {super.key, required this.api, required this.onSignOutSuccess});

  final BazaarApi api;
  final VoidCallback onSignOutSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UserProfileCubit(api: api),
        child: UserProfileView(
          onSignOutSuccess: onSignOutSuccess,
        ));
  }
}

@visibleForTesting
class UserProfileView extends StatelessWidget {
  const UserProfileView({
    super.key,
    required this.onSignOutSuccess,
  });

  final VoidCallback onSignOutSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileCubit, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileStateSuccess && state.isSignOutSuccess) {
          onSignOutSuccess();
        }
      },
      builder: (context, state) => switch (state) {
        UserProfileStateSuccess() => _User(
            username: state.username.value,
            email: state.email,
            photoUrl: state.photoUrl,
          ),
        UserProfileStateLoading() => const CenteredCircularProgressIndicator(),
        UserProfileStateFailure() => ExceptionIndicator(
            onTryAgain: () => context.read<UserProfileCubit>().refetch()),
      },
    );
  }
}

class _User extends StatefulWidget {
  const _User({required this.username, required this.email, this.photoUrl});
  final String username;
  final String email;
  final String? photoUrl;

  @override
  State<_User> createState() => _UserState();
}

class _UserState extends State<_User> {
  late TextEditingController _usernameController;
  final _usernameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);
    _setUsernameFocusNode();
  }

  void _setUsernameFocusNode() {
    _usernameFocusNode.addListener(() {
      if (!_usernameFocusNode.hasFocus) {
        _cubit.onUsernameUnfocused();
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  UserProfileCubit get _cubit => context.read<UserProfileCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) {
      final successState = state as UserProfileStateSuccess;

      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const UserProfileImage(),
                Spacing.height48,
                TextFormField(
                  initialValue: widget.email,
                  decoration:
                      const InputDecoration(labelText: 'Email', enabled: false),
                ),
                Spacing.height16,
                TextField(
                  focusNode: _usernameFocusNode,
                  controller: _usernameController,
                  onChanged: _cubit.onUsernameChanged,
                  onSubmitted: print,
                  decoration: InputDecoration(
                      labelText: 'Username',
                      errorText: successState.username.error?.message),
                ),
                Spacing.height48,
                ExpandedElevatedButton(
                  label: 'Sign out',
                  onTap: () {
                    final cubit = context.read<UserProfileCubit>();
                    cubit.signOut();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
