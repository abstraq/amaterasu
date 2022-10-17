import "package:amaterasu/features/authentication/data/exceptions/secure_storage_exceptions.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";

class SecureStorageDataSource {
  static const String _tokenStorageKey = "twitch_user_access_token";

  final FlutterSecureStorage _storage;

  SecureStorageDataSource(this._storage);

  Future<void> writeAccessToken(String accessToken) {
    try {
      return _storage.write(key: _tokenStorageKey, value: accessToken);
    } catch (e) {
      throw StorageException();
    }
  }

  Future<String?> readAccessToken() {
    try {
      return _storage.read(key: _tokenStorageKey);
    } catch (e) {
      throw StorageException();
    }
  }

  Future<void> deleteAccessToken() {
    try {
      return _storage.delete(key: _tokenStorageKey);
    } catch (e) {
      throw StorageException();
    }
  }
}

final secureStorageDataSourceProvider = Provider<SecureStorageDataSource>((ref) {
  const storage = FlutterSecureStorage(aOptions: AndroidOptions(resetOnError: true));
  return SecureStorageDataSource(storage);
});
