import "package:amaterasu/features/accounts/domain/twitch_account.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "twitch_account_store.freezed.dart";
part "twitch_account_store.g.dart";

@freezed
class TwitchAccountStore with _$TwitchAccountStore {
  const factory TwitchAccountStore({
    String? currentAccountId,
    required Map<String, TwitchAccount> accounts,
  }) = _TwitchAccountStore;

  factory TwitchAccountStore.fromJson(Map<String, dynamic> json) => _$TwitchAccountStoreFromJson(json);
}
