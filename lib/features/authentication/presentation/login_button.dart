import "package:amaterasu/features/authentication/presentation/auth_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class LoginButton extends ConsumerWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: () async => ref.read(authControllerProvider.notifier).connectTwitchAccount(),
        child: const Text("Connect with Twitch"),
      ),
    );
  }
}
