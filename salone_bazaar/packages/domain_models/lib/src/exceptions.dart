class EmptySearchResultException implements Exception {
  const EmptySearchResultException();
}

class UserAuthenticationRequiredException implements Exception {
  const UserAuthenticationRequiredException();
}

class GoogleSignInCancelByUser implements Exception {
  const GoogleSignInCancelByUser();
}

class EmailAlreadyRegisteredException implements Exception {
  const EmailAlreadyRegisteredException();
}

final class InvalidCredentialException implements Exception {
  const InvalidCredentialException();
}
