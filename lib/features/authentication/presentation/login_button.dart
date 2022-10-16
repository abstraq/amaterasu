import "dart:developer";

import "package:amaterasu/features/authentication/presentation/auth_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class LoginButton extends ConsumerWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log("Rebuilt Login Button ${DateTime.now()}");
    return ElevatedButton(
      onPressed: () async => ref.read(authControllerProvider.notifier).login(),
      child: const Text("Login with Twitch"),
    );
  }
}
