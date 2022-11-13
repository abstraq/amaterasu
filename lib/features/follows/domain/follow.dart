import "package:amaterasu/features/users/domain/twitch_user.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "follow.freezed.dart";

@freezed
class Follow with _$Follow {
  const Follow._();

  const factory Follow({
    required DateTime followedAt,
    required String userId,
    required String broadcasterId,
    TwitchUser? broadcaster,
  }) = _Follow;

  factory Follow.fromMap(Map<String, Object?> map) => Follow(
        followedAt: DateTime.parse(map["followed_at"] as String),
        userId: map["user_id"] as String,
        broadcasterId: map["broadcaster_id"] as String,
      );

  Map<String, Object?> toMap() => {
        "followed_at": followedAt.toIso8601String(),
        "user_id": userId,
        "broadcaster_id": broadcasterId,
      };
}
