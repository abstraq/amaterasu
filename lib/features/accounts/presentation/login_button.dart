import "package:amaterasu/features/accounts/application/auth_notifier.dart";
import "package:amaterasu/features/accounts/presentation/twitch_authorization_web_view.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class LoginButton extends ConsumerWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifierState = ref.watch(authNotifierProvider);
    final currentAccount = authNotifierState.valueOrNull;
    return ElevatedButton(
      // If the auth notifier state is loading or has an error the button should be disabled.
      // The button should also be disabled if the user is already logged in.
      onPressed: !(authNotifierState.hasError || authNotifierState.isLoading) && currentAccount == null
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
      child: const Text("Add New Account"),
    );
  }
}
