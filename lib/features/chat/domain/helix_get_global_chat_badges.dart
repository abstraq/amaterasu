import "package:freezed_annotation/freezed_annotation.dart";

import "package:amaterasu/features/chat/domain/helix_get_channel_chat_badges.dart";

part "helix_get_global_chat_badges.freezed.dart";

@freezed
class HelixGetGlobalChatBadgesResponse with _$HelixGetGlobalChatBadgesResponse {
  const factory HelixGetGlobalChatBadgesResponse({
    required List<HelixChannelChatBadgeSet> data,
  }) = _HelixGetGlobalChatBadgesResponse;
  factory HelixGetGlobalChatBadgesResponse.fromJson(
          Map<String, dynamic> json) =>
      _$HelixGetGlobalChatBadgesResponseFromJson(json);
}
