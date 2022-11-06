/// Thrown when an HTTP request fails.
///
/// This exception represents an HTTP error the application did not
/// expect. This is used to notify the user that something went wrong
/// and that they should try again later.
class HttpException implements Exception {
  final Uri? uri;
  final int statusCode;
  final String? body;

  HttpException({this.uri, required this.statusCode, required this.body});
}
