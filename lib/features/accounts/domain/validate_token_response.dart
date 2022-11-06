import "package:freezed_annotation/freezed_annotation.dart";

part "validate_token_response.freezed.dart";
part "validate_token_response.g.dart";

/// Represents the response from the Twitch API when validating a token.
///
/// See https://dev.twitch.tv/docs/authentication/validate-tokens for more
/// information.
@freezed
class ValidateTokenResponse with _$ValidateTokenResponse {
  /// Creates a new [ValidateTokenResponse].
  ///
  /// This constructor is used by the [fromJson] factory. The api returns
  /// results in snake_case, so we need use a fieldRename convert them to
  /// camelCase.
  ///
  /// The [expiresIn] field is a [Duration] in milliseconds however, it
  /// is not used by the app currently so we just deserialize it as an
  /// int.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ValidateTokenResponse({
    required String clientId,
    required String login,
    required List<String> scopes,
    required String userId,
    required int expiresIn,
  }) = _ValidateTokenResponse;

  factory ValidateTokenResponse.fromJson(Map<String, dynamic> json) => _$ValidateTokenResponseFromJson(json);
}
