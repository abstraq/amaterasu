import "package:amaterasu/core/data/logged_http_client.dart";
import "package:amaterasu/features/accounts/application/auth_notifier.dart";
import "package:http/http.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "helix_http_client.g.dart";

/// A [Client] that adds the required headers for interacting with the Helix API
/// to all requests.
///
/// The underlying [Client] implementation is a [LoggedHttpClient] that logs all
/// requests and responses.
class HelixHttpClient extends BaseClient {
  final LoggedHttpClient _client = LoggedHttpClient();
  final String? _clientId;
  final String? _accessToken;

  HelixHttpClient({String? clientId, String? accessToken})
      : _clientId = clientId,
        _accessToken = accessToken;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    if (_clientId != null) {
      request.headers["Client-ID"] = _clientId!;
    }
    if (_accessToken != null) {
      request.headers["Authorization"] = "Bearer $_accessToken";
    }

    return _client.send(request);
  }

  @override
  void close() {
    _client.close();
    super.close();
  }
}

@riverpod
HelixHttpClient helixHttpClient(HelixHttpClientRef ref) {
  final client = HelixHttpClient(
    clientId: ref.watch(_clientIdProvider),
    accessToken: ref.watch(_accessTokenProvider),
  );

  ref.onDispose(client.close);
  return client;
}

@riverpod
String? _clientId(_ClientIdRef ref) {
  return ref.watch(authNotifierProvider.select((state) => state.valueOrNull?.clientId));
}

@riverpod
String? _accessToken(_AccessTokenRef ref) {
  return ref.watch(authNotifierProvider.select((state) => state.valueOrNull?.accessToken));
}
