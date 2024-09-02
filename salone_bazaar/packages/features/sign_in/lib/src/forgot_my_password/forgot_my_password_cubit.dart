import 'package:bazaar_api/bazaar_api.dart';


import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';


part 'forgot_my_password_state.dart';

class ForgotMyPasswordCubit extends Cubit<ForgotMyPasswordState> {
  ForgotMyPasswordCubit({
   required this.api,
  }) : super(const ForgotMyPasswordState());

  final BazaarApi api;

void onResetEmailChanged(String newValue) {
    final newEmail = state.resetEmail.shouldValidate
        ? Email.validated(newValue)
        : Email.unvalidated(newValue);

    final newState = state.copyWith(resetEmail: newEmail);
    emit(newState);
  }

  void onResetEmailUnfocused() {
    final newEmail = Email.validated(state.resetEmail.value);
    final newState = state.copyWith(resetEmail: newEmail);
    emit(newState);
  }

  void onResetEmailSubmit() async {
    final email = Email.validated(state.resetEmail.value);
    final isValid = FormFields.validate([email]);
    final newState = state.copyWith(
      resetEmail: email,
      resetEmailSubmissionStatus: isValid ? ResetEmailSubmissionStatus.inProgress : null,
    );
    emit(newState);

    if (isValid) {
      try {
        await api.auth.requestPasswordResetEmail(email: email.value);
        final newState = state.copyWith(
          resetEmailSubmissionStatus: ResetEmailSubmissionStatus.success,
        );
        emit(newState);
      } catch (_) {
        final newState = state.copyWith(
          resetEmailSubmissionStatus: ResetEmailSubmissionStatus.error,
        );
        emit(newState);
      }
    }
  }

}
