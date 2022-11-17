import 'package:freezed_annotation/freezed_annotation.dart';
part 'helix_get_user_chat_color.freezed.dart';
part 'helix_get_user_chat_color.g.dart';

@freezed
class HelixGetUserChatColorResponse with _$HelixGetUserChatColorResponse {
  const factory HelixGetUserChatColorResponse({
    required HelixUserChatColor data,
  }) = _HelixGetUserChatColorResponse;
  factory HelixGetUserChatColorResponse.fromJson(Map<String, dynamic> json) =>
      _$HelixGetUserChatColorResponseFromJson(json);
}

@freezed
class HelixUserChatColor with _$HelixUserChatColor {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HelixUserChatColor({
    required String userId,
    required String userLogin,
    required String userName,
    required String color,
  }) = _HelixUserChatColor;
  factory HelixUserChatColor.fromJson(Map<String, dynamic> json) =>
      _$HelixUserChatColorFromJson(json);
}
