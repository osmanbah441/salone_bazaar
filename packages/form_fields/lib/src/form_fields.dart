final class FormFields {
  static bool validate(List<FormInput> inputs) =>
      inputs.every((i) => i.isValid);
}

enum EmailAndPasswordSubmissionStatus {
  idle,
  inProgress,
  invalidCredentialsError,
  genericError,
  success;

  bool get isSuccess => this == EmailAndPasswordSubmissionStatus.success;
  bool get isInProgress => this == EmailAndPasswordSubmissionStatus.inProgress;
  bool get isGenericError =>
      this == EmailAndPasswordSubmissionStatus.genericError;
  bool get isInvalidCredentialsError =>
      this == EmailAndPasswordSubmissionStatus.invalidCredentialsError;

  bool get hasSubmissionError => isGenericError || isInvalidCredentialsError;
}

enum GoogleSignInSubmissionStatusStatus {
  idle,
  inProgress,
  success,
  error,
  cancelled;

  bool get isSuccess => this == GoogleSignInSubmissionStatusStatus.success;

}

abstract class FormInput<T, E> {
  const FormInput._(this.value, this.shouldValidate);

  const FormInput.unvalidated(T value) : this._(value, false);
  const FormInput.validated(T value) : this._(value, true);

  final T value;
  final bool shouldValidate;

  E? get error => shouldValidate ? validator(value) : null;

  bool get isValid => error == null;

  E? validator(T value);
}
