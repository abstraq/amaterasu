import "dart:convert";

import "package:amaterasu/core/exceptions/http_exception.dart";
import "package:amaterasu/features/authentication/data/entities/validate_token_response.dart";
import "package:http/http.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "twitch_auth_api_data_source.g.dart";

/// Data source for interacting with the Twitch Auth API (id.twitch.tv).
///
/// This data source is responsible for validating and revoking access tokens.
class TwitchAuthApiDataSource {
  final Client _http;

  TwitchAuthApiDataSource(this._http);

  /// Checks if the provided [accessToken] is valid.
  ///
  /// If the token is valid, the response will contain information about the
  /// token such as the user's id, username, and when the token is expiring.
  ///
  /// Throws [HttpException] if something went wrong with the request.
  ///
  /// Returns [ValidateTokenResponse] if the token is valid or null otherwise.
  Future<ValidateTokenResponse?> validateToken(String accessToken) async {
    final route = Uri.https("id.twitch.tv", "/oauth2/validate");
    final response = await _http.get(route, headers: {"Authorization": "OAuth $accessToken"});

    // The request returns a status code of 401 if the token is invalid.
    if (response.statusCode == 401) return null;

    // If the status code is not 200 or 401 there was an unexpected error.
    if (response.statusCode != 200) {
      throw HttpException(uri: response.request?.url, statusCode: response.statusCode, body: response.body);
    }

    final data = json.decode(response.body);
    return ValidateTokenResponse.fromJson(data);
  }

  /// Revokes the provided [accessToken] authorization from the Twitch API.
  ///
  /// After revoking the token, the token can not be used to access the Twitch API.
  ///
  /// Throws [HttpException] if something went wrong with the request.
  Future<void> revokeToken({required String accessToken, required String clientId}) async {
    final route = Uri.https("id.twitch.tv", "/oauth2/revoke");
    final response = await _http.post(route, body: {"client_id": clientId, "token": accessToken});

    // If the status code is not 200 there was an unexpected error.
    if (response.statusCode != 200) {
      throw HttpException(uri: response.request?.url, statusCode: response.statusCode, body: response.body);
    }
  }
}

@riverpod
TwitchAuthApiDataSource twitchAuthApiDataSource(TwitchAuthApiDataSourceRef ref) {
  final client = Client();

  // Close the http client when the provider is disposed.
  ref.onDispose(client.close);

  return TwitchAuthApiDataSource(client);
}
