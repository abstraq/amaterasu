import "package:freezed_annotation/freezed_annotation.dart";

part "credentials.freezed.dart";

@freezed
class Credentials with _$Credentials {
  const factory Credentials.user({
    required String clientId,
    required String accessToken,
    required String login,
    required String userId,
  }) = UserCredentials;

  const factory Credentials.anonymous() = AnonymousCredentials;
}
