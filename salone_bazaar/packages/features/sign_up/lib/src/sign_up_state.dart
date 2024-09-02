part of 'sign_up_cubit.dart';

final class SignUpState extends Equatable {
  const SignUpState({
    this.password = const Password.unvalidated(''),
    this.email = const Email.unvalidated(''),
    this.emailAndPasswordSubmissionStatus =
        EmailAndPasswordSubmissionStatus.idle,
    this.googleSignInSubmissionStatusStatus =
        GoogleSignInSubmissionStatusStatus.idle,
  });

  final Password password;
  final Email email;
  final EmailAndPasswordSubmissionStatus emailAndPasswordSubmissionStatus;
  final GoogleSignInSubmissionStatusStatus googleSignInSubmissionStatusStatus;

  SignUpState copyWith({
    Password? password,
    Email? email,
    bool? isRetailer,
    EmailAndPasswordSubmissionStatus? emailAndPasswordSubmissionStatus,
    GoogleSignInSubmissionStatusStatus? googleSignInSubmissionStatusStatus,
  }) =>
      SignUpState(
        password: password ?? this.password,
        email: email ?? this.email,
        emailAndPasswordSubmissionStatus: emailAndPasswordSubmissionStatus ??
            this.emailAndPasswordSubmissionStatus,
        googleSignInSubmissionStatusStatus:
            googleSignInSubmissionStatusStatus ??
                this.googleSignInSubmissionStatusStatus,
      );

  @override
  List<Object?> get props => [
        email,
        password,
        emailAndPasswordSubmissionStatus,
        googleSignInSubmissionStatusStatus
      ];
}
