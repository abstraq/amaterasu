import "package:freezed_annotation/freezed_annotation.dart";

part "helix_get_channel_chat_badges.freezed.dart";
part "helix_get_channel_chat_badges.g.dart";

@freezed
class HelixGetBadgesResponse with _$HelixGetBadgesResponse {
  const factory HelixGetBadgesResponse({
    required List<HelixChannelChatBadgeSet> data,
  }) = _HelixGetBadgesResponse;
  factory HelixGetBadgesResponse.fromJson(Map<String, dynamic> json) =>
      _$HelixGetBadgesResponseFromJson(json);
}

@freezed
class HelixChannelChatBadgeSet with _$HelixChannelChatBadgeSet {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HelixChannelChatBadgeSet({
    required String setId,
    required List<HelixChatBadge> versions,
  }) = _HelixChannelChatBadgeSet;
  factory HelixChannelChatBadgeSet.fromJson(Map<String, dynamic> json) =>
      _$HelixChannelChatBadgeSetFromJson(json);
}

@freezed
class HelixChatBadge with _$HelixChatBadge {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HelixChatBadge({
    required String id,
    @JsonKey(name: "image_url_1x") required String imageUrl1x,
    @JsonKey(name: "image_url_2x") required String imageUrl2x,
    @JsonKey(name: "image_url_4x") required String imageUrl4x,
  }) = _HelixChatBadge;
  factory HelixChatBadge.fromJson(Map<String, dynamic> json) =>
      _$HelixChatBadgeFromJson(json);
}
