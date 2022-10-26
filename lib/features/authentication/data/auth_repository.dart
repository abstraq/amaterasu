import "package:amaterasu/features/authentication/data/secure_storage_data_source.dart";
import "package:amaterasu/features/authentication/data/twitch_auth_api_data_source.dart";
import "package:amaterasu/features/authentication/domain/twitch_account.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "auth_repository.g.dart";

/// Repository for authentication-related operations.
///
/// This repository is responsible for storing information used to authenticate
/// the user with the Twitch API.
class AuthRepository {
  final TwitchAuthApiDataSource _twitchAuthApiDataSource;
  final SecureStorageDataSource _secureStorageDataSource;

  AuthRepository(TwitchAuthApiDataSource twitchAuthApiDataSource, SecureStorageDataSource secureStorageDataSource)
      : _twitchAuthApiDataSource = twitchAuthApiDataSource,
        _secureStorageDataSource = secureStorageDataSource;

  /// Stores the given [accessToken] in the secure storage.
  ///
  /// Retrieves information about the Twitch account associated with the given
  /// access token and stores the token in the secure storage.
  ///
  /// Throws a [StorageException] if the storage operation fails.
  /// Throws a [HttpException] if the API call fails.
  ///
  /// Returns the [TwitchAccount] associated with the given access token.
  Future<TwitchAccount> addTwitchAccount(final String accessToken) async {
    final response = await _twitchAuthApiDataSource.validateToken(accessToken);
    await _secureStorageDataSource.writeAccessToken(accessToken);

    final id = response!.userId;
    final username = response.login;
    final clientId = response.clientId;

    return TwitchAccount(id: id, username: username, accessToken: accessToken, clientId: clientId);
  }

  /// Retrieves the [TwitchAccount] of the currently authenticated user.
  ///
  /// If the token of the currently authenticated user is invalid this method
  /// will silently delete it from the secure storage and return null.
  ///
  /// Returns the [TwitchAccount] if it exists, otherwise returns null.
  ///
  /// Throws a [StorageException] if the storage operation fails.
  /// Throws a [HttpException] if the API call fails.
  Future<TwitchAccount?> retrieveTwitchAccount() async {
    final accessToken = await _secureStorageDataSource.readAccessToken();
    if (accessToken == null) return null;

    final response = await _twitchAuthApiDataSource.validateToken(accessToken);

    // If the token is invalid, remove it from the secure storage.
    if (response == null) {
      await _secureStorageDataSource.deleteAccessToken();
      return null;
    }

    final id = response.userId;
    final username = response.login;
    final clientId = response.clientId;

    return TwitchAccount(id: id, username: username, accessToken: accessToken, clientId: clientId);
  }

  /// Revokes the access token of the currently authenticated user and deletes
  /// it from the secure storage.
  ///
  /// Throws a [StorageException] if the storage operation fails.
  /// Throws a [HttpException] if the API call fails.
  Future<void> deleteTwitchAccount() async {
    final account = await retrieveTwitchAccount();
    if (account == null) return;

    await _twitchAuthApiDataSource.revokeToken(accessToken: account.accessToken, clientId: account.clientId);
    await _secureStorageDataSource.deleteAccessToken();
  }
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(
    ref.watch(twitchAuthApiDataSourceProvider),
    ref.watch(secureStorageDataSourceProvider),
  );
}
