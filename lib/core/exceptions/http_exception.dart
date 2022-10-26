class HttpException implements Exception {
  final Uri? uri;
  final int statusCode;
  final String? body;

  HttpException({this.uri, required this.statusCode, required this.body});
}
