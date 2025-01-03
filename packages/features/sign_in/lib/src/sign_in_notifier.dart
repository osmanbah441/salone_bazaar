import 'package:bazaar_api/bazaar_api.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';

class SignInNotifier extends ChangeNotifier {
  SignInNotifier(BazaarApi api) : _api = api;

  final BazaarApi _api;

  bool _isValidationTriggered = false;
  SignInSubmissionStatus _submissionStatus = SignInSubmissionStatus.idle;

  bool get isValidationTriggered => _isValidationTriggered;
  SignInSubmissionStatus get submissionStatus => _submissionStatus;

  void _setState({
    bool? isValidationTriggered,
    SignInSubmissionStatus? status,
  }) {
    _isValidationTriggered = isValidationTriggered ?? _isValidationTriggered;
    _submissionStatus = status ?? _submissionStatus;
    notifyListeners();
  }

  void continueWithGoogle() async {
    _setState(status: SignInSubmissionStatus.inprogress);
    try {
      await _api.auth.signInWithGoogle();
      _setState(status: SignInSubmissionStatus.success);
    } on GoogleSignInCancelByUser catch (_) {
      _setState(status: SignInSubmissionStatus.googleSignInError);
    } catch (_) {
      _setState(status: SignInSubmissionStatus.networkError);
    }
  }

  void loginWithEmailAndPassword({
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
  }) async {
    _setState(isValidationTriggered: true);
    if (formKey.currentState!.validate()) {
      _setState(status: SignInSubmissionStatus.inprogress);
      try {
        await _api.auth.signInWithEmailAndPassword(email, password);
        _setState(status: SignInSubmissionStatus.success);
      } on InvalidCredentialException catch (_) {
        _setState(status: SignInSubmissionStatus.invalidCredentials);
      } catch (_) {
        _setState(status: SignInSubmissionStatus.networkError);
      }
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
