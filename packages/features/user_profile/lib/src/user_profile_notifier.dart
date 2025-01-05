import 'package:bazaar_api/bazaar_api.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';

class UserProfileNotifier extends ChangeNotifier {
  UserProfileNotifier(this._api) {
    _fetchCurrentUser();
  }

  final BazaarApi _api;

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
      final fetchedUser = _api.auth.currentUser;
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
      await _api.auth.updateDisplayName(username);
      _fetchCurrentUser();
    } catch (_) {
      _updateState(state: UserProfileState.error);
    }
  }

  void refetch() => _fetchCurrentUser();

  Future<void> signOut() async {
    try {
      await _api.auth.signOut();
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
