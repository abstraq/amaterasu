import "package:amaterasu/features/accounts/application/auth_notifier.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

class AddAccountButton extends ConsumerWidget {
  const AddAccountButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      // If the auth notifier state is loading the button should be disabled.
      onPressed: !ref.watch(authNotifierProvider).isLoading ? () => context.push("/accounts/auth") : null,
      child: const Text("Add New Account"),
    );
  }
}
