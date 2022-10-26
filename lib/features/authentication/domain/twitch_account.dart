import "package:freezed_annotation/freezed_annotation.dart";

part "twitch_account.freezed.dart";

/// Represents an account on Twitch.
///
/// Contains authorization information to access the Twitch API
/// on the user's behalf.
@freezed
class TwitchAccount with _$TwitchAccount {
  const factory TwitchAccount({
    required String id,
    required String username,
    required String accessToken,
    required String clientId,
  }) = _TwitchAccount;
}
