import "package:amaterasu/features/accounts/application/auth_notifier.dart";
import "package:amaterasu/features/follows/presentation/import_twitch_follows_bottom_sheet.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      persistentFooterButtons: [
        ElevatedButton(
            onPressed: () => showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                context: context,
                builder: (BuildContext bc) => const ImportTwitchFollowsBottomSheet()),
            child: const Text("Add Channel")),
        ElevatedButton(
          onPressed: () async => ref.read(authNotifierProvider.notifier).logout(),
          child: const Text("Sign Out"),
        )
      ],
    );
  }
}
