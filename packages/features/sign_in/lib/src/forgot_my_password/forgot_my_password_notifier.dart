import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class ForgotPasswordNotifier extends ChangeNotifier {
  ForgotPasswordNotifier(this._userRepository);
  final UserRepository _userRepository;

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
      await _userRepository.requestPasswordResetEmail(email);
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
