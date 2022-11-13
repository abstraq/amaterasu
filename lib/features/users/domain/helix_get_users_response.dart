import "package:amaterasu/features/users/domain/twitch_user.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "helix_get_users_response.freezed.dart";
part "helix_get_users_response.g.dart";

@freezed
class HelixGetUsersResponse with _$HelixGetUsersResponse {
  const factory HelixGetUsersResponse({required List<TwitchUser> data}) = _HelixGetUsersResponse;

  factory HelixGetUsersResponse.fromJson(Map<String, dynamic> json) => _$HelixGetUsersResponseFromJson(json);
}
