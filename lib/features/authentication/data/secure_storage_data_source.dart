import "package:amaterasu/core/exceptions/storage_exception.dart";
import "package:flutter/services.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "secure_storage_data_source.g.dart";

/// Data source for accessing the native secure storage on the user's device.
///
/// This data source is used to store sensitive information such as access tokens
/// and any other information that should not be stored in plain text.
class SecureStorageDataSource {
  static const String _tokenStorageKey = "twitch_user_access_token";

  final FlutterSecureStorage _storage;

  SecureStorageDataSource(this._storage);

  /// Stores the given [accessToken] in the secure storage.
  ///
  /// Throws a [StorageException] if the storage operation fails.
  Future<void> writeAccessToken(String accessToken) {
    try {
      return _storage.write(key: _tokenStorageKey, value: accessToken);
    } on PlatformException catch (e) {
      throw StorageException(e.message);
    }
  }

  /// Retrieves the access token from the secure storage.
  ///
  /// Returns the token if it exists, otherwise returns null.
  ///
  /// Throws a [StorageException] if the storage operation fails.
  Future<String?> readAccessToken() {
    try {
      return _storage.read(key: _tokenStorageKey);
    } on PlatformException catch (e) {
      throw StorageException(e.message);
    }
  }

  /// Deletes the access token from the secure storage.
  ///
  /// Throws a [StorageException] if the storage operation fails.
  Future<void> deleteAccessToken() {
    try {
      return _storage.delete(key: _tokenStorageKey);
    } on PlatformException catch (e) {
      throw StorageException(e.message);
    }
  }
}

@riverpod
SecureStorageDataSource secureStorageDataSource(SecureStorageDataSourceRef ref) {
  const storage = FlutterSecureStorage();
  return SecureStorageDataSource(storage);
}
