import "package:amaterasu/features/accounts/presentation/account_switcher.dart";
import "package:amaterasu/features/accounts/presentation/login_button.dart";
import "package:flutter/material.dart";

/// Screen that is displayed when the user is not authenticated.
///
/// This screen will display a button that will open a webview to authenticate
/// the user with Twitch.
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Account Switcher", style: textTheme.headline5),
              Text(
                "Choose an account from the list below or press the button to add a new account.",
                style: textTheme.subtitle2,
              ),
              const Expanded(child: AccountSwitcher()),
              const Center(child: LoginButton()),
            ],
          ),
        ),
      ),
    );
  }
}
