class NotFoundResultException implements Exception {
  const NotFoundResultException();
}

class UserAuthenticationRequiredException implements Exception {
  const UserAuthenticationRequiredException();
}

class BazaarAuthException implements Exception {
  final String message;
  const BazaarAuthException(this.message);

  @override
  String toString() => message;
}

class EmailAlreadyRegisteredException extends BazaarAuthException {
  const EmailAlreadyRegisteredException()
      : super('The email address is already in use by another account.');
}

class UndefinedRestaurantAuthException extends BazaarAuthException {
  const UndefinedRestaurantAuthException()
      : super('An undefined error occurred.');
}

class InvalidCredentialException extends BazaarAuthException {
  const InvalidCredentialException() : super('Invalid credentials.');
}

class EmptySearchResultException implements Exception {
  const EmptySearchResultException();
}

class GoogleSignInCancelByUser implements Exception {
  const GoogleSignInCancelByUser();
}
