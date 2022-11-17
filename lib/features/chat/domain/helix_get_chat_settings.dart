import 'package:freezed_annotation/freezed_annotation.dart';
part 'helix_get_chat_settings.freezed.dart';
part 'helix_get_chat_settings.g.dart';

@freezed
class HelixGetChatSettingsResponse with _$HelixGetChatSettingsResponse {
  const factory HelixGetChatSettingsResponse({
    required List<HelixChatSettings> data,
  }) = _HelixGetChatSettingsResponse;
  factory HelixGetChatSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$HelixGetChatSettingsResponseFromJson(json);
}

@freezed
class HelixChatSettings with _$HelixChatSettings {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HelixChatSettings({
    required String broadcasterId,
    required bool slowMode,
    @Default(null) int slowModeWaitTime,
    required bool followerMode,
    required int followerModeDuration,
    required bool subscriberMode,
    required bool emoteMode,
    required bool uniqueChatMode,
    required bool nonModeratorChatDelay,
    required int nonModeratorChatDelayDuration,
  }) = _HelixChatSettings;
  factory HelixChatSettings.fromJson(Map<String, dynamic> json) =>
      _$HelixChatSettingsFromJson(json);
}
