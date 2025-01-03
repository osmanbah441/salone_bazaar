import 'package:bazaar_api/bazaar_api.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';

class SignUpNotifier extends ChangeNotifier {
  SignUpNotifier(BazaarApi api) : _api = api;

  final BazaarApi _api;

  bool _isValidationTriggeredForBuyer = false;
  bool _isValidationTriggeredForSeller = false;

  String? _previousBuyerEmail;
  String? _previousSellerEmail;

  SignUpSubmissionStatus _submissionStatus = SignUpSubmissionStatus.idle;
  CreateAccountFor _createAccountFor = CreateAccountFor.none;

  bool get isValidationTriggered {
    if (createAccountFor.isBuyer) return _isValidationTriggeredForBuyer;
    if (createAccountFor.isSeller) return _isValidationTriggeredForSeller;
    return false;
  }

  SignUpSubmissionStatus get submissionStatus => _submissionStatus;
  CreateAccountFor get createAccountFor => _createAccountFor;

  void selectAccountType(CreateAccountFor type) {
    _setState(createAccountFor: type);
  }

  void _setState({
    bool? isValidationTriggeredForBuyer,
    bool? isValidationTriggeredForSeller,
    SignUpSubmissionStatus? status,
    String? previousBuyerEmail,
    String? previousSellerEmail,
    CreateAccountFor? createAccountFor,
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

  void onSellerEmailChanged(String? email) => _setState(
        status: email != _previousSellerEmail
            ? SignUpSubmissionStatus.idle
            : SignUpSubmissionStatus.buyerEmailAlreadyRegistered,
      );

  void onBuyerEmailChanged(String? email) => _setState(
        status: email != _previousBuyerEmail
            ? SignUpSubmissionStatus.idle
            : SignUpSubmissionStatus.buyerEmailAlreadyRegistered,
      );

  void signUpWithEmailAndPassword({
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
    String? businessName,
    String? phoneNumber,
  }) async {
    if (createAccountFor.isBuyer) {
      _setState(isValidationTriggeredForBuyer: true);
    }
    if (createAccountFor.isSeller) {
      _setState(isValidationTriggeredForSeller: true);
    }

    if (formKey.currentState!.validate()) {
      _setState(status: SignUpSubmissionStatus.inprogress);
      try {
        await Future.delayed(Duration(seconds: 1));
        if (createAccountFor.isBuyer) {
          print("buyer account");
        } else if (createAccountFor.isSeller) {
          print('seller account');
        }

        throw EmailAlreadyRegisteredException();
        // await _api.auth.signUpWithEmailAndPassword(email, password);
        // _setState(status: SignUpSubmissionStatus.success);
      } on EmailAlreadyRegisteredException catch (_) {
        _setState(
          status: SignUpSubmissionStatus.buyerEmailAlreadyRegistered,
          previousBuyerEmail: email,
        );
      } catch (_) {
        _setState(status: SignUpSubmissionStatus.networkError);
      }
    }
  }

  void continueWithGoogle() async {
    _setState(status: SignUpSubmissionStatus.inprogress);
    try {
      await _api.auth.signInWithGoogle();
      _setState(status: SignUpSubmissionStatus.success);
    } on GoogleSignInCancelByUser catch (_) {
      _setState(status: SignUpSubmissionStatus.googleSignInError);
    } catch (_) {
      _setState(status: SignUpSubmissionStatus.networkError);
    }
  }
}

enum CreateAccountFor {
  buyer,
  seller,
  none;

  bool get isBuyer => this == CreateAccountFor.buyer;
  bool get isSeller => this == CreateAccountFor.seller;
  bool get isNone => this == CreateAccountFor.none;
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
