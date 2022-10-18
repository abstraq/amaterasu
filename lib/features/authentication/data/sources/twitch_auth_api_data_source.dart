import "dart:convert";
import "dart:math";

import "package:amaterasu/features/authentication/data/exceptions/twitch_auth_api_exceptions.dart";
import "package:amaterasu/features/authentication/data/responses/validate_token_response.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_web_auth_2/flutter_web_auth_2.dart";
import "package:http/http.dart";

/// Data source for interacting with the Twitch Auth API.
///
/// The Twitch Auth API (id.twitch.tv) provides oauth2 authentication for the Twitch API.
class TwitchAuthApiDataSource {
  static const String _defaultClientId = "smff7b2spurx6aq29h8sfevqiee8uv";
  static const List<String> _requiredScopes = [
    "user:read:follows",
    "user:read:subscriptions",
    "user:read:blocked_users",
    "user:manage:blocked_users",
    "channel:moderate",
    "chat:edit",
    "chat:read",
    "whispers:read",
    "whispers:edit",
  ];

  final Client _http;

  TwitchAuthApiDataSource(this._http);

  /// Requests an access token from the Twitch API.
  ///
  /// Prompts the user in their browser to authorize the application with the
  /// given `clientId`. After the user accepts, the application will receive
  /// an access token to make requests to the Twitch API on behalf of the user.
  ///
  /// Throws a [AuthorizationCancelledException] if the user cancelled the
  /// authorization process.
  ///
  /// Throws a [StateMismatchException] if the state parameter returned by the
  /// Twitch API does not match the state parameter sent by the application. This
  /// may indicate that the user was victim to a CSRF attack.
  ///
  /// Throws a [MalformedCallbackException] if the callback URL returned by the
  /// Twitch API does not contain an access token.
  ///
  /// Returns the access token if the request was successful.
  Future<String> authorizeClient({String clientId = _defaultClientId}) async {
    // Generate a random state token to prevent CSRF attacks.
    final stateToken = base64UrlEncode(List.generate(32, (i) => Random().nextInt(256))).replaceAll("[^A-Za-z0-9]", "");
    final authorizationUrl = Uri.https("id.twitch.tv", "/oauth2/authorize", {
      "client_id": clientId,
      "redirect_uri": "amtsu://",
      "response_type": "token",
      "force_verify": "true",
      "scope": _requiredScopes.join(" "),
      "state": stateToken,
    }).toString();

    try {
      // Prompt the user to authorize the application and wait for the callback.
      final result = await FlutterWebAuth2.authenticate(url: authorizationUrl, callbackUrlScheme: "amtsu");

      // After we recieve the callback extract the access token from the URL.
      final callback = Uri.parse(result);
      if (callback.queryParameters["error"] != null) {
        if (callback.queryParameters["state"] != stateToken) throw StateMismatchException();
        throw AuthorizationCancelledException();
      }

      final fragmentParams = Uri.splitQueryString(callback.fragment);
      if (fragmentParams["state"] != stateToken) throw StateMismatchException();

      final accessToken = fragmentParams["access_token"];
      if (accessToken == null) throw MalformedCallbackException();

      return accessToken;
    } on PlatformException {
      // The user closed the browser tab.
      throw AuthorizationCancelledException();
    }
  }

  /// Validates the provided `accessToken` with the Twitch API.
  ///
  /// Throws a [APIResponseException] if the Twitch API returns a status code
  /// other than 200.
  ///
  /// Returns a [ValidateTokenResponse] containing information about the token
  /// if the request was successful.
  Future<ValidateTokenResponse> validateToken(String accessToken) async {
    final route = Uri.https("id.twitch.tv", "/oauth2/validate");
    final response = await _http.get(route, headers: {"Authorization": "OAuth $accessToken"});

    if (response.statusCode != 200) {
      throw APIResponseException(response.statusCode);
    }

    return ValidateTokenResponse.fromJson(json.decode(response.body));
  }

  /// Revokes the provided `accessToken` with the Twitch API.
  ///
  /// The Twitch API will invalidate the token and it will no longer be usable by
  /// the `clientId`.
  ///
  /// Throws a [APIResponseException] if the Twitch API returns a status code
  /// other than 200.
  Future<void> revokeToken(String accessToken, {required String clientId}) async {
    final route = Uri.https("id.twitch.tv", "/oauth2/revoke");
    final response = await _http.post(route, body: {"client_id": clientId, "token": accessToken});

    if (response.statusCode != 200) {
      throw APIResponseException(response.statusCode);
    }
  }
}

final twitchAuthApiDataSourceProvider = Provider<TwitchAuthApiDataSource>((ref) {
  final client = Client();
  return TwitchAuthApiDataSource(client);
});
