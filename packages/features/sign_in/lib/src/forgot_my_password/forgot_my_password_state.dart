part of 'forgot_my_password_cubit.dart';

class ForgotMyPasswordState extends Equatable {
  const ForgotMyPasswordState({
    this.resetEmail = const Email.unvalidated(''),
    this.resetEmailSubmissionStatus = ResetEmailSubmissionStatus.idle,
  });

  final Email resetEmail;
  final ResetEmailSubmissionStatus resetEmailSubmissionStatus;

  ForgotMyPasswordState copyWith({
    Email? resetEmail,
    ResetEmailSubmissionStatus? resetEmailSubmissionStatus,
  }) {
    return ForgotMyPasswordState(
      resetEmail: resetEmail ?? this.resetEmail,
      resetEmailSubmissionStatus:
          resetEmailSubmissionStatus ?? this.resetEmailSubmissionStatus,
    );
  }

  @override
  List<Object?> get props => [resetEmail, resetEmailSubmissionStatus];
}

enum ResetEmailSubmissionStatus {
  idle,
  inProgress,
  success,
  error;

  bool get isSuccess => this == ResetEmailSubmissionStatus.success;
  bool get isInProgress => this == ResetEmailSubmissionStatus.inProgress;
  bool get isError => this == ResetEmailSubmissionStatus.error;
}
