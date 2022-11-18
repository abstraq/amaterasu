import "package:freezed_annotation/freezed_annotation.dart";
import "package:amaterasu/core/domain/pagination_object.dart";

part "helix_get_chatters_response.freezed.dart";
part "helix_get_chatters_response.g.dart";

@freezed
class HelixGetChattersResponse with _$HelixGetChattersResponse {
  const factory HelixGetChattersResponse({
    required int total,
    required List<HelixChatter> chatters,
    required PaginationObject pagination,
  }) = _HelixGetChattersResponse;
}

@freezed
class HelixChatter with _$HelixChatter {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HelixChatter({
    required String userLogin,
  }) = _HelixChatter;
  factory HelixChatter.fromJson(Map<String, dynamic> json) =>
      _$HelixChatterFromJson(json);
}
