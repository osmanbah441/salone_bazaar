import 'package:bazaar_api/bazaar_api.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';

class SignUpNotifier extends ChangeNotifier {
  SignUpNotifier(this._api);

  final BazaarApi _api;

  bool _isValidationTriggeredForBuyer = false;
  bool _isValidationTriggeredForSeller = false;
  String? _previousBuyerEmail;
  String? _previousSellerEmail;
  SignUpSubmissionStatus _submissionStatus = SignUpSubmissionStatus.idle;
  AccountType _createAccountFor = AccountType.none;

  SignUpSubmissionStatus get submissionStatus => _submissionStatus;
  AccountType get createAccountFor => _createAccountFor;
  bool get isValidationTriggeredForBuyer => _isValidationTriggeredForBuyer;
  bool get isValidationTriggeredForSeller => _isValidationTriggeredForSeller;

  /// Updates the account type selection and resets relevant states.
  void selectAccountType(AccountType type) {
    _updateState(
      createAccountFor: type,
      isValidationTriggeredForBuyer: false,
      isValidationTriggeredForSeller: false,
      status: SignUpSubmissionStatus.idle,
      previousBuyerEmail: null,
      previousSellerEmail: null,
    );
  }

  /// Updates the state of the notifier.
  void _updateState({
    bool? isValidationTriggeredForBuyer,
    bool? isValidationTriggeredForSeller,
    SignUpSubmissionStatus? status,
    String? previousBuyerEmail,
    String? previousSellerEmail,
    AccountType? createAccountFor,
  }) {
    _isValidationTriggeredForBuyer =
        isValidationTriggeredForBuyer ?? _isValidationTriggeredForBuyer;
    _isValidationTriggeredForSeller =
        isValidationTriggeredForSeller ?? _isValidationTriggeredForSeller;
    _submissionStatus = status ?? _submissionStatus;
    _previousBuyerEmail = previousBuyerEmail ?? _previousBuyerEmail;
    _previousSellerEmail = previousSellerEmail ?? _previousSellerEmail;
    _createAccountFor = createAccountFor ?? _createAccountFor;
    notifyListeners();
  }

  /// Handles email changes for the seller.
  void onSellerEmailChanged(String? email) {
    _updateState(
      status: email != _previousSellerEmail
          ? SignUpSubmissionStatus.idle
          : SignUpSubmissionStatus.sellerEmailAlreadyRegistered,
    );
  }

  /// Handles email changes for the buyer.
  void onBuyerEmailChanged(String? email) {
    _updateState(
      status: email != _previousBuyerEmail
          ? SignUpSubmissionStatus.idle
          : SignUpSubmissionStatus.buyerEmailAlreadyRegistered,
    );
  }

  /// Creates an account for the buyer or seller.
  Future<void> createAccount({
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
    String? businessName,
    String? phoneNumber,
  }) async {
    _triggerValidation();

    if (formKey.currentState?.validate() ?? false) {
      _updateState(status: SignUpSubmissionStatus.inprogress);
      try {
        if (createAccountFor.isBuyer) {
          await _api.auth.createBuyerAccount(email, password);
        } else if (createAccountFor.isSeller) {
          await _api.auth.createSellerAccount(
            email: email,
            password: password,
            businessName: businessName!,
            phoneNumber: phoneNumber!,
          );
        }
        _updateState(status: SignUpSubmissionStatus.success);
      } on EmailAlreadyRegisteredException {
        _handleEmailAlreadyRegistered(email);
      } catch (_) {
        _updateState(status: SignUpSubmissionStatus.networkError);
      }
    }
  }

  /// Triggers validation for the appropriate account type.
  void _triggerValidation() {
    if (createAccountFor.isBuyer) {
      _updateState(isValidationTriggeredForBuyer: true);
    } else if (createAccountFor.isSeller) {
      _updateState(isValidationTriggeredForSeller: true);
    }
  }

  /// Handles email already registered exceptions.
  void _handleEmailAlreadyRegistered(String email) {
    if (createAccountFor.isBuyer) {
      _updateState(
        status: SignUpSubmissionStatus.buyerEmailAlreadyRegistered,
        previousBuyerEmail: email,
      );
    } else if (createAccountFor.isSeller) {
      _updateState(
        status: SignUpSubmissionStatus.sellerEmailAlreadyRegistered,
        previousSellerEmail: email,
      );
    }
  }

  /// Continues with Google sign-in.
  Future<void> continueWithGoogle() async {
    _updateState(status: SignUpSubmissionStatus.inprogress);
    try {
      await _api.auth.signInWithGoogle();
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
  buyerEmailAlreadyRegistered,
  sellerEmailAlreadyRegistered,
  googleSignInError,
  networkError;

  bool get isInProgress => this == SignUpSubmissionStatus.inprogress;
  bool get isSuccess => this == SignUpSubmissionStatus.success;
  bool get isBuyerEmailAlreadyRegistered =>
      this == SignUpSubmissionStatus.buyerEmailAlreadyRegistered;
  bool get isSellerEmailAlreadyRegistered =>
      this == SignUpSubmissionStatus.sellerEmailAlreadyRegistered;
  bool get isNetworkError => this == SignUpSubmissionStatus.networkError;
  bool get isGoogleSignInError =>
      this == SignUpSubmissionStatus.googleSignInError;
}
