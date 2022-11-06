import "dart:async";

import "package:amaterasu/features/accounts/data/account_repository.dart";
import "package:amaterasu/features/accounts/domain/twitch_account.dart";
import "package:logging/logging.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "auth_notifier.g.dart";

/// Implementation of [AsyncNotifier] that manages the authentication state
/// of the application.
@riverpod
class AuthNotifier extends _$AuthNotifier {
  final Logger _log = Logger("AuthNotifier");

  /// Initializes the notifier with the current [TwitchAccount] if it exists.
  ///
  /// If the user is signed in,start a validation timer that checks if the
  /// token is valid every hour.
  ///
  /// See https://dev.twitch.tv/docs/authentication/validate-tokens for more
  /// information.
  @override
  Future<TwitchAccount?> build() async {
    final accountRepository = ref.watch(accountRepositoryProvider);
    final currentAccountId = await accountRepository.retrieveCurrentAccountId();
    final accounts = await accountRepository.retrieveAccounts();
    return accounts[currentAccountId];
  }

  Future<void> addAccount(final String accessToken) async {
    _log.info("Creating an account with access token and logging in...");
    final accountRepository = ref.watch(accountRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Create a new account with the given access token and set it as the current account.
      final account = await accountRepository.addAccount(accessToken);
      _log.info("Logged in as ${account.username}(${account.userId}).");

      // Refresh the accounts provider.
      ref.invalidate(accountsProvider);

      return account;
    });
  }

  Future<void> deleteAccount(final TwitchAccount account) async {
    _log.info("Deleting account ${account.username}(${account.userId})...");
    final accountRepository = ref.watch(accountRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await accountRepository.deleteAccount(account);
      _log.info("Account ${account.username}(${account.userId}) deleted.");

      // Refresh the accounts provider.
      ref.invalidate(accountsProvider);

      return state.value?.userId == account.userId ? null : state.value;
    });
  }

  Future<void> login(final TwitchAccount account) async {
    _log.info("Logging in as ${account.username}(${account.userId})...");
    final accountRepository = ref.watch(accountRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Create a new account with the given access token and set it as the current account.
      await accountRepository.setCurrentAccount(account);
      _log.info("Logged in as ${account.username}(${account.userId}).");

      return account;
    });
  }

  Future<void> logout() async {
    _log.info("Logging out of the current account...");
    final accountRepository = ref.watch(accountRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Log out of the current account.
      await accountRepository.unsetCurrentAccount();
      _log.info("Successfully logged out.");

      return null;
    });
  }
}
