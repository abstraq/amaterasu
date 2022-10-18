import "package:freezed_annotation/freezed_annotation.dart";

part "validate_token_response.freezed.dart";
part "validate_token_response.g.dart";

@freezed
class ValidateTokenResponse with _$ValidateTokenResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ValidateTokenResponse({
    required String clientId,
    required String login,
    required String userId,
    required List<String> scopes,
    required int expiresIn,
  }) = _ValidateTokenResponse;

  factory ValidateTokenResponse.fromJson(Map<String, dynamic> json) => _$ValidateTokenResponseFromJson(json);
}
