import "package:http/http.dart";
import "package:logging/logging.dart";

/// A [Client] that logs all requests and responses.
///
/// This class is used to log all requests and responses made by the application.
/// Every http request made by the application should be made using this client.
class LoggedHttpClient extends BaseClient {
  final Logger _log = Logger("Network");
  final Client _client = Client();

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    _log.info("Sending ${request.method} to ${request.url}");
    final response = await _client.send(request);
    _log.info("Completed ${request.method} to ${request.url} with status: ${response.statusCode}");
    return response;
  }

  @override
  void close() {
    _client.close();
    super.close();
  }
}
