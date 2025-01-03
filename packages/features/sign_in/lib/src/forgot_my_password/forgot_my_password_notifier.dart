import 'package:bazaar_api/bazaar_api.dart';
import 'package:flutter/material.dart';

class ForgotPasswordNotifier extends ChangeNotifier {
  ForgotPasswordNotifier(BazaarApi api) : _api = api;

  final BazaarApi _api;

  bool _isValidationTriggered = false;
  bool get isValidationTriggered => _isValidationTriggered;

  ForgotPasswordSubmissionStatus _submissionStatus =
      ForgotPasswordSubmissionStatus.idle;

  ForgotPasswordSubmissionStatus get submissionStatus => _submissionStatus;

  void _setState({
    ForgotPasswordSubmissionStatus? status,
    bool? isValidationTriggered,
  }) {
    _submissionStatus = status ?? _submissionStatus;
    _isValidationTriggered = isValidationTriggered ?? _isValidationTriggered;
    notifyListeners();
  }

  Future<void> resetPassword({
    required GlobalKey<FormState> formKey,
    required String email,
  }) async {
    _setState(isValidationTriggered: true);
    if (formKey.currentState!.validate()) {
      _setState(status: ForgotPasswordSubmissionStatus.inprogress);
      try {
        await _api.auth.requestPasswordResetEmail(email);
        _setState(status: ForgotPasswordSubmissionStatus.success);
      } catch (e) {
        _setState(status: ForgotPasswordSubmissionStatus.error);
      }
    }
  }
}

enum ForgotPasswordSubmissionStatus {
  idle,
  inprogress,
  success,
  error;

  bool get isInProgress => this == ForgotPasswordSubmissionStatus.inprogress;
  bool get isSuccess => this == ForgotPasswordSubmissionStatus.success;
  bool get hasError => this == ForgotPasswordSubmissionStatus.error;
}
