import "dart:convert";
import "dart:math";

import "package:amaterasu/features/authentication/data/exceptions/twitch_auth_api_exceptions.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_web_auth_2/flutter_web_auth_2.dart";

class TwitchAuthApiDataSource {
  static const String _clientId = "smff7b2spurx6aq29h8sfevqiee8uv";
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
  Future<String> authorizeClient({String clientId = _clientId, String redirectScheme = "amtsu"}) async {
    // Generate a random state token to prevent CSRF attacks.
    final stateToken = base64UrlEncode(List.generate(32, (i) => Random().nextInt(256))).replaceAll("[^A-Za-z0-9]", "");
    final authorizationUrl = Uri.https("id.twitch.tv", "/oauth2/authorize", {
      "client_id": clientId,
      "redirect_uri": "$redirectScheme://",
      "response_type": "token",
      "force_verify": "true",
      "scope": _requiredScopes.join(" "),
      "state": stateToken,
    }).toString();

    try {
      // Prompt the user to authorize the application and wait for the callback.
      final result = await FlutterWebAuth2.authenticate(url: authorizationUrl, callbackUrlScheme: redirectScheme);

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
}

final twitchAuthApiDataSourceProvider = Provider<TwitchAuthApiDataSource>((ref) {
  return TwitchAuthApiDataSource();
});
