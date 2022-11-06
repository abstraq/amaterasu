import "package:amaterasu/features/accounts/data/twitch_account_store_data_source.dart";
import "package:amaterasu/features/accounts/data/twitch_auth_api_data_source.dart";
import "package:amaterasu/features/accounts/domain/twitch_account.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "account_repository.g.dart";

/// Repository for authentication-related operations.
///
/// This repository is responsible for storing information used to authenticate
/// the user with the Twitch API.
class AccountRepository {
  final TwitchAuthApiDataSource _twitchAuthApi;
  final TwitchAccountStoreDataSource _accountStore;

  AccountRepository(TwitchAuthApiDataSource apiDataSource, TwitchAccountStoreDataSource accountStoreDataSource)
      : _twitchAuthApi = apiDataSource,
        _accountStore = accountStoreDataSource;

  /// Creates a new [TwitchAccount] with the given [accessToken] and sets it as
  /// the current account.
  ///
  /// If the user is already logged in, the account will be overridden with the
  /// new one.
  ///
  /// Throws an [InvalidTokenException] if the token is invalid.
  ///
  /// Throws a [HttpException] if the request to the validation endpoint fails.
  ///
  /// Returns the created [TwitchAccount].
  Future<TwitchAccount> addAccount(final String accessToken) async {
    final response = await _twitchAuthApi.validateToken(accessToken);
    if (response == null) throw InvalidTokenException();

    // Store the account information in the secure storage.
    final account = TwitchAccount(
      username: response.login,
      userId: response.userId,
      clientId: response.clientId,
      accessToken: accessToken,
    );

    await _accountStore.saveAccount(account);
    return account;
  }

  Future<String?> retrieveCurrentAccountId() async => _accountStore.retrieveCurrentAccountId();

  Future<Map<String, TwitchAccount>> retrieveAccounts() async => _accountStore.retrieveAccounts();

  Future<void> setCurrentAccount(final TwitchAccount account) => _accountStore.setCurrentAccount(account.userId);

  Future<void> unsetCurrentAccount() => _accountStore.unsetCurrentAccount();

  /// Deletes the given [account] from the secure storage.
  ///
  /// If [revoke] is true the access token will be revoked before deleting the
  /// account.
  ///
  ///
  /// Throws a [HttpException] if the request to the revokation endpoint fails.
  Future<void> deleteAccount(final TwitchAccount account, {bool revoke = true}) async {
    if (revoke) await _twitchAuthApi.revokeToken(accessToken: account.accessToken, clientId: account.clientId);
    await _accountStore.deleteAccount(account.userId);
  }

  Future<bool> isValid(final TwitchAccount account) async {
    final response = await _twitchAuthApi.validateToken(account.accessToken);
    return response != null;
  }
}

@riverpod
AccountRepository accountRepository(AccountRepositoryRef ref) {
  return AccountRepository(
    ref.watch(twitchAuthApiDataSourceProvider),
    ref.watch(twitchAccountStoreProvider),
  );
}

@riverpod
Future<Map<String, TwitchAccount>> accounts(AccountsRef ref) {
  return ref.watch(accountRepositoryProvider).retrieveAccounts();
}

// Thrown when an invalid token was provided by the user.
class InvalidTokenException implements Exception {}
