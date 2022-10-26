import "package:amaterasu/features/authentication/application/auth_notifier.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:webview_flutter/webview_flutter.dart";

/// A [WebView] that is used to authorize the user with Twitch.
///
/// This widget will display the Twitch authorization page that prompts the
/// user to login and authorize the application. Once the user has authorized
/// the application, the authorization code will be extracted from the redirect
/// URL and passed to the [AuthNotifier] to complete the authentication process.
class TwitchAuthorizationWebView extends ConsumerWidget {
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

  const TwitchAuthorizationWebView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = Uri.https(
      "id.twitch.tv",
      "/oauth2/authorize",
      {
        "client_id": _defaultClientId,
        "redirect_uri": "https://abstraq.me/amaterasu",
        "response_type": "token",
        "force_verify": "true",
        "scope": _requiredScopes.join(" "),
      },
    );

    return WebView(
      initialUrl: url.toString(),
      javascriptMode: JavascriptMode.unrestricted,
      navigationDelegate: (request) {
        if (request.url.startsWith("https://abstraq.me/amaterasu")) {
          final fragmentParams = Uri.splitQueryString(Uri.parse(request.url).fragment);
          final accessToken = fragmentParams["access_token"];
          if (accessToken != null) {
            ref.read(authNotifierProvider.notifier).login(accessToken);
          }

          Navigator.of(context).pop();
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    );
  }
}
