import "package:freezed_annotation/freezed_annotation.dart";

part "twitch_user.freezed.dart";
part "twitch_user.g.dart";

@freezed
class TwitchUser with _$TwitchUser {
  const TwitchUser._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TwitchUser({
    required String id,
    required String login,
    required String displayName,
    required String description,
    required String profileImageUrl,
    required String offlineImageUrl,
    required String type,
    required String broadcasterType,
    required DateTime createdAt,
  }) = _TwitchUser;

  factory TwitchUser.fromJson(Map<String, dynamic> json) => _$TwitchUserFromJson(json);

  factory TwitchUser.fromMap(Map<String, Object?> map) => TwitchUser(
        id: map["id"] as String,
        login: map["login"] as String,
        displayName: map["display_name"] as String,
        description: map["description"] as String,
        profileImageUrl: map["profile_image_url"] as String,
        offlineImageUrl: map["offline_image_url"] as String,
        type: map["type"] as String,
        broadcasterType: map["broadcaster_type"] as String,
        createdAt: DateTime.parse(map["created_at"] as String),
      );

  Map<String, Object?> toMap() => {
        "id": id,
        "login": login,
        "display_name": displayName,
        "description": description,
        "profile_image_url": profileImageUrl,
        "offline_image_url": offlineImageUrl,
        "type": type,
        "broadcaster_type": broadcasterType,
        "created_at": createdAt.toIso8601String(),
      };
}
