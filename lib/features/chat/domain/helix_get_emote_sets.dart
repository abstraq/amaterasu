import "package:amaterasu/features/chat/domain/helix_chat_emote.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "helix_get_emote_sets.freezed.dart";
part "helix_get_emote_sets.g.dart";

@freezed
class HelixGetEmoteSetsResponse with _$HelixGetEmoteSetsResponse {
  const factory HelixGetEmoteSetsResponse({
    required List<HelixChatEmote> data,
    required String template,
  }) = _HelixGetEmoteSetsResponse;
  factory HelixGetEmoteSetsResponse.fromJson(Map<String, dynamic> json) =>
      _$HelixGetEmoteSetsResponseFromJson(json);
}
