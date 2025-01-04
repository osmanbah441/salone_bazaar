import 'package:bazaar_api/bazaar_api.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';

class SignInNotifier extends ChangeNotifier {
  SignInNotifier(this._api);
  final BazaarApi _api;

  SignInSubmissionStatus _submissionStatus = SignInSubmissionStatus.idle;
  SignInSubmissionStatus get submissionStatus => _submissionStatus;

  void _updateStatus({SignInSubmissionStatus? status}) {
    _submissionStatus = status ?? _submissionStatus;
    notifyListeners();
  }

  void continueWithGoogle() async {
    _updateStatus(status: SignInSubmissionStatus.inprogress);
    try {
      await _api.auth.signInWithGoogle();
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
      await Future.delayed(Duration(seconds: 2));

      await _api.auth.signInWithEmailAndPassword(email, password);
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
