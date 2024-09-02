part of 'sign_in_cubit.dart';

final class SignInState extends Equatable {
  const SignInState(
      {this.password = const Password.unvalidated(''),
      this.email = const Email.unvalidated(''),
      this.emailAndPasswordSubmissionStatus = EmailAndPasswordSubmissionStatus.idle,
      this.googleSignInSubmissionStatusStatus = GoogleSignInSubmissionStatusStatus.idle,
      

      });

  final Password password;
  final Email email;
  final EmailAndPasswordSubmissionStatus emailAndPasswordSubmissionStatus;
  final GoogleSignInSubmissionStatusStatus googleSignInSubmissionStatusStatus;



  SignInState copyWith({
    Password? password,
    Email? email,
    EmailAndPasswordSubmissionStatus? emailAndPasswordSubmissionStatus,
    GoogleSignInSubmissionStatusStatus? googleSignInSubmissionStatusStatus,

  }) =>
      SignInState(
          password: password ?? this.password,
          email: email ?? this.email,
          emailAndPasswordSubmissionStatus: emailAndPasswordSubmissionStatus ?? this.emailAndPasswordSubmissionStatus,
          googleSignInSubmissionStatusStatus: googleSignInSubmissionStatusStatus ?? this.googleSignInSubmissionStatusStatus,
          
          );

  @override
  List<Object?> get props => [email, password, emailAndPasswordSubmissionStatus, googleSignInSubmissionStatusStatus
  
  
  
  
  ];
}

enum EmailAndPasswordSubmissionStatus {
  idle,
  inProgress,
  invalidCredentialsError,
  genericError,
  success;

  bool get isSuccess => this == EmailAndPasswordSubmissionStatus.success;
  bool get isInProgress => this == EmailAndPasswordSubmissionStatus.inProgress;
  bool get isGenericError => this == EmailAndPasswordSubmissionStatus.genericError;
  bool get isInvalidCredentialsError =>
      this == EmailAndPasswordSubmissionStatus.invalidCredentialsError;

  bool get hasSubmissionError => isGenericError || isInvalidCredentialsError;
}

enum GoogleSignInSubmissionStatusStatus { idle, inProgress, success, error, cancelled }

