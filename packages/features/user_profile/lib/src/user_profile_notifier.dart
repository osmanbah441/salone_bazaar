import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class UserProfileNotifier extends ChangeNotifier {
  UserProfileNotifier(this._userRepository) {
    _fetchCurrentUser();
  }

  final UserRepository _userRepository;

  User? _user;
  UserProfileState _state = UserProfileState.inprogress;
  UserProfileSubmissionStatus _submissionStatus =
      UserProfileSubmissionStatus.idle;

  UserProfileState get state => _state;
  UserProfileSubmissionStatus get submissionStatus => _submissionStatus;
  User? get user => _user;

  void _updateState({
    User? user,
    UserProfileState? state,
    UserProfileSubmissionStatus? submissionStatus,
  }) {
    _user = user ?? _user;
    _state = state ?? _state;
    _submissionStatus = submissionStatus ?? _submissionStatus;

    notifyListeners();
  }

  void _fetchCurrentUser() async {
    _updateState(
      state: UserProfileState.inprogress,
      submissionStatus: UserProfileSubmissionStatus.idle,
    );

    try {
      final fetchedUser = _userRepository.currentUser;
      if (fetchedUser == null) {
        _updateState(
          submissionStatus: UserProfileSubmissionStatus.authenticationRequired,
        );
      } else {
        _updateState(
          user: fetchedUser,
          state: UserProfileState.success,
        );
      }
    } catch (_) {
      _updateState(state: UserProfileState.error);
    }
  }

  void updateUsername(String username) async {
    try {
      await _userRepository.updateDisplayName(username);
      _fetchCurrentUser();
    } catch (_) {
      _updateState(state: UserProfileState.error);
    }
  }

  void refetch() => _fetchCurrentUser();

  Future<void> signOut() async {
    try {
      await _userRepository.signOut();
      _updateState(
        submissionStatus: UserProfileSubmissionStatus.signoutSuccess,
      );
    } catch (_) {
      _updateState(state: UserProfileState.error);
    }
  }
}

enum UserProfileSubmissionStatus {
  idle,
  authenticationRequired,
  signoutSuccess;

  bool get isSignoutSuccess =>
      this == UserProfileSubmissionStatus.signoutSuccess;
  bool get isAuthenticationRequired =>
      this == UserProfileSubmissionStatus.authenticationRequired;
}

enum UserProfileState {
  inprogress,
  success,
  error;
}
