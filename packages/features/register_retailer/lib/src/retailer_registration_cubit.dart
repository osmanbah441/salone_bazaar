import 'package:bazaar_api/bazaar_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';

part 'retailer_registration_state.dart';

final class RetailerRegistrationCubit extends Cubit<RetailerRegistrationState> {
  RetailerRegistrationCubit(this.api)
      : super(const RetailerRegistrationState());

  final BazaarApi api;

  void onBusinessNameChanged(String newValue) {
    final newBusinessName = state.businessName.shouldValidate
        ? BusinessName.validated(newValue)
        : BusinessName.unvalidated(newValue);

    final newState = state.copyWith(businessName: newBusinessName);
    emit(newState);
  }

  void onBusinessNameUnfocused() {
    final newName = BusinessName.validated(state.businessName.value);
    final newState = state.copyWith(businessName: newName);
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

  void onPhoneNumberChanged(String newValue) {
    final newPhoneNumber = state.phoneNumber.shouldValidate
        ? PhoneNumber.validated(newValue)
        : PhoneNumber.unvalidated(newValue);

    final newState = state.copyWith(phoneNumber: newPhoneNumber);
    emit(newState);
  }

  void onPhoneNumberUnfocused() {
    final newPhoneNumber = PhoneNumber.validated(state.phoneNumber.value);
    final newState = state.copyWith(phoneNumber: newPhoneNumber);
    emit(newState);
  }

  Future<void> onSubmit() async {
    final businessName = BusinessName.validated(state.businessName.value);
    final email = Email.validated(state.email.value);
    final password = Password.validated(state.password.value);
    final phoneNumber = PhoneNumber.validated(state.phoneNumber.value);

    final isFormValid =
        FormFields.validate([businessName, email, password, phoneNumber]);

    final newState = state.copyWith(
      businessName: businessName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      submissionStatus: isFormValid ? SubmissionStatus.inProgress : null,
    );

    emit(newState);

    if (isFormValid) {
      try {
        await api.auth.registerRetailer(
          businessName: businessName.value,
          email: email.value,
          password: password.value,
          phoneNumber: phoneNumber.value,
        );
        emit(state.copyWith(submissionStatus: SubmissionStatus.success));
      } catch (e) {
        emit(
          state.copyWith(submissionStatus: SubmissionStatus.genericError),
        );
      }
    }
  }
}
