import "package:amaterasu/features/chat/domain/helix_chat_emote.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "helix_get_chat_emotes.freezed.dart";
part "helix_get_chat_emotes.g.dart";

@freezed
class HelixGetChatEmotesResponse with _$HelixGetChatEmotesResponse {
  const factory HelixGetChatEmotesResponse({
    required List<HelixChatEmote> data,
    required String template,
  }) = _HelixGetChatEmotesResponse;
  factory HelixGetChatEmotesResponse.fromJson(Map<String, dynamic> json) =>
      _$HelixGetChatEmotesResponseFromJson(json);
}
