import 'package:bazaar_api/bazaar_api.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';

part 'sign_in_state.dart';

final class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this.api) : super(const SignInState());

  final BazaarApi api;

  void onPasswordChanged(String newValue) {
    final newPassword = state.password.shouldValidate
        ? Password.validated(newValue)
        : Password.unvalidated(newValue);

    final newState = state.copyWith(password: newPassword);
    emit(newState);
  }

  void onPasswordUnfocused() {
    final newPassword = Password.validated(state.password.value);
    final newState = state.copyWith(password: newPassword);
    emit(newState);
  }

  void onEmailChanged(String newValue) {
    final newEmail = state.email.shouldValidate
        ? Email.validated(newValue)
        : Email.unvalidated(newValue);

    final newState = state.copyWith(email: newEmail);
    emit(newState);
  }

  void onEmailUnfocused() {
    final newEmail = Email.validated(state.email.value);
    final newState = state.copyWith(email: newEmail);
    emit(newState);
  }

  Future<void> onSubmit() async {
    final email = Email.validated(state.email.value);
    final password = Password.validated(state.password.value);
    final isFormValid = FormFields.validate([email, password]);

    final newState = state.copyWith(
      email: email,
      password: password,
      emailAndPasswordSubmissionStatus:
          isFormValid ? EmailAndPasswordSubmissionStatus.inProgress : null,
    );

    emit(newState);

    if (isFormValid) {
      try {
        await api.auth.signInWithEmailAndPassword(email.value, password.value);
        emit(state.copyWith(
            emailAndPasswordSubmissionStatus:
                EmailAndPasswordSubmissionStatus.success));
      } catch (e) {
        emit(
          state.copyWith(
              emailAndPasswordSubmissionStatus: e is InvalidCredentialException
                  ? EmailAndPasswordSubmissionStatus.invalidCredentialsError
                  : EmailAndPasswordSubmissionStatus.genericError),
        );
      }
    }
  }

  void signInWithGoogle() async {
    emit(state.copyWith(
        googleSignInSubmissionStatusStatus:
            GoogleSignInSubmissionStatusStatus.inProgress));

    try {
      await api.auth.signInWithGoogle();

      emit(
        state.copyWith(
            googleSignInSubmissionStatusStatus:
                GoogleSignInSubmissionStatusStatus.success),
      );
    } catch (error) {
      error is GoogleSignInCancelByUser
          ? emit(
              state.copyWith(
                  googleSignInSubmissionStatusStatus:
                      GoogleSignInSubmissionStatusStatus.cancelled),
            )
          : emit(state.copyWith(
              googleSignInSubmissionStatusStatus:
                  GoogleSignInSubmissionStatusStatus.error));
    }
  }
}
