import "package:amaterasu/features/authentication/data/exceptions/twitch_auth_api_exceptions.dart";
import "package:amaterasu/features/authentication/data/sources/secure_storage_data_source.dart";
import "package:amaterasu/features/authentication/data/sources/twitch_auth_api_data_source.dart";
import "package:amaterasu/features/authentication/domain/credentials.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class AuthRepository {
  final TwitchAuthApiDataSource _twitchAuthApiDataSource;
  final SecureStorageDataSource _secureStorageDataSource;

  AuthRepository(Ref ref)
      : _twitchAuthApiDataSource = ref.watch(twitchAuthApiDataSourceProvider),
        _secureStorageDataSource = ref.watch(secureStorageDataSourceProvider);

  Credentials? _cachedCredentials;

  /// Creates new [Credentials] for the user.
  ///
  /// If `isAnonymous` is `true`, the user will be logged in anonymously.
  ///
  /// Otherwise, this method will open a web browser and prompt the user to log
  /// in to their Twitch account and authorize the application. After the user
  /// accepts, the application will receive an access token to make requests to
  /// the Twitch API on behalf of the user. The access token is then stored in the secure
  /// storage of the device.
  ///
  /// Throws a [AuthorizationCancelledException] if the user cancelled the
  /// authorization process.
  ///
  /// Throws a [StateMismatchException] if the state parameter returned by the
  /// Twitch API does not match the state parameter sent by the application. This
  /// may indicate that the user was victim to a CSRF attack.
  ///
  /// Throws a [MalformedCallbackException] if the callback URL returned by the
  /// Twitch API does not contain an access token.
  ///
  /// Throws a [APIResponseException] if the Twitch API returned a non success status
  /// code when validating the token.
  ///
  /// Throws a [StorageException] if the access token could not be stored in the
  /// secure storage of the device.
  Future<Credentials> addCredentials({isAnonymous = false}) async {
    // If the user is signing in anonymously, we don't need to request an access token from the Twitch API.
    if (isAnonymous) return _cachedCredentials = const Credentials.anonymous();

    final token = await _twitchAuthApiDataSource.authorizeClient();
    final tokenInformation = await _twitchAuthApiDataSource.validateToken(token);
    await _secureStorageDataSource.writeAccessToken(token);
    return _cachedCredentials = Credentials.user(
      clientId: tokenInformation.clientId,
      accessToken: token,
      login: tokenInformation.login,
      userId: tokenInformation.userId,
    );
  }

  /// Revokes the access token authorization for the client.
  ///
  /// The access token will be revoked and removed from the secure storage of the
  /// device.
  ///
  /// The access token is then stored in the secure storage of the device.
  ///
  /// Throws a [APIResponseException] if the Twitch API returned a non success status
  /// code when revoking the token or getting the token information.
  ///
  /// Throws a [StorageException] if the access token could not be removed from the
  /// secure storage of the device.
  Future<void> deleteCredentials({bool revoke = true}) async {
    final credentials = await retrieveCredentials();
    if (credentials == null) return;
    if (credentials is UserCredentials) {
      if (revoke) {
        await _twitchAuthApiDataSource.revokeToken(credentials.accessToken, clientId: credentials.clientId);
      }
      await _secureStorageDataSource.deleteAccessToken();
    }
    _cachedCredentials = null;
  }

  /// Retrieves the access token used to make requests to the Twitch API.
  ///
  /// If the access token is cached, it will be returned immediately, otherwise
  /// it will be retrieved from the secure storage of the device.
  ///
  /// Throws a [StorageException] if the access token could not be retrieved from
  /// the secure storage of the device.
  ///
  /// Returns the access token if it was successfully retrieved or null if it was
  /// not found.
  Future<Credentials?> retrieveCredentials() async {
    if (_cachedCredentials != null) return _cachedCredentials;

    final token = await _secureStorageDataSource.readAccessToken();
    if (token == null) return null;

    // If the access token is invalid, we delete it from the secure storage.
    try {
      final tokenInformation = await _twitchAuthApiDataSource.validateToken(token);
      return _cachedCredentials = Credentials.user(
        clientId: tokenInformation.clientId,
        accessToken: token,
        login: tokenInformation.login,
        userId: tokenInformation.userId,
      );
    } on APIResponseException catch (e) {
      if (e.statusCode == 401) {
        await _secureStorageDataSource.deleteAccessToken();
        return null;
      }
      rethrow;
    }
  }

  Future<bool> isCredentialsValid() async {
    final credentials = _cachedCredentials;
    if (credentials == null) return false;

    if (credentials is UserCredentials) {
      try {
        await _twitchAuthApiDataSource.validateToken(credentials.accessToken);
        return true;
      } on APIResponseException catch (e) {
        if (e.statusCode == 401) return false;
        rethrow;
      }
    }
    return false;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(ref));
