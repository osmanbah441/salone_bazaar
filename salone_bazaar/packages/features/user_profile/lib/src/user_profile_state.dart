part of 'user_profile_cubit.dart';

sealed class UserProfileState {
  const UserProfileState();
}

class UserProfileStateSuccess extends UserProfileState {
  final Username username;
  final String email;
  final String? photoUrl;

  const UserProfileStateSuccess({
    required this.username,
    required this.email,
    this.photoUrl,
  });

  UserProfileStateSuccess copyWith({Username? username}) =>
      UserProfileStateSuccess(
        username: username ?? this.username,
        email: email,
        photoUrl: photoUrl,
      );
}

class UserProfileStateLoading extends UserProfileState {
  const UserProfileStateLoading();
}

class UserProfileStateFailure extends UserProfileState {
  const UserProfileStateFailure();
}
