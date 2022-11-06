import "package:amaterasu/core/exceptions/http_exception.dart";
import "package:amaterasu/features/accounts/data/twitch_auth_api_data_source.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "twitch_auth_api_data_source_test.mocks.dart";

const String _validTokenResponse = """
{
  "client_id": "wbmytr93xzw8zbg0p1izqyzzc5mbiz",
  "login": "twitchdev",
  "scopes": [
    "channel:read:subscriptions"
  ],
  "user_id": "141981764",
  "expires_in": 5520838
}
""";

@GenerateMocks([Client])
void main() {
  group("Tests for the TwitchAuthApiDataSource#validateToken", () {
    test("Given a valid access token, a token response is returned.", () async {
      final client = MockClient();

      // Stub the client to return a 200 response with a valid token response.
      when(client.get(
        Uri.https("id.twitch.tv", "/oauth2/validate"),
        headers: argThat(
            named: "headers",
            isMap.having((map) => map["Authorization"], "Authorization Header", startsWith("OAuth "))),
      )).thenAnswer((_) async => Response(_validTokenResponse, 200));

      final dataSource = TwitchAuthApiDataSource(client);
      final response = await dataSource.validateToken("valid_access_token");

      expect(response, isNotNull, reason: "The response should not be null if the token is valid.");
      expect(response!.userId, "141981764", reason: "The user id should be 141981764.");
    });

    test("Given an invalid access token, null is returned.", () async {
      final client = MockClient();

      // Stub the client to return a 200 response with a valid token response.
      when(client.get(
        Uri.https("id.twitch.tv", "/oauth2/validate"),
        headers: {"Authorization": "OAuth invalid_access_token"},
      )).thenAnswer((_) async => Response("", 401));

      final dataSource = TwitchAuthApiDataSource(client);
      final response = await dataSource.validateToken("invalid_access_token");

      expect(response, isNull);
    });

    test("When we recieve a non 200 or 401 response, an HttpException is thrown.", () async {
      final client = MockClient();

      // Stub the client to return a 200 response with a valid token response.
      when(client.get(
        Uri.https("id.twitch.tv", "/oauth2/validate"),
        headers: {"Authorization": "OAuth invalid_access_token"},
      )).thenAnswer((_) async => Response("", 500));

      final dataSource = TwitchAuthApiDataSource(client);
      expect(
        () async => await dataSource.validateToken("invalid_access_token"),
        throwsA(isA<HttpException>().having((e) => e.statusCode, "Status Code", 500)),
      );
    });
  });

  group("Tests for the TwitchAuthApiDataSource#revokeToken", () {
    test("Given a valid access token and Client ID, a 200 status code is returned.", () async {
      final client = MockClient();

      // Stub the client to return a 200 response with a valid token response.
      when(client.post(
        Uri.https("id.twitch.tv", "/oauth2/revoke"),
        body: argThat(
          named: "body",
          isMap.having((map) => map.keys, "Body map keys", containsAll(["client_id", "token"])),
        ),
      )).thenAnswer((_) async => Response("", 200));

      final dataSource = TwitchAuthApiDataSource(client);
      try {
        await dataSource.revokeToken(accessToken: "valid_access_token", clientId: "valid_client_id");
      } on HttpException {
        fail("An HttpException should not be thrown if the status code is 200.");
      }
    });

    test("When we receive a non 200 response, an HttpException should be thrown", () async {
      final client = MockClient();

      // Stub the client to return a 200 response with a valid token response.
      when(client.post(
        Uri.https("id.twitch.tv", "/oauth2/revoke"),
        body: argThat(
          named: "body",
          isMap.having((map) => map.keys, "Body map keys", containsAll(["client_id", "token"])),
        ),
      )).thenAnswer((_) async => Response("", 400));

      final dataSource = TwitchAuthApiDataSource(client);
      expect(
        () async => await dataSource.revokeToken(accessToken: "valid_access_token", clientId: "valid_client_id"),
        throwsA(isA<HttpException>().having((e) => e.statusCode, "Status code", 400)),
      );
    });
  });
}
