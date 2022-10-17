import "package:amaterasu/features/authentication/presentation/login_button.dart";
import "package:flutter/material.dart";

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Welcome to Amaterasu",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
            ),
            Text(
              "Let's get started, press the button below to connect your Twitch account.",
              style: TextStyle(fontSize: 11),
            ),
            SizedBox(height: 32),
            LoginButton()
          ],
        ),
      ),
    );
  }
}
