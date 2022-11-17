import 'package:amaterasu/features/chat/domain/helix_get_global_emotes.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'helix_get_emote_sets.freezed.dart';

@freezed
class HelixGetEmoteSetsResponse with _$HelixGetEmoteSetsResponse {
  const factory HelixGetEmoteSetsResponse({
    required List<HelixGlobalEmote> data,
    required String template,
  }) = _HelixGetEmoteSetsResponse;
  factory HelixGetEmoteSetsResponse.fromJson(Map<String, dynamic> json) =>
      _$HelixGetEmoteSetsResponseFromJson(json);
}
