import "package:amaterasu/features/accounts/application/auth_notifier.dart";
import "package:amaterasu/features/accounts/domain/twitch_account.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class AccountTile extends ConsumerWidget {
  final TwitchAccount account;

  const AccountTile({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      // TODO: Replace with real avatar once user fetching is complete.
      leading: const CircleAvatar(backgroundImage: NetworkImage("https://placehold.jp/3d4070/ffffff/150x150.png")),
      title: Text(account.username),
      onTap: () async {
        HapticFeedback.vibrate();
        await ref.read(authNotifierProvider.notifier).login(account);
      },
      onLongPress: () => showModalBottomSheet(
        backgroundColor: Colors.black,
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (BuildContext context) {
          return Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.delete_forever_rounded),
                title: const Text("Delete Account"),
                onTap: () async {
                  HapticFeedback.vibrate();
                  Navigator.pop(context);
                  await ref.read(authNotifierProvider.notifier).deleteAccount(account);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
