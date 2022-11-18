import "package:freezed_annotation/freezed_annotation.dart";

part "helix_chat_emote.freezed.dart";
part "helix_chat_emote.g.dart";

@freezed
class HelixChatEmote with _$HelixChatEmote {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HelixChatEmote({
    required String id,
    required String name,
    required EmoteImageAssets images,
    required List<String> format,
    required List<String> scale,
    required List<String> themeMode,
    String? tier,
    String? emoteType,
    String? emoteSetId,
    String? ownerId,
  }) = _HelixChatEmote;
  factory HelixChatEmote.fromJson(Map<String, dynamic> json) =>
      _$HelixChatEmoteFromJson(json);
}

@freezed
class EmoteImageAssets with _$EmoteImageAssets {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory EmoteImageAssets({
    @JsonKey(name: "url_1x") required String url1x,
    @JsonKey(name: "url_2x") required String url2x,
    @JsonKey(name: "url_4x") required String url4x,
  }) = _EmoteImageAssets;
  factory EmoteImageAssets.fromJson(Map<String, dynamic> json) =>
      _$EmoteImageAssetsFromJson(json);
}
