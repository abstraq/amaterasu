import "dart:convert";

import "package:amaterasu/core/data/shared_preferences.dart";
import "package:amaterasu/features/accounts/domain/twitch_account.dart";
import "package:amaterasu/features/accounts/domain/twitch_account_preferences.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "twitch_account_preferences_data_source.g.dart";

class TwitchAccountPreferencesDataSource {
  static const _preferenceKey = "twitch_account_preferences";

  final SharedPreferences _sharedPreferences;

  TwitchAccountPreferencesDataSource(this._sharedPreferences);

  Future<void> saveAccount(final TwitchAccount account) {
    final preferences = _preferences() ?? const TwitchAccountPreferences(accounts: {});
    final accounts = {...preferences.accounts, account.userId: account};

    return _savePreferences(preferences.copyWith(accounts: accounts));
  }

  Future<void> deleteAccount(final String userId) {
    final preferences = _preferences() ?? const TwitchAccountPreferences(accounts: {});
    final accounts = {...preferences.accounts};
    accounts.remove(userId);

    return _savePreferences(preferences.copyWith(accounts: accounts));
  }

  Future<void> setCurrentAccount(String userId) {
    final preferences = _preferences() ?? const TwitchAccountPreferences(accounts: {});
    return _savePreferences(preferences.copyWith(currentAccountId: userId));
  }

  Future<void> unsetCurrentAccount() {
    final preferences = _preferences() ?? const TwitchAccountPreferences(accounts: {});
    return _savePreferences(preferences.copyWith(currentAccountId: null));
  }

  TwitchAccount? currentAccount() {
    final currentAccountId = _preferences()?.currentAccountId;
    return _preferences()?.accounts[currentAccountId];
  }

  TwitchAccount? account(String userId) => _preferences()?.accounts[userId];

  List<TwitchAccount> accounts() => _preferences()?.accounts.values.toList() ?? [];

  TwitchAccountPreferences? _preferences() {
    final serializedPreferences = _sharedPreferences.getString(_preferenceKey);
    if (serializedPreferences == null) return null;

    final data = json.decode(serializedPreferences);
    return TwitchAccountPreferences.fromJson(data);
  }

  Future<void> _savePreferences(final TwitchAccountPreferences preferences) async {
    final serializedPreferences = json.encode(preferences.toJson());
    await _sharedPreferences.setString(_preferenceKey, serializedPreferences);
  }
}

@riverpod
TwitchAccountPreferencesDataSource twitchAccountPreferences(TwitchAccountPreferencesRef ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return TwitchAccountPreferencesDataSource(sharedPreferences);
}
