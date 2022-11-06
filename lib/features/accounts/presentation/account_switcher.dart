import "package:amaterasu/core/presentation/async_value_dialog_extension.dart";
import "package:amaterasu/features/accounts/application/auth_notifier.dart";
import "package:amaterasu/features/accounts/data/account_repository.dart";
import "package:amaterasu/features/accounts/presentation/account_tile.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class AccountSwitcher extends ConsumerWidget {
  const AccountSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authNotifierProvider, (_, state) {
      state.showAlertOnError(context);
    });
    final accountsValue = ref.watch(accountsProvider);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: accountsValue.when(
        data: (accounts) => ListView.builder(
          itemCount: accounts.length,
          itemBuilder: (_, index) => AccountTile(account: accounts.values.elementAt(index)),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Container(),
        skipError: true,
      ),
    );
  }
}
