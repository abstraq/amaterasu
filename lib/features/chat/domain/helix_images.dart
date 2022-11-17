import 'package:freezed_annotation/freezed_annotation.dart';

part 'helix_images.freezed.dart';

@freezed
class HelixImages with _$HelixImages {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HelixImages({
    required String url1x,
    required String url2x,
    required String url4x,
  }) = _HelixImages;
  factory HelixImages.fromJson(Map<String, dynamic> json) =>
      _$HelixImagesFromJson(json);
}
