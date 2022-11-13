import "package:amaterasu/core/domain/pagination_object.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "helix_get_user_follows_response.freezed.dart";
part "helix_get_user_follows_response.g.dart";

@freezed
class HelixGetUserFollowsResponse with _$HelixGetUserFollowsResponse {
  const factory HelixGetUserFollowsResponse({
    required int total,
    required List<HelixFollowRelationship> data,
    required PaginationObject pagination,
  }) = _HelixGetUserFollowsResponse;

  factory HelixGetUserFollowsResponse.fromJson(Map<String, dynamic> json) =>
      _$HelixGetUserFollowsResponseFromJson(json);
}

@freezed
class HelixFollowRelationship with _$HelixFollowRelationship {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HelixFollowRelationship({
    required String fromId,
    required String toId,
    required DateTime followedAt,
  }) = _HelixFollowRelationship;

  factory HelixFollowRelationship.fromJson(Map<String, dynamic> json) => _$HelixFollowRelationshipFromJson(json);
}
