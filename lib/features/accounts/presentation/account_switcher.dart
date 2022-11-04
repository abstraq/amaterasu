import "package:amaterasu/features/accounts/application/auth_notifier.dart";
import "package:amaterasu/features/accounts/data/account_repository.dart";
import "package:amaterasu/features/accounts/presentation/account_tile/account_tile.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class AccountSwitcher extends ConsumerWidget {
  const AccountSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authNotifierProvider);
    final accounts = ref.watch(twitchAccountsProvider);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (_, index) => AccountTile(account: accounts[index]),
      ),
    );
  }
}
