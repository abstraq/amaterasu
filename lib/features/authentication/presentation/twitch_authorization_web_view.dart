import "package:amaterasu/features/authentication/application/auth_notifier.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:webview_flutter/webview_flutter.dart";

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
