import "package:freezed_annotation/freezed_annotation.dart";

part "emote_image_assets.freezed.dart";

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
