import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class SignUpNotifier extends ChangeNotifier {
  SignUpNotifier(this._userRepository);

  final UserRepository _userRepository;

  String? _previousEmail;
  SignUpSubmissionStatus _submissionStatus = SignUpSubmissionStatus.idle;
  AccountType _accountType = AccountType.none;

  SignUpSubmissionStatus get submissionStatus => _submissionStatus;
  AccountType get accountType => _accountType;

  /// Updates the account type selection and resets relevant states.
  void selectAccountType(AccountType type) => _updateState(
        createAccountFor: type,
        status: SignUpSubmissionStatus.idle,
        previousEmail: null,
      );

  /// Updates the state of the notifier.
  void _updateState({
    SignUpSubmissionStatus? status,
    String? previousEmail,
    AccountType? createAccountFor,
  }) {
    _submissionStatus = status ?? _submissionStatus;
    _previousEmail = previousEmail ?? _previousEmail;
    _accountType = createAccountFor ?? _accountType;
    notifyListeners();
  }

  /// Handles email changes for the buyer.
  void onEmailChanged(String? email) {
    _updateState(
      status: email != _previousEmail
          ? SignUpSubmissionStatus.idle
          : SignUpSubmissionStatus.emailAlreadyRegistered,
    );
  }

  void createBuyerAccount({
    required String email,
    required String password,
  }) =>
      _createAccount(email: email, password: password);

  void createSellerAccount({
    required String email,
    required String password,
    required String businessName,
    required String phoneNumber,
  }) =>
      _createAccount(
        email: email,
        password: password,
        businessName: businessName,
        phoneNumber: phoneNumber,
      );

  /// Creates an account for the buyer or seller.
  Future<void> _createAccount({
    required String email,
    required String password,
    String? businessName,
    String? phoneNumber,
  }) async {
    _updateState(status: SignUpSubmissionStatus.inprogress);
    try {
      if (accountType.isBuyer) {
        await _userRepository.createBuyerWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else if (accountType.isSeller) {
        await _userRepository.createSellerAccount(
          email: email,
          password: password,
          businessName: businessName!,
          phoneNumber: phoneNumber!,
        );
      }
      _updateState(status: SignUpSubmissionStatus.success);
    } on EmailAlreadyRegisteredException {
      _updateState(
        status: SignUpSubmissionStatus.emailAlreadyRegistered,
        previousEmail: email,
      );
    } catch (_) {
      _updateState(status: SignUpSubmissionStatus.networkError);
    }
  }

  /// Continues with Google sign-in.
  Future<void> continueWithGoogle() async {
    _updateState(status: SignUpSubmissionStatus.inprogress);
    try {
      await _userRepository.signInWithGoogle();
      _updateState(status: SignUpSubmissionStatus.success);
    } on GoogleSignInCancelByUser {
      _updateState(status: SignUpSubmissionStatus.googleSignInError);
    } catch (_) {
      _updateState(status: SignUpSubmissionStatus.networkError);
    }
  }
}

enum AccountType {
  buyer,
  seller,
  none;

  bool get isBuyer => this == AccountType.buyer;
  bool get isSeller => this == AccountType.seller;
  bool get isNone => this == AccountType.none;
}

enum SignUpSubmissionStatus {
  idle,
  inprogress,
  success,
  emailAlreadyRegistered,
  googleSignInError,
  networkError;

  bool get isInProgress => this == SignUpSubmissionStatus.inprogress;
  bool get isSuccess => this == SignUpSubmissionStatus.success;
  bool get isEmailAlreadyRegistered =>
      this == SignUpSubmissionStatus.emailAlreadyRegistered;

  bool get isNetworkError => this == SignUpSubmissionStatus.networkError;
  bool get isGoogleSignInError =>
      this == SignUpSubmissionStatus.googleSignInError;
}
