import 'package:freezed_annotation/freezed_annotation.dart';

import 'helix_images.dart';

part 'helix_get_channel_emotes.freezed.dart';
part 'helix_get_channel_emotes.g.dart';

@freezed
class HelixGetChannelEmotesResponse with _$HelixGetChannelEmotesResponse {
  const factory HelixGetChannelEmotesResponse({
    required int total,
    required List<HelixChannelEmote> data,
    required String template,
  }) = _HelixGetChannelEmotesResponse;
  factory HelixGetChannelEmotesResponse.fromJson(Map<String, dynamic> json) =>
      _$HelixGetChannelEmotesResponseFromJson(json);
}

@freezed
class HelixChannelEmote with _$HelixChannelEmote {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HelixChannelEmote({
    required String id,
    required String name,
    required HelixImages images,
    required List<String> format,
    required List<String> scale,
    required List<String> themeMode,
    required String emoteType,
    required String emoteSetId,
  }) = _HelixChannelEmote;
  factory HelixChannelEmote.fromJson(Map<String, dynamic> json) =>
      _$HelixChannelEmoteFromJson(json);
}
