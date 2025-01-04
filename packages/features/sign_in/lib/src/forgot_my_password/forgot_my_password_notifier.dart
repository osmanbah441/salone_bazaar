import 'package:bazaar_api/bazaar_api.dart';
import 'package:flutter/material.dart';

class ForgotPasswordNotifier extends ChangeNotifier {
  ForgotPasswordNotifier(this._api);
  final BazaarApi _api;

  ForgotPasswordSubmissionStatus _submissionStatus =
      ForgotPasswordSubmissionStatus.idle;

  ForgotPasswordSubmissionStatus get submissionStatus => _submissionStatus;

  void _updateState({ForgotPasswordSubmissionStatus? status}) {
    _submissionStatus = status ?? _submissionStatus;
    notifyListeners();
  }

  Future<void> resetPassword({required String email}) async {
    _updateState(status: ForgotPasswordSubmissionStatus.inprogress);
    try {
      await _api.auth.requestPasswordResetEmail(email);
      _updateState(status: ForgotPasswordSubmissionStatus.success);
    } catch (e) {
      _updateState(status: ForgotPasswordSubmissionStatus.error);
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
