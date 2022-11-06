import "package:freezed_annotation/freezed_annotation.dart";

part "twitch_account.freezed.dart";
part "twitch_account.g.dart";

@freezed
class TwitchAccount with _$TwitchAccount {
  const factory TwitchAccount({
    required String username,
    required String userId,
    required String clientId,
    required String accessToken,
  }) = _TwitchAccount;

  factory TwitchAccount.fromJson(Map<String, dynamic> json) => _$TwitchAccountFromJson(json);
}
