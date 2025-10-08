//login
class InvalidCredentialAuthException implements Exception {}

//register
class WeakPasswordAuthException implements Exception {}

class EmailInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception{}

//generic
class GenericAuthException implements Exception{}

class UserNotLoggedInAuthException implements Exception{}