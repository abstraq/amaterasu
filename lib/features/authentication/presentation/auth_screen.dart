import "dart:developer";

import "package:amaterasu/features/authentication/application/auth_notifier.dart";
import "package:amaterasu/features/authentication/presentation/twitch_authorization_web_view.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authNotifierProvider, (_, currentState) {
      log("Auth state changed: $currentState");
    });

    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to Amaterasu",
              style: textTheme.headline5,
            ),
            Text(
              "Let's get started, press the button below to connect your Twitch account.",
              style: textTheme.subtitle2,
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 60,
              child: ElevatedButton(
                onPressed: ref.watch(authNotifierProvider).when(
                      data: (account) => account == null
                          ? () => showModalBottomSheet(
                                context: context,
                                enableDrag: false,
                                isScrollControlled: true,
                                builder: (context) => SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.9,
                                  child: const TwitchAuthorizationWebView(),
                                ),
                              )
                          : null,
                      error: (_, __) => null,
                      loading: () => null,
                    ),
                child: ref.watch(authNotifierProvider).maybeWhen(
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 64),
                        child: CircularProgressIndicator(),
                      ),
                      orElse: () => const Text("Connect with Twitch"),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
