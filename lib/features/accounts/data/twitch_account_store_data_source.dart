import "dart:convert";

import "package:amaterasu/features/accounts/domain/twitch_account.dart";
import "package:amaterasu/features/accounts/domain/twitch_account_store.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "twitch_account_store_data_source.g.dart";

class TwitchAccountStoreDataSource {
  static const _key = "twitch_account_store";

  final FlutterSecureStorage _storage;

  TwitchAccountStoreDataSource(this._storage);

  Future<void> saveAccount(final TwitchAccount account, {bool setCurrent = true}) async {
    final store = await _store();
    final updatedStore = store.copyWith(
      accounts: {...store.accounts, account.userId: account},
      currentAccountId: setCurrent ? account.userId : store.currentAccountId,
    );

    return _persist(updatedStore);
  }

  Future<String?> retrieveCurrentAccountId() async {
    final store = await _store();
    return store.currentAccountId;
  }

  Future<Map<String, TwitchAccount>> retrieveAccounts() async {
    final store = await _store();
    return store.accounts;
  }

  Future<void> setCurrentAccount(String userId) async {
    final store = await _store();
    final updatedStore = store.copyWith(currentAccountId: userId);

    return _persist(updatedStore);
  }

  Future<void> unsetCurrentAccount() async {
    final store = await _store();
    final updatedStore = store.copyWith(currentAccountId: null);

    return _persist(updatedStore);
  }

  Future<void> deleteAccount(final String userId) async {
    final store = await _store();
    final updatedStore = store.copyWith(
      accounts: {...store.accounts}..remove(userId),
      currentAccountId: store.currentAccountId == userId ? null : store.currentAccountId,
    );

    return _persist(updatedStore);
  }

  Future<TwitchAccountStore> _store() async {
    final serializedStore = await _storage.read(key: _key);
    if (serializedStore == null) return const TwitchAccountStore(accounts: {});

    return TwitchAccountStore.fromJson(json.decode(serializedStore));
  }

  Future<void> _persist(final TwitchAccountStore store) async {
    final serializedStore = json.encode(store.toJson());
    await _storage.write(key: _key, value: serializedStore);
  }
}

@riverpod
TwitchAccountStoreDataSource twitchAccountStore(TwitchAccountStoreRef ref) {
  const secureStorage = FlutterSecureStorage();
  return TwitchAccountStoreDataSource(secureStorage);
}
