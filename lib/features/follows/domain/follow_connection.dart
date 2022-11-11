import "package:freezed_annotation/freezed_annotation.dart";

part "follow_connection.freezed.dart";
part "follow_connection.g.dart";

@freezed
class FollowConnection with _$FollowConnection {
  const FollowConnection._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory FollowConnection({
    required DateTime followedAt,
    required String fromId,
    required String toId,
  }) = _FollowConnection;

  factory FollowConnection.fromJson(Map<String, dynamic> json) => _$FollowConnectionFromJson(json);

  factory FollowConnection.fromMap(Map<String, Object?> map) => FollowConnection(
        followedAt: DateTime.parse(map["followed_at"] as String),
        fromId: map["from_id"] as String,
        toId: map["to_id"] as String,
      );

  Map<String, Object?> toMap() => {"followed_at": followedAt.toIso8601String(), "from_id": fromId, "to_id": toId};
}
