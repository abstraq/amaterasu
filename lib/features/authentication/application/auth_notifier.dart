import "dart:async";

import "package:amaterasu/features/authentication/data/auth_repository.dart";
import "package:amaterasu/features/authentication/domain/twitch_account.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "auth_notifier.g.dart";

/// Implementation of [AsyncNotifier] that manages the authentication state
/// of the application.
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<TwitchAccount?> build() async {
    // If the user is signed in,start a validation timer that checks if the
    // token is valid every hour.
    //
    // See https://dev.twitch.tv/docs/authentication/validate-tokens for more
    // information.
    ref.listenSelf((_, current) {
      final account = current.valueOrNull;
      Timer? validationTimer;
      if (account != null) {
        validationTimer = Timer.periodic(const Duration(hours: 1), (timer) async {
          final account = await ref.watch(authRepositoryProvider).retrieveTwitchAccount();
          // If the token is invalid, it will be silently removed from the storage so
          // we can just stop the timer and update the state.
          if (account == null) {
            timer.cancel();
            state = const AsyncData(null);
          }
        });
      } else {
        validationTimer?.cancel();
        validationTimer = null;
      }

      ref.onDispose(() => validationTimer?.cancel());
    });

    return ref.watch(authRepositoryProvider).retrieveTwitchAccount();
  }

  /// Signs in the user with the given [accessToken].
  ///
  /// The [accessToken] is stored in the secure storage and will be used to
  /// authenticate requests to the Twitch API.
  Future<void> login(final String accessToken) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final account = await ref.watch(authRepositoryProvider).addTwitchAccount(accessToken);
      return account;
    });
  }

  /// Signs the user out of the application.
  ///
  /// This will remove the user's access token from the storage and revoke it.
  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.watch(authRepositoryProvider).deleteTwitchAccount();
      return null;
    });
  }

  bool get isLoading => state.isLoading;

  bool get isAuthenticated => state.valueOrNull != null;
}
