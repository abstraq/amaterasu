import "package:amaterasu/features/accounts/domain/twitch_account.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "twitch_account_preferences.freezed.dart";
part "twitch_account_preferences.g.dart";

@freezed
class TwitchAccountPreferences with _$TwitchAccountPreferences {
  const factory TwitchAccountPreferences({
    String? currentAccountId,
    required Map<String, TwitchAccount> accounts,
  }) = _TwitchAccountPreferences;

  factory TwitchAccountPreferences.fromJson(Map<String, dynamic> json) => _$TwitchAccountPreferencesFromJson(json);
}
