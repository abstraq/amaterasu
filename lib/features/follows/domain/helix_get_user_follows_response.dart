import "package:amaterasu/core/domain/pagination_object.dart";
import "package:amaterasu/features/follows/domain/follow_connection.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "helix_get_user_follows_response.freezed.dart";
part "helix_get_user_follows_response.g.dart";

@freezed
class HelixGetUserFollowsResponse with _$HelixGetUserFollowsResponse {
  const factory HelixGetUserFollowsResponse({
    required int total,
    required List<FollowConnection> data,
    required PaginationObject pagination,
  }) = _HelixGetUserFollowsResponse;

  factory HelixGetUserFollowsResponse.fromJson(Map<String, dynamic> json) =>
      _$HelixGetUserFollowsResponseFromJson(json);
}
