import 'package:freezed_annotation/freezed_annotation.dart';

part 'helix_get_channel_chat_badges.freezed.dart';
part 'helix_get_channel_chat_badges.g.dart';

@freezed
class HelixGetChannelChatBadgesResponse
    with _$HelixGetChannelChatBadgesResponse {
  const factory HelixGetChannelChatBadgesResponse({
    required List<HelixChannelChatBadge> data,
  }) = _HelixGetChannelChatBadgesResponse;
  factory HelixGetChannelChatBadgesResponse.fromJson(
          Map<String, dynamic> json) =>
      _$HelixGetChannelChatBadgesResponseFromJson(json);
}

@freezed
class HelixChannelChatBadge with _$HelixChannelChatBadge {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HelixChannelChatBadge({
    required String setId,
    required List<HelixChannelChatBadgeVersion> versions,
  }) = _HelixChannelChatBadge;
  factory HelixChannelChatBadge.fromJson(Map<String, dynamic> json) =>
      _$HelixChannelChatBadgeFromJson(json);
}

@freezed
class HelixChannelChatBadgeVersion with _$HelixChannelChatBadgeVersion {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HelixChannelChatBadgeVersion({
    required String id,
    required String imageUrl1x,
    required String imageUrl2x,
    required String imageUrl4x,
  }) = _HelixChannelChatBadgeVersion;
  factory HelixChannelChatBadgeVersion.fromJson(Map<String, dynamic> json) =>
      _$HelixChannelChatBadgeVersionFromJson(json);
}
