import "package:amaterasu/features/authentication/presentation/login_button.dart";
import "package:flutter/material.dart";

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            const LoginButton()
          ],
        ),
      ),
    );
  }
}
