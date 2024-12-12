part of 'user_profile_cubit.dart';

sealed class UserProfileState {
  const UserProfileState();
}

class UserProfileStateSuccess extends UserProfileState {
  final Username username;
  final String email;
  final String? photoUrl;
  final bool isSignOutSuccess;

  const UserProfileStateSuccess(
      {required this.username,
      required this.email,
      this.photoUrl,
      this.isSignOutSuccess = false});

  UserProfileStateSuccess copyWith(
          {Username? username, bool? isSignOutSuccess}) =>
      UserProfileStateSuccess(
        username: username ?? this.username,
        email: email,
        photoUrl: photoUrl,
        isSignOutSuccess: isSignOutSuccess ?? this.isSignOutSuccess,
      );
}

class UserProfileStateLoading extends UserProfileState {
  const UserProfileStateLoading();
}

class UserProfileStateFailure extends UserProfileState {
  const UserProfileStateFailure();
}
