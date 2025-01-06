import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class SignInNotifier extends ChangeNotifier {
  SignInNotifier(this._userRepository);
  final UserRepository _userRepository;

  SignInSubmissionStatus _submissionStatus = SignInSubmissionStatus.idle;
  SignInSubmissionStatus get submissionStatus => _submissionStatus;

  void _updateStatus({SignInSubmissionStatus? status}) {
    _submissionStatus = status ?? _submissionStatus;
    notifyListeners();
  }

  void continueWithGoogle() async {
    _updateStatus(status: SignInSubmissionStatus.inprogress);
    try {
      await _userRepository.signInWithGoogle();
      _updateStatus(status: SignInSubmissionStatus.success);
    } on GoogleSignInCancelByUser catch (_) {
      _updateStatus(status: SignInSubmissionStatus.googleSignInError);
    } catch (_) {
      _updateStatus(status: SignInSubmissionStatus.networkError);
    }
  }

  void loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _updateStatus(status: SignInSubmissionStatus.inprogress);
    try {
      await _userRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _updateStatus(status: SignInSubmissionStatus.success);
    } on InvalidCredentialException catch (_) {
      _updateStatus(status: SignInSubmissionStatus.invalidCredentials);
    } catch (_) {
      _updateStatus(status: SignInSubmissionStatus.networkError);
    }
  }
}

enum SignInSubmissionStatus {
  idle,
  inprogress,
  success,
  invalidCredentials,
  networkError,
  googleSignInError;

  bool get isInvalidCredentialsError =>
      this == SignInSubmissionStatus.invalidCredentials;

  bool get isNetworkError => this == SignInSubmissionStatus.networkError;

  bool get isGoogleSignError =>
      this == SignInSubmissionStatus.googleSignInError;

  bool get isInProgress => this == SignInSubmissionStatus.inprogress;

  bool get isSuccess => this == SignInSubmissionStatus.success;

  bool get hasError =>
      isInvalidCredentialsError || isNetworkError || isGoogleSignError;
}
