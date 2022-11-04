import "package:amaterasu/features/accounts/data/twitch_account_preferences_data_source.dart";
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
  final TwitchAccountPreferencesDataSource _accountPreferences;

  AccountRepository(TwitchAuthApiDataSource apiDataSource, TwitchAccountPreferencesDataSource preferencesDataSource)
      : _twitchAuthApi = apiDataSource,
        _accountPreferences = preferencesDataSource;

  /// Stores the given [accessToken] in the secure storage.
  ///
  /// Retrieves information about the Twitch account associated with the given
  /// access token and stores the token in the secure storage.
  ///
  /// Throws an [HttpException] if the validation API call fails.
  /// Throws an [InvalidTokenException] if the given [accessToken] is invalid.
  ///
  /// Returns the [TwitchAccount] associated with the given access token.
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

    await _accountPreferences.saveAccount(account);
    return account;
  }

  Future<void> deleteAccount(final TwitchAccount account, {bool revoke = true}) async {
    if (revoke) await _twitchAuthApi.revokeToken(accessToken: account.accessToken, clientId: account.clientId);
    await _accountPreferences.deleteAccount(account.userId);

    // If the deleted account was the current account, unset the current account.
    if (_accountPreferences.currentAccount()?.userId == account.userId) {
      await _accountPreferences.unsetCurrentAccount();
    }
  }

  Future<void> setCurrentAccount(final TwitchAccount account) => _accountPreferences.setCurrentAccount(account.userId);

  Future<void> unsetCurrentAccount() => _accountPreferences.unsetCurrentAccount();

  Future<bool> isValid(final TwitchAccount account) async {
    final response = await _twitchAuthApi.validateToken(account.accessToken);
    return response != null;
  }

  TwitchAccount? currentAccount() => _accountPreferences.currentAccount();
}

@riverpod
AccountRepository accountRepository(AccountRepositoryRef ref) {
  return AccountRepository(
    ref.watch(twitchAuthApiDataSourceProvider),
    ref.watch(twitchAccountPreferencesProvider),
  );
}

@riverpod
List<TwitchAccount> twitchAccounts(TwitchAccountsRef ref) {
  return ref.watch(twitchAccountPreferencesProvider).accounts();
}

// Thrown when an invalid token was provided by the user.
class InvalidTokenException implements Exception {}
