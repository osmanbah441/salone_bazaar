import 'package:bazaar_api/bazaar_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit({required BazaarApi api})
      : _api = api,
        super(const UserProfileStateLoading()) {
    _fetchCurrentUser();
  }

  final BazaarApi _api;

  void onUsernameChanged(String newValue) {
    final previousState = state as UserProfileStateSuccess;
    final newState = previousState.copyWith(
      username: Username.validated(newValue),
    );
    emit(newState);
  }

  void signOut() async {
    await _api.auth.signOut();
  }

  void onUsernameUnfocused() async {
    final previousState = state as UserProfileStateSuccess;
    final username = previousState.username;
    final newState =
        previousState.copyWith(username: Username.validated(username.value));
    emit(newState);
    final isValid = FormFields.validate([username]);
    if (isValid) {
      await _api.auth.updateDisplayName(username.value);
      _fetchCurrentUser();
    }
  }

  void refetch() => _fetchCurrentUser();

  void _fetchCurrentUser() {
    final user = _api.auth.currentUser;
    if (user == null) return emit(const UserProfileStateFailure());
    emit(UserProfileStateSuccess(
      username: Username.unvalidated(user.displayName ?? ''),
      email: user.email ?? '',
      photoUrl: user.photoURL,
    ));
  }
}
