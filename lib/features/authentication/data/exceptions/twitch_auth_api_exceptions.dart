class MalformedCallbackException implements Exception {}

class AuthorizationCancelledException implements Exception {}

class StateMismatchException implements Exception {}

class APIResponseException implements Exception {
  final int statusCode;

  APIResponseException(this.statusCode);
}
