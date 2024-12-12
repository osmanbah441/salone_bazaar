part of 'retailer_registration_cubit.dart';

final class RetailerRegistrationState extends Equatable {
  const RetailerRegistrationState({
    this.businessName = const BusinessName.unvalidated(''),
    this.email = const Email.unvalidated(''),
    this.password = const Password.unvalidated(''),
    this.phoneNumber = const PhoneNumber.unvalidated(''),
    this.submissionStatus = SubmissionStatus.idle,
  });

  final BusinessName businessName;
  final Email email;
  final Password password;
  final PhoneNumber phoneNumber;
  final SubmissionStatus submissionStatus;

  RetailerRegistrationState copyWith({
    BusinessName? businessName,
    Email? email,
    Password? password,
    PhoneNumber? phoneNumber,
    BusinessAddress? businessAddress,
    SubmissionStatus? submissionStatus,
  }) =>
      RetailerRegistrationState(
        businessName: businessName ?? this.businessName,
        email: email ?? this.email,
        password: password ?? this.password,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        submissionStatus: submissionStatus ?? this.submissionStatus,
      );

  @override
  List<Object?> get props => [
        businessName,
        email,
        password,
        phoneNumber,
        submissionStatus,
      ];
}

enum SubmissionStatus {
  idle,
  inProgress,
  success,
  genericError;

  bool get isSuccess => this == SubmissionStatus.success;
  bool get isInProgress => this == SubmissionStatus.inProgress;
  bool get isGenericError => this == SubmissionStatus.genericError;
}
