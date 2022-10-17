import "package:amaterasu/features/authentication/data/sources/secure_storage_data_source.dart";
import "package:amaterasu/features/authentication/data/sources/twitch_auth_api_data_source.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class AuthRepository {
  final TwitchAuthApiDataSource _twitchAuthApiDataSource;
  final SecureStorageDataSource _secureStorageDataSource;

  AuthRepository(Ref ref)
      : _twitchAuthApiDataSource = ref.watch(twitchAuthApiDataSourceProvider),
        _secureStorageDataSource = ref.watch(secureStorageDataSourceProvider);

  String? _cachedToken;

  /// Prompts the user to authorize the application.
  ///
  /// This method will open a web browser and prompt the user to log in to their
  /// Twitch account and authorize the application. After the user accepts, the
  /// application will receive an access token to make requests to the Twitch API
  /// on behalf of the user.
  ///
  /// The access token is then stored in the secure storage of the device.
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
  /// Throws a [StorageException] if the access token could not be stored in the
  /// secure storage of the device.
  Future<void> authorize() async {
    final token = await _twitchAuthApiDataSource.authorizeClient();
    await _secureStorageDataSource.writeAccessToken(token);
    _cachedToken = token;
  }

  /// Revokes the access token authorization for the client.
  ///
  /// The access token will be revoked and removed from the secure storage of the
  /// device.
  ///
  /// The access token is then stored in the secure storage of the device.
  ///
  /// Throws a [StorageException] if the access token could not be removed from the
  /// secure storage of the device.
  Future<void> revoke() async {
    final token = _cachedToken;
    if (token != null) {
      await _secureStorageDataSource.deleteAccessToken();
      _cachedToken = null;
    }
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
  Future<String?> retrieveCurrentAccessToken() async {
    if (_cachedToken != null) return _cachedToken;
    final token = await _secureStorageDataSource.readAccessToken();
    _cachedToken = token;
    return token;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(ref));
