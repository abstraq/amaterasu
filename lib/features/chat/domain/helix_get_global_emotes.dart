import 'package:freezed_annotation/freezed_annotation.dart';

import 'helix_images.dart';

part 'helix_get_global_emotes.freezed.dart';

@freezed
class HelixGetGlobalEmotesResponse with _$HelixGetGlobalEmotesResponse {
  const factory HelixGetGlobalEmotesResponse({
    required int total,
    required List<HelixGlobalEmote> data,
    required String template,
  }) = _HelixGetGlobalEmotesResponse;
  factory HelixGetGlobalEmotesResponse.fromJson(Map<String, dynamic> json) =>
      _$HelixGetGlobalEmotesResponseFromJson(json);
}

@freezed
class HelixGlobalEmote with _$HelixGlobalEmote {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HelixGlobalEmote({
    required String id,
    required String name,
    required HelixImages images,
    required List<String> format,
    required List<String> scale,
    required List<String> themeMode,
  }) = _HelixGlobalEmote;
  factory HelixGlobalEmote.fromJson(Map<String, dynamic> json) =>
      _$HelixGlobalEmoteFromJson(json);
}
